Return-Path: <linux-kernel-owner+w=401wt.eu-S1946739AbXBQNvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946739AbXBQNvo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 08:51:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946742AbXBQNvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 08:51:44 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:22860 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946739AbXBQNvm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 08:51:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dxJ2AkIIv90a1JYbUq8Emm9CKLiPwyBZIqYdF2VSlmHRAOcbyZyRgal9rKlUFhkxKZPbYjbK0k70R9Ily88kZ8QPyimBEET7qYynX3B41ls6FLI/4MYFnBTxO6jQRGAklEC7kw1tFdTbKBxywP3V8t8BISkdrT6feVn57gN0PW4=
Message-ID: <f56c1ba00702170551k7cbbf79dkfc550e3d4b387d4c@mail.gmail.com>
Date: Sat, 17 Feb 2007 14:51:41 +0100
From: "=?ISO-8859-1?Q?C=E9dric_Augonnet?=" <cedric.augonnet@gmail.com>
To: "=?ISO-8859-1?Q?Daniel_Aragon=E9s?=" <danarag@gmail.com>
Subject: Re: 2.6.20-mm1 - Oops using Minix 3 file system
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Cedric.augonnet@ens-lyon.org
In-Reply-To: <edd3ff190702170255w1c30fa08v96e5b92baacbd701@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <f56c1ba00702161500x775fe04bl91889b5819cf9ddc@mail.gmail.com>
	 <edd3ff190702170255w1c30fa08v96e5b92baacbd701@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/2/17, Daniel Aragonés <danarag@gmail.com>:
>  Well, a glance at your dmesg doesn' show that a minix partition was
> recognized. Otherwise it would sow it. So you have not such a
> partition within your drives.
>
> You are using an emulator to run minix. You will have the same problem
> if you run minix2 or minix3 through an emulator and not from a real
> minix2 or minix3 partition.
>
> Regards,
>
> Daniel
>

Indeed the only line of dmesg showing i mounted the partition is
   loop: loaded (max 8 devices)

Still I actually mount an image : i can add files, edit and so on. If
i use the emulator and mount the partition, this partition works
perfectly and even the df commands works.

Now i tried to understand what is going on and traced the program :

It appears that the trouble is in  the count_free of file
fs/minix/bitmap.c . This procedure is actually called twice when we
issue a df command.
The point where things start to get strange is
        i = ((numbits - (numblocks-1) * bh->b_size * 8) / 16) * 2; at line 36

In the first call to that procedure i have
       i = 3506
       bh->b_data = 0xd4e79000

Whereas in the second call i have something much different :
       i = 536838736
       bh->b_data = d4e78000

Tt really seems to me that this value should not be so large.
Unfortunately, i cannot get any deeper in tracing the problem since
even if i tried to read the code, it not documented, so i can't be
sure I understand everything you're doing in count_free ...

Regards,
Cédric
