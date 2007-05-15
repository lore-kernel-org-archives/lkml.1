Return-Path: <linux-kernel-owner+w=401wt.eu-S1761578AbXEOITe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761578AbXEOITe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 04:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756149AbXEOITU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 04:19:20 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2057 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925AbXEOITS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 04:19:18 -0400
Date: Tue, 15 May 2007 09:19:07 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Simon Horman <horms@verge.net.au>
Cc: linux-kernel@vger.kernel.org,
       Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ARM] Fix hard_smp_processor_id compile error
Message-ID: <20070515081907.GA17611@flint.arm.linux.org.uk>
Mail-Followup-To: Simon Horman <horms@verge.net.au>,
	linux-kernel@vger.kernel.org,
	Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20070515022014.CC2A44F910@tabatha.lab.ultramonkey.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070515022014.CC2A44F910@tabatha.lab.ultramonkey.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2007 at 11:18:50AM +0900, Simon Horman wrote:
> "Remove hardcoding of hard_smp_processor_id on UP systems",
> 2f4dfe206a2fc07099dfad77a8ea2f4b4ae2140f in Linus' tree, moved
> the definition of hard_smp_processor_id linux/smp.h to asm/smp.h
> for UP systems. This causes a regression on ARM as the definition
> was not added to asm-arm/smp.h.
> 
> Cc: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> Signed-off-by: Simon Horman <horms@verge.net.au>

I took an alternative approach - since Integrator never had the complete
SMP support merged, I ripped it out of that platform.  Whether realview
suffers from the same thing or not I'm not sure - uniprocessor realview
is not something covered by the ARM default configuration files, and
therefore kautobuild won't check that configuration.

However, the things I find annoying about this is:

1. asm/smp.h was _never_ included in ARM UP builds prior to this change.
2. we have linux/smp.h and the general rule is that if asm/foo.h and
   linux/foo.h are present, linux/foo.h is included in preference to
   asm/foo.h

Given the amount of janitors we now have looking at the kernel code,
(2) is a big concern - it could mean a constant stream of patches
trying to "fix" files including asm/smp.h.

I would suggest that if there is a desire to include asm/smp.h on UP
builds, the inclusion of it by linux/smp.h is made unconditional.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
