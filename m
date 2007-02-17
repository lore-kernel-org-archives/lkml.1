Return-Path: <linux-kernel-owner+w=401wt.eu-S965315AbXBQQoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965315AbXBQQoU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 11:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965322AbXBQQoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 11:44:20 -0500
Received: from nz-out-0506.google.com ([64.233.162.239]:38981 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965315AbXBQQoT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 11:44:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=B3+sn+OISdRc5bxTu/RkNOGT3e4o7i0B26e8wsv9fbpyroVl2bB25PMNUcqoGGHYk9FzNibbs0il4+aSn4NBa8E9VFR52Sq2qi4H+5ia3uUHDmyyceIOm66j0ffc4mDks3pNoyo5w1iG2I6QffUK9QukY9Hd1LJxModpX112xMA=
Message-ID: <edd3ff190702170844q120c5f92l6c7c385665048c16@mail.gmail.com>
Date: Sat, 17 Feb 2007 17:44:18 +0100
From: "=?ISO-8859-1?Q?Daniel_Aragon=E9s?=" <danarag@gmail.com>
To: "=?ISO-8859-1?Q?C=E9dric_Augonnet?=" <cedric.augonnet@gmail.com>
Subject: Re: 2.6.20-mm1 - Oops using Minix 3 file system
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Cedric.augonnet@ens-lyon.org
In-Reply-To: <f56c1ba00702170551k7cbbf79dkfc550e3d4b387d4c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <f56c1ba00702161500x775fe04bl91889b5819cf9ddc@mail.gmail.com>
	 <edd3ff190702170255w1c30fa08v96e5b92baacbd701@mail.gmail.com>
	 <f56c1ba00702170551k7cbbf79dkfc550e3d4b387d4c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/17/07, Cédric Augonnet <cedric.augonnet@gmail.com> wrote:

> It appears that the trouble is in  the count_free of file
> fs/minix/bitmap.c . This procedure is actually called twice when we
> issue a df command.
> The point where things start to get strange is
>         i = ((numbits - (numblocks-1) * bh->b_size * 8) / 16) * 2; at line 36
>
> In the first call to that procedure i have
>        i = 3506
>        bh->b_data = 0xd4e79000
>
> Whereas in the second call i have something much different :
>        i = 536838736
>        bh->b_data = d4e78000
>

Well, that line is modified by my patch. The original one is:
i = ((numbits-(numblocks-1)*BLOCK_SIZE*8)/16)*2;

As you see, the constant is substituted by a variable. As you are
running under emulation, the true value of that variable ( 4096 in
standard minix3 releases, instead of the constant 1024 in minix1 and
minix2), is probably found where it should not be found, or not found
at all. And the result is what you show. Minix 3 provides for a
variable size of the blocks. Try to find what block size you are
emulating.

Also, though your dmesg shows a mounted loop partition, the minix
subpartition in it is not stated. So it cannot be accessed.

By the way, you don't need to support minix on your Linux box to run
it through an emulator, do you?

Regards

Daniel
