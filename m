Return-Path: <linux-kernel-owner+w=401wt.eu-S1753154Ab0AFGg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab0AFGg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 01:36:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750944Ab0AFGg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 01:36:29 -0500
Received: from mga01.intel.com ([192.55.52.88]:62848 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188Ab0AFGg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 01:36:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,226,1262592000"; 
   d="scan'208";a="761714121"
Subject: RE: [regression]: soft lockup in dmesg after suspend/resume
From: ykzhao <yakui.zhao@intel.com>
To: "Zou, Nanhai" <nanhai.zou@intel.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
In-Reply-To: <32606542045FF34BA04F9D5BB0CB6BB5316D2B0E@shzsmsx502.ccr.corp.intel.com>
References: <1262583410.4633.98.camel@localhost.localdomain>
	 <32606542045FF34BA04F9D5BB0CB6BB5316D2B0E@shzsmsx502.ccr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Organization: Intel Open Source Technology Center
Date: Wed, 06 Jan 2010 14:34:29 +0800
Message-Id: <1262759669.12945.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-06 at 14:12 +0800, Zou, Nanhai wrote:
> >>-----Original Message-----
> >>From: Zhao, Yakui
> >>Sent: 2010年1月4日 13:37
> >>To: mingo@elte.hu
> >>Cc: linux-kernel@vger.kernel.org; Zou, Nanhai; Pallipadi, Venkatesh
> >>Subject: [regression]: soft lockup in dmesg after suspend/resume
> >>
> >>Hi,
> >>   My box can work well before suspend/resume. But it will complain the
> >>following warning message after suspend/resume.
> >>   >[1266874868.022103] Enabling non-boot CPUs ...
> >>[1266874868.022198] BUG: soft lockup - CPU#0 stuck for 0s! [kthreadd:2]
> >>
> >>    At the same time after I add the boot option of "printk.time=1", I
> >>find that the log time is changed spontaneously from 76 to 1266874868.
> >>    > [   76.475266] CPU3 is down
> >>[   76.475312] Extended CMOS year: 2000
> >>[1266874868.020631] x86 PAT enabled: cpu 0, old 0x7040600070406, new
> >>0x7010600070106
> >>[1266874868.021779] Back to C!
> >>[1266874868.022003] CPU0: Thermal LVT vector (0xfa) already installed
> >>[1266874868.022060] Extended CMOS year: 2000
> >>
> >>    More detailed info can be found in the attached file of
> >>dmesg_after_origin.
> >>
> >>   After I look at the source code, I find that on this box the TSC runs
> >>at constant rate with P/T states and does not stop in deep C-states. And
> >>then the sched_clock_stable is set to 1. In such case the TSC time is
> >>used directly in the function of sched_clock_cpu.
> >>
> >>   Then I do another test on this box, in which the clock_stable flag is
> >>saved/restored in course of suspend/resume(I add this by using per-cpu
> >>structure). When entering the suspended state, the clock_stable will be
> >>cleared. And when the system is resumed, the clock_stable will be set
> >>again. But unfortunately the soft lockup still exists. The file of
> >>dmesg_after_test2 is the dmesg log after I save/restore the clock_stable
> >>flag in course of suspend/resume.
> >>
> >>   How about clearing the sched_clock_stable flag even when TSC doesn't
> >>stop in deep C-state?  From my test it seems that the TSC value is
> >>unknown after doing suspend/resume.
> >>
> >>Thanks.
> >>   Yakui.
> 
> Hi Ingo,
> 	How do you think about this bug? 
> This is introduced by the sched_clock_stable flag, 
> TSC is stable except when CPU is suspending, we see suspend/resume hang on those machines.

    It is not suspend/resume hang. The main issue is that the kernel
will complain the soft lockup warning message after suspend/resume. And
when adding the boot option of "printk.time=1", we find that the dmesg
log time will be changed spontaneously after suspend/resume. 

thanks.
    Yakui

>      Maybe we can ignore sched_clock_stable flag when CPU is suspending?
> 
> Thanks
> Zou Nan hai
> 
> 

