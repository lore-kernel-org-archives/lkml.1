Return-Path: <linux-kernel-owner+w=401wt.eu-S1754594AbXFGGll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbXFGGll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 02:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbXFGGlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 02:41:35 -0400
Received: from holomorphy.com ([66.93.40.71]:47524 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbXFGGle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 02:41:34 -0400
Date: Wed, 6 Jun 2007 23:42:31 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm2
Message-ID: <20070607064231.GQ6909@holomorphy.com>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 10:03:13PM -0700, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm2/
> - Basically a bugfixed version of 2.6.22-rc4-mm1.  None of the subsystem
>   trees were repulled, several bad patches were dropped, a few were fixed.

create-the-zone_movable-zone.patch breaks the build on sparc32.


-- wli

$ good=0; bad=`quilt series -v | wc -l`; time while [[ $(( $bad - $good )) -gt 1 ]]; do cur=`quilt series -v |egrep -c '(=|\+)'`; chkpt=$(( ($good + $bad)/2 )); delta=$(( $chkpt - $cur )); if [[ $delta -lt 0 ]]; then (quilt pop $(( 0 - $delta )) ) >& /dev/null; elif [[ $delta -gt 0 ]]; then (quilt push $delta) >& /dev/null; else true; fi; cur=$chkpt; (yes "" | make ARCH=sparc CROSS_COMPILE="sparc-linux-" CC="gcc-sparc-4.1" quiet=1 -j16 defconfig) >& /dev/null; echo "last known good = $good, first known bad = $bad, trying $chkpt"; yes "" | make ARCH=sparc CROSS_COMPILE="sparc-linux-" CC="gcc-sparc-4.1" quiet=1 -j16 image modules; s=$?; if [[ $s -ne 0 ]]; then echo "$chkpt bad"; bad=$chkpt; else echo "$chkpt good"; good=$chkpt; fi; done
...
last known good = 641, first known bad = 645, trying 643
scripts/kconfig/conf -s arch/sparc/Kconfig
drivers/macintosh/Kconfig:116:warning: 'select' used by config symbol 'PMAC_APM_EMU' refers to undefined symbol 'APM_EMULATION'
drivers/input/keyboard/Kconfig:170:warning: 'select' used by config symbol 'KEYBOARD_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
drivers/input/mouse/Kconfig:182:warning: 'select' used by config symbol 'MOUSE_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
sound/soc/sh/Kconfig:6:warning: 'select' used by config symbol 'SND_SOC_PCM_SH7760' refers to undefined symbol 'SH_DMABRG'
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
<stdin>:752:2: warning: #warning syscall setresuid not implemented
<stdin>:756:2: warning: #warning syscall getresuid not implemented
<stdin>:776:2: warning: #warning syscall setresgid not implemented
<stdin>:780:2: warning: #warning syscall getresgid not implemented
  CHK     include/linux/compile.h
mm/page_alloc.c: In function 'nr_free_pagecache_pages':
mm/page_alloc.c:1706: error: 'GFP_HIGH_MOVABLE' undeclared (first use in this function)
mm/page_alloc.c:1706: error: (Each undeclared identifier is reported only once
mm/page_alloc.c:1706: error: for each function it appears in.)
make[1]: *** [mm/page_alloc.o] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [mm] Error 2
make: *** Waiting for unfinished jobs....
drivers/char/rtc.c:118: warning: 'hpet_rtc_interrupt' defined but not used
make: *** wait: No child processes.  Stop.
