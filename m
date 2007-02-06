Return-Path: <linux-kernel-owner+w=401wt.eu-S1752260AbXBFO5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbXBFO5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 09:57:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbXBFO5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 09:57:37 -0500
Received: from 81-174-33-43.f5.ngi.it ([81.174.33.43]:50590 "EHLO develer.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbXBFO5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 09:57:36 -0500
Message-ID: <45C8975B.30508@develer.com>
Date: Tue, 06 Feb 2007 15:57:31 +0100
From: Bernardo Innocenti <bernie@develer.com>
Organization: Develer S.r.l. - http://www.develer.com/
User-Agent: Thunderbird 1.5.0.9 (X11/20070131)
MIME-Version: 1.0
To: Bernardo Innocenti <bernie@develer.com>
CC: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>, aleph <aleph@develer.com>
Subject: Re: [Linux-fbdev-devel] How to mmap a shadow framebuffer in virtual
 memory
References: <45A97832.2040206@develer.com> <Pine.LNX.4.62.0701141211030.18479@pademelon.sonytel.be> <45AB196B.7090409@develer.com>
In-Reply-To: <45AB196B.7090409@develer.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bernardo Innocenti wrote:

> I still couldn't solve my problem, but thanks for helping.
> 
> The way you map memory in ps3fb_mmap() is basically the same.
> In my case, memory is allocated with __get_free_pages() instead
> of being at an absolute physical address, but I can't see how
> it could make any difference.

A few weeks ago I found the solution, which I report here to help
people who are googling for the same problem.

consistent_alloc() performed all the required magic to allocate
a contiguous buffer in phisical memory:

 -       if (!(fb_info.shadow = (void *)__get_free_pages(GFP_KERNEL, OLED_MEMORDER))
 +       if (!(fb_info.shadow = consistent_alloc(GFP_KERNEL, PAGE_ALIGN(OLED_MEMSIZE),
 +                       &fb_info.shadow_phys, PTE_BUFFERABLE))


The complete patch set is here, just in case:

   http://www.develer.com/patches/linux/pending/

-- 
   // Bernardo Innocenti - Develer S.r.l., R&D dept.
 \X/  http://www.develer.com/

