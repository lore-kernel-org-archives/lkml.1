Return-Path: <linux-kernel-owner+w=401wt.eu-S1759331AbYGaV61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759331AbYGaV61 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 17:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754936AbYGaV6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 17:58:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:51316 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754728AbYGaV6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 17:58:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,288,1215414000"; 
   d="scan'208";a="424678763"
Date: Thu, 31 Jul 2008 14:58:09 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "drepper@redhat.com" <drepper@redhat.com>,
       "mikpe@it.uu.se" <mikpe@it.uu.se>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/9] x86, xsave: xsave/xrstor support
Message-ID: <20080731215808.GB8563@linux-os.sc.intel.com>
References: <20080729172917.185593000@linux-os.sc.intel.com> <488FA318.3040905@zytor.com> <20080729232951.GB11223@linux-os.sc.intel.com> <488FAB2B.7050405@zytor.com> <20080730100326.GA9683@elte.hu> <20080730182539.GA17140@elte.hu> <20080730234102.GF11223@linux-os.sc.intel.com> <20080731212915.GH2729@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080731212915.GH2729@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 02:29:15PM -0700, Ingo Molnar wrote:
> > Ingo, 2.6.25, 2.6.26 also reboots randomly with this config on my
> > dual-socket system.
> 
> hmmm ....
> 
> a few guesses: perhaps I2C related (the randconfig turned on I2C bits)?
> Do you have any way (hw test-kit) to figure out where the reboot comes
> from - is it a triple fault caused by the kernel? Or some hardware
> event?

Doh! I knew something was wrong with your randconfig :)

#
# Watchdog Device Drivers
#
....

CONFIG_PC87413_WDT=y
CONFIG_60XX_WDT=y
# CONFIG_SBC8360_WDT is not set
CONFIG_CPU5_WDT=y
CONFIG_SMSC37B787_WDT=y
CONFIG_W83627HF_WDT=y
CONFIG_W83697HF_WDT=y
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=y

Kernel was enabling watchdog, with out the userspace having the
heartbeat daemon....

randconfig is really not a good way to test! I can't even ssh to the box
with this config (something else is missing in the config!)

Anyhow, with watchdog removed, it works just fine. (both xsave and non-xsave
kernels)

thanks,
suresh
