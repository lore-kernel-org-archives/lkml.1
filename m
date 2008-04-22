Return-Path: <linux-kernel-owner+w=401wt.eu-S1762721AbYDVSbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762721AbYDVSbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 14:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759693AbYDVSbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 14:31:37 -0400
Received: from gir.skynet.ie ([193.1.99.77]:58912 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755189AbYDVSbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 14:31:35 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: linux-mm@kvack.org
Cc: Mel Gorman <mel@csn.ul.ie>, mingo@elte.hu, linux-kernel@vger.kernel.org,
       clameter@sgi.com
Message-Id: <20080422183133.13750.57133.sendpatchset@skynet.skynet.ie>
Subject: [PATCH 0/4] Verification and debugging of memory initialisation V3
Date: Tue, 22 Apr 2008 19:31:33 +0100 (IST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Other than a rebase to the latest -mm, there are not many big changes.
Credit goes to Christoph Lameter, an off-list reviewer and in particular
Ingo Molnar for helping bash this into shape.

Changelog since V2
  o (Mel) Rebase to 2.6.25-mm1 and rewrite zonelist dump
  o (Mel) Depend on DEBUG_VM instead of DEBUG_KERNEL
  o (Mel) Use __meminitdata instead of __initdata for logging level
  o (Christoph) Get rid of FLAGS_RESERVED references
  o (Christoph) Print out flag usage information
  o (Ingo) Default do the verifications on DEBUG_VM and instead control the
           level of verbose logging with mminit_loglevel= instead of
	   mminit_debug_level=
  o (Anon) Log at KERN_DEBUG level
  o (Anon) Optimisation to the mminit_debug_printk macro

Changelog since V1
  o (Ingo) Make memory initialisation verification a DEBUG option depending on
    DEBUG_KERNEL option. By default it will then to verify structures but
    tracing can be enabled via the command-line. Without the CONFIG option,
    checks will still be made on PFN ranges passed by the architecture-specific
    code and a warning printed once if a problem is encountered
  o (Ingo) WARN_ON_ONCE when PFNs from the architecture violate SPARSEMEM
    limitations. The warning should be "harmless" as the system will boot
    regardless but it acts as a reminder that bad input is being used.
  o (Anon) Convert mminit_debug_printk() to a macro
  o (Anon) Spelling mistake corrections
  o (Anon) Use of KERN_CONT properly for multiple printks
  o (Mel) Reshuffle the patches so that the zonelist printing is at the
    end of the patchset. This is because -mm requires a different patch to
    print zonelists and this allows the end patch to be temporarily dropped
    when testing against -mm
  o (Mel) Rebase on top of Ingo's sparsemem fix for easier testing
  o (Mel) Document mminit_debug_level=
  o (Mel) Fix check on pageflags where the masks were not being shifted
  o (Mel) The zone ID should should have used page_zonenum not page_zone_id
  o (Mel) Iterate all zonelists correctly
  o (Mel) Correct typo of SECTIONS_SHIFT

Boot initialisation has always been a bit of a mess with a number
of ugly points. While significant amounts of the initialisation
is architecture-independent, it trusts of the data received from the
architecture layer. This was a mistake in retrospect as it has resulted in
a number of difficult-to-diagnose bugs.

This patchset adds some validation and tracing to memory initialisation when
CONFIG_DEBUG_VM is set. The configuration option can be explicitly disabled
for embedded systems. It also introduces a few basic defencive measures and
depending on a boot parameter, will perform additional tests for errors
"that should never occur". The intention is that additional checks are
added over time that would have identified mysterious boot failures faster.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
