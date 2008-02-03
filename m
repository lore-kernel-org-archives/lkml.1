Return-Path: <linux-kernel-owner+w=401wt.eu-S1752187AbYBCSdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbYBCSdj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 13:33:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750816AbYBCSdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 13:33:32 -0500
Received: from simmts8.bellnexxia.net ([206.47.199.166]:39846 "EHLO
	simmts8-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750743AbYBCSdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 13:33:31 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAACOYpUecIvlD/2dsb2JhbAAIqzU
Message-ID: <47A608F8.5080206@gmail.com>
Date: Sun, 03 Feb 2008 14:33:28 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071229)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Latest -git ioremap error
References: <47A606B5.7090001@gmail.com>
In-Reply-To: <47A606B5.7090001@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Winchester wrote:
> Hi Thomas, Ingo,
> 
> I noticed that my direct rendering is no longer working, with the
> following in my dmesg:
> 
> [    0.588184] agpgart: Detected AGP bridge 0
> [    0.588184] agpgart: unable to get memory for graphics translation table.
> [    0.588184] agpgart: agp_backend_initialize() failed.
> [    0.588207] agpgart-amd64: probe of 0000:00:00.0 failed with error -12
> 
> Tracking down the error somewhat with added printks leads to the
> following block in __ioremap():
> 
> 
> /*
>  * Don't allow anybody to remap normal RAM that we're using..
>  */
> for (offset = phys_addr >> PAGE_SHIFT; offset < max_pfn_mapped &&
>      (offset << PAGE_SHIFT) < last_addr; offset++) {
>         if (page_is_ram(offset))
>                 return NULL;
> }
> 
> 
> And git blame lead me to the following commit:
> 
> commit 266b9f8727976769e2ed2dad77ac9295f37e321e
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Wed Jan 30 13:34:06 2008 +0100
> 
>     x86: fix ioremap RAM check
> 
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> 

Lucky first try - reverting this commit fixes the problem for me.  Any
ideas?

-- 
Kevin Winchester








