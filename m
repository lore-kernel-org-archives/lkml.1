Return-Path: <linux-kernel-owner+w=401wt.eu-S1757872AbXFGGvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872AbXFGGvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 02:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757245AbXFGGvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 02:51:41 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36943 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757123AbXFGGvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 02:51:40 -0400
Date: Wed, 6 Jun 2007 23:51:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm2
Message-Id: <20070606235131.a56242cd.akpm@linux-foundation.org>
In-Reply-To: <20070607064231.GQ6909@holomorphy.com>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
	<20070607064231.GQ6909@holomorphy.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2007 23:42:31 -0700 William Lee Irwin III <wli@holomorphy.com> wrote:

> On Wed, Jun 06, 2007 at 10:03:13PM -0700, Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm2/
> > - Basically a bugfixed version of 2.6.22-rc4-mm1.  None of the subsystem
> >   trees were repulled, several bad patches were dropped, a few were fixed.
> 
> create-the-zone_movable-zone.patch breaks the build on sparc32.
> 
> 
> -- wli
> 
> $ good=0; bad=`quilt series -v | wc -l`; time while [[ $(( $bad - $good )) -gt 1 ]]; do cur=`quilt series -v |egrep -c '(=|\+)'`; chkpt=$(( ($good + $bad)/2 )); delta=$(( $chkpt - $cur )); if [[ $delta -lt 0 ]]; then (quilt pop $(( 0 - $delta )) ) >& /dev/null; elif [[ $delta -gt 0 ]]; then (quilt push $delta) >& /dev/null; else true; fi; cur=$chkpt; (yes "" | make ARCH=sparc CROSS_COMPILE="sparc-linux-" CC="gcc-sparc-4.1" quiet=1 -j16 defconfig) >& /dev/null; echo "last known good = $good, first known bad = $bad, trying $chkpt"; yes "" | make ARCH=sparc CROSS_COMPILE="sparc-linux-" CC="gcc-sparc-4.1" quiet=1 -j16 image modules; s=$?; if [[ $s -ne 0 ]]; then echo "$chkpt bad"; bad=$chkpt; else echo "$chkpt good"; good=$chkpt; fi; done
> ...
> last known good = 641, first known bad = 645, trying 643
> scripts/kconfig/conf -s arch/sparc/Kconfig
> drivers/macintosh/Kconfig:116:warning: 'select' used by config symbol 'PMAC_APM_EMU' refers to undefined symbol 'APM_EMULATION'
> drivers/input/keyboard/Kconfig:170:warning: 'select' used by config symbol 'KEYBOARD_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
> drivers/input/mouse/Kconfig:182:warning: 'select' used by config symbol 'MOUSE_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
> sound/soc/sh/Kconfig:6:warning: 'select' used by config symbol 'SND_SOC_PCM_SH7760' refers to undefined symbol 'SH_DMABRG'
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
> <stdin>:752:2: warning: #warning syscall setresuid not implemented
> <stdin>:756:2: warning: #warning syscall getresuid not implemented
> <stdin>:776:2: warning: #warning syscall setresgid not implemented
> <stdin>:780:2: warning: #warning syscall getresgid not implemented
>   CHK     include/linux/compile.h
> mm/page_alloc.c: In function 'nr_free_pagecache_pages':
> mm/page_alloc.c:1706: error: 'GFP_HIGH_MOVABLE' undeclared (first use in this function)
> mm/page_alloc.c:1706: error: (Each undeclared identifier is reported only once
> mm/page_alloc.c:1706: error: for each function it appears in.)
> make[1]: *** [mm/page_alloc.o] Error 1
> make[1]: *** Waiting for unfinished jobs....
> make: *** [mm] Error 2
> make: *** Waiting for unfinished jobs....
> drivers/char/rtc.c:118: warning: 'hpet_rtc_interrupt' defined but not used
> make: *** wait: No child processes.  Stop.

Nope, there are no instances of GFP_HIGH_MOVABLE in the tree once all
patches are applied.  You hit a bad bisection point: between
create-the-zone_movable-zone.patch and
create-the-zone_movable-zone-fix.patch.
