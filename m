Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbXHAWfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbXHAWfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 18:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbXHAWfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 18:35:03 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:57434 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753371AbXHAWfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 18:35:01 -0400
Date: Thu, 2 Aug 2007 00:34:40 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Maurice Volaski <mvolaski@aecom.yu.edu>
Cc: jheffner@psc.edu, discussion@web100.org, linux-kernel@vger.kernel.org,
       drbd-user@linbit.com
Subject: Re: drbd 8.0.2/3 doesn't load under kernel 2.6.21
Message-ID: <20070801223440.GS3972@stusta.de>
References: <a0624045cc2d691fb7294@[129.98.90.227]>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a0624045cc2d691fb7294@[129.98.90.227]>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 04:21:29PM -0400, Maurice Volaski wrote:
> I'm making an assumption that depmod is somehow to blame and have logged 
> this as a kernel bug, http://bugzilla.kernel.org/show_bug.cgi?id=8829

depmod is working fine.

It's the interaction between your two patches that breaks it for you.

>>> It turns out I was adding the web100 patch (http://www.web100.org) to
>>> the 2.6.21 kernel and that's what causes the symbol resolving problem
>>> below. Adding the corresponding version of the web100 patch to the
>>> 2.6.20 kernel makes this problem appear there as well. On fresh
>>> versions of the kernel, this problem does not occur. At the moment,
>>> it's not possible to have a current kernel that contains both drbd
>>> and web100.
>>>
>>>> On a 64-bit Gentoo system with Gentoo's 2.6.21 kernel, drbd 8.0.2/3
>>>> complains when I try to load the module:
>>>>
>>>> [  134.141363] drbd: Unknown symbol cn_fini
>>>> [  134.141399] drbd: Unknown symbol cn_init
>>>>
>>>> It works fine when I compile it and load in the previous kernel
>>>> version, 2.6.20 and the symbols are present in the map file
>>>>
>>>> ./System.map-genkernel-x86_64-2.6.21-gentoo-r2:ffffffff802935aa t 
>>>> cn_fini
>>>> ./System.map-genkernel-x86_64-2.6.21-gentoo-r2:ffffffff8029362a t 
>>>> cn_init
>>>>
>>>> I am c'cing the kernel mailing list because this appears to be a
>>>> problem with how any module accesses symbols in the kernel, not just
>>>  >drbd. Source was compiled with Gentoo gcc-4.1.2, glibc-2.5-r3

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

