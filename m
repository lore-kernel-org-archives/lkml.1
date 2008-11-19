Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbYKSJpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbYKSJpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 04:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbYKSJpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 04:45:13 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:65350 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbYKSJpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 04:45:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XkSJ/Vp7VT+vmgZECXkebybkiXp3su9MaMVXgWwYDDkqxhvZ30eTleoMBvzFoXbzNO
         3xj1H6JEgg1Y9cCWCMUytqS0OuHuYYZl34i8nUOl6dvdsGGBhP4ECnIVGmSGrTV6b4Ui
         redl82jJAV5lqfR8xz05WOgh/4JDvKDh7gx7U=
Message-ID: <c384c5ea0811190145y78803fbboecfcf6ebd652ee03@mail.gmail.com>
Date: Wed, 19 Nov 2008 10:45:09 +0100
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: pci_map_sg() does not coalesce adjacent physical memory? x86
Cc: jens.axboe@oracle.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, James.Bottomley@hansenpartnership.com,
       tj@kernel.org
In-Reply-To: <20081119165915A.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081119142016E.fujita.tomonori@lab.ntt.co.jp>
	 <c384c5ea0811182222l7f0e3131tc1cc20ffba5175c@mail.gmail.com>
	 <20081119155847U.fujita.tomonori@lab.ntt.co.jp>
	 <20081119165915A.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Nov 19, 2008 at 8:58 AM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> On Wed, 19 Nov 2008 15:58:12 +0900
> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
>> On Wed, 19 Nov 2008 07:22:31 +0100
>
> - pci_map_sg/dma_map_sg are used with a scatter gather list that
> doesn't come from the block layer (e.g. some network drivers do).
>
This is the point I then want to make: we have pci_map_sg() users in
other system than the block layer, the network and v4l2 subsystems,
why cannot they benefit from coalescing?

Should they copy the block layer coalescing implementation, or should
that implementation be made more generic and live outside the block
sub system?

My intended use case is as follows. See the sg_write() call for the code flow.

http://www.sidebranch.com/leon/user_dma_sg.c


Thanks,
-- 
Leon
