Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbYBATLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbYBATLe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 14:11:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbYBATLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 14:11:22 -0500
Received: from gir.skynet.ie ([193.1.99.77]:39008 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359AbYBATLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 14:11:22 -0500
Date: Fri, 1 Feb 2008 19:11:19 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Gerhard Pircher <gerhard_pircher@gmx.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Commit for mm/page_alloc.c breaks boot process on my machine
Message-ID: <20080201191119.GI18688@csn.ul.ie>
References: <20080201184254.174020@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080201184254.174020@gmx.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (01/02/08 19:42), Gerhard Pircher didst pronounce:
> 
> I'm trying to get the 2.6.24 Linux kernel booting on my AmigaOne machine
> (it's a desktop PowerPC G4 machine with 1.5GB RAM). I have written the
> device tree and platform setup files for arch/powerpc, which seem to be
> working so far.
> Kernel version 2.6.24-rc2 was booting fine with my patches until the
> kernel executes the INIT command. But kernel release v2.6.24 dies early
> during the boot process (even before the radeonfb driver initializes and
> outputs kernel messages). Bisecting revealed that this commit causes my
> machine to fail booting:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=44048d700bcbfaf4bcca6e2e0a73d89d01ec0878
> (Revert "Bias the placement of kernel pages at lower PFNs")
> 
> The machine boots fine, if I revert the patch. But I wonder what side
> effects this patch may have? Can somebody shed some light on this?
> 

With this patch, early boot would use pages from lower PFNs. Without the
patch, it would use memory from higher PFNs. That is the only real
difference.

1. Is there any chance that all of your memory is not being properly
   initialised?
2. Any chance of seeing a dmesg log?
3. If you boot with the patch reverted and then do something to consume
all memory like build loads of kernel trees simultaneously, do you see
any problems?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
