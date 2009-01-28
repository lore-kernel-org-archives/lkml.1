Return-Path: <linux-kernel-owner+w=401wt.eu-S1756651AbZA1Ucr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651AbZA1Ucr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:32:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755238AbZA1U3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:29:06 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:32856 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbZA1U3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:29:04 -0500
Date: Wed, 28 Jan 2009 13:22:22 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: linux-arm-kernel@lists.arm.linux.org.uk
cc: tony@atomide.com, rmk@arm.linux.org.uk, linux-omap@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: OMAP clock fast-forward: an introduction to six series
Message-ID: <alpine.DEB.2.00.0901281310590.14710@utopia.booyaka.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

This set of six patch series brings mainline Linux up-to-date with the 
current state of the clock framework in the linux-omap tree.  The patches 
have received extensive testing by OMAP users on the linux-omap mailing 
list, linux-omap@vger.kernel.org.  Current-generation OMAP dev boards 
include the BeagleBoard <http://www.beagleboard.org/> and the Gumstix 
Overo <http://www.gumstix.com/>.

The oldest of the source patches dates back to June 2008.  It's not clear 
to me why the upstream merge process for these patches has been so 
difficult.  I hope that, going forward, upstream merges for OMAP patches 
can keep up with the pace of development on linux-omap, so this type of 
massive merge is unnecessary.

Per rmk's preferences, some patches have been 'compressed.' That is, some 
fix patches have been rolled into a single patch with the original.  To 
ease cross-referencing with the linux-omap git tree, original commit IDs 
have been inserted into the patch messages.  Also, what would have been an 
extremely long series has been split into six smaller, cumulative, roughly 
thematic patch series.  If requested, I would be pleased to simply send 
one large series of the original, uncompressed patches.  Thanks to the git 
and stgit authors and contributors: without those tools, this process 
would have been nearly impossible.

Each series has been compile-tested for 5912 OSK (OMAP1), H4 and 2430SDP 
(OMAP2), and BeagleBoard (OMAP3), and boot-tested on 2430SDP and Beagle.
After the sixth series, the diff with the linux-omap tree for the files 
listed below is minimal.


regards,

- Paul


manifest:

[PATCH A 00/10] OMAP clock, A of F: preliminaries
[PATCH B 00/10] OMAP clock, B of F: clockdomain, powerdomain updates
[PATCH C 00/13] OMAP clock, C of F: DPLL updates
[PATCH D 00/11] OMAP clock, D of F: clock code cleanup
[PATCH E 00/14] OMAP clock, E of F: SDRAM fixes, clock optimization
[PATCH F 00/12] OMAP clock, F of F: more clock cleanup

diffstat (post-compression; pre-compression stats are larger):

 arch/arm/mach-omap1/clock.c                   |  168 -                              
 arch/arm/mach-omap1/clock.h                   |  136 -                              
 arch/arm/mach-omap2/Makefile                  |    8                                
 arch/arm/mach-omap2/board-2430sdp.c           |    2                                
 arch/arm/mach-omap2/board-apollon.c           |    2                                
 arch/arm/mach-omap2/board-generic.c           |    2
 arch/arm/mach-omap2/board-h4.c                |    2
 arch/arm/mach-omap2/board-ldp.c               |    2
 arch/arm/mach-omap2/board-omap3beagle.c       |    2
 arch/arm/mach-omap2/clock.c                   |  786 ++++----
 arch/arm/mach-omap2/clock.h                   |   30
 arch/arm/mach-omap2/clock24xx.c               |  409 ++--
 arch/arm/mach-omap2/clock24xx.h               | 1395 ++++++++------
 arch/arm/mach-omap2/clock34xx.c               |  399 +++-
 arch/arm/mach-omap2/clock34xx.h               | 2509 ++++++++++++++------------
 arch/arm/mach-omap2/clockdomain.c             |   66
 arch/arm/mach-omap2/clockdomains.h            |  132 -
 arch/arm/mach-omap2/cm-regbits-24xx.h         |   81
 arch/arm/mach-omap2/cm-regbits-34xx.h         |  121 -
 arch/arm/mach-omap2/cm.h                      |   20
 arch/arm/mach-omap2/io.c                      |   10
 arch/arm/mach-omap2/mcbsp.c                   |    5
 arch/arm/mach-omap2/memory.c                  |   14
 arch/arm/mach-omap2/memory.h                  |   43
 arch/arm/mach-omap2/pm.c                      |    2
 arch/arm/mach-omap2/powerdomains.h            |    8
 arch/arm/mach-omap2/powerdomains34xx.h        |   63
 arch/arm/mach-omap2/prcm-common.h             |  198 +-
 arch/arm/mach-omap2/prm-regbits-34xx.h        |    9
 arch/arm/mach-omap2/prm.h                     |  166 -
 arch/arm/mach-omap2/sdrc.c                    |   95
 arch/arm/mach-omap2/sdrc2xxx.c                |   83
 arch/arm/mach-omap2/sram242x.S                |    5
 arch/arm/mach-omap2/sram243x.S                |    5
 arch/arm/plat-omap/clock.c                    |  366 ++-
 arch/arm/plat-omap/common.c                   |    4
 arch/arm/plat-omap/cpu-omap.c                 |   57
 arch/arm/plat-omap/include/mach/clock.h       |  178 -
 arch/arm/plat-omap/include/mach/clockdomain.h |   24
 arch/arm/plat-omap/include/mach/common.h      |    7
 arch/arm/plat-omap/include/mach/gpmc.h        |    2
 arch/arm/plat-omap/include/mach/io.h          |    4
 arch/arm/plat-omap/include/mach/powerdomain.h |    5
 arch/arm/plat-omap/include/mach/prcm.h        |    5
 arch/arm/plat-omap/include/mach/sdrc.h        |   82
 arch/arm/plat-omap/include/mach/system.h      |    4
 46 files changed, 4641 insertions(+), 3075 deletions(-)
