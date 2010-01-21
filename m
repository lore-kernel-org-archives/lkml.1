Return-Path: <linux-kernel-owner+w=401wt.eu-S1752926Ab0AUPS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab0AUPS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 10:18:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514Ab0AUPS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 10:18:57 -0500
Received: from kroah.org ([198.145.64.141]:43070 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592Ab0AUPS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 10:18:56 -0500
Date: Thu, 21 Jan 2010 07:18:05 -0800
From: Greg KH <greg@kroah.com>
To: ykzhao <yakui.zhao@intel.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, nanhai.zou@intel.com,
       venkatesh.pallipadi@intel.com
Subject: Re: [regression]: soft lockup in dmesg after suspend/resume
Message-ID: <20100121151805.GA12489@kroah.com>
References: <1262583410.4633.98.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262583410.4633.98.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 04, 2010 at 01:36:50PM +0800, ykzhao wrote:
> Hi,
>    My box can work well before suspend/resume. But it will complain the
> following warning message after suspend/resume. 
>    >[1266874868.022103] Enabling non-boot CPUs ...
> [1266874868.022198] BUG: soft lockup - CPU#0 stuck for 0s! [kthreadd:2]
> 
>     At the same time after I add the boot option of "printk.time=1", I
> find that the log time is changed spontaneously from 76 to 1266874868.
>     > [   76.475266] CPU3 is down
> [   76.475312] Extended CMOS year: 2000
> [1266874868.020631] x86 PAT enabled: cpu 0, old 0x7040600070406, new
> 0x7010600070106
> [1266874868.021779] Back to C!
> [1266874868.022003] CPU0: Thermal LVT vector (0xfa) already installed
> [1266874868.022060] Extended CMOS year: 2000
> 
>     More detailed info can be found in the attached file of
> dmesg_after_origin.
> 
>    After I look at the source code, I find that on this box the TSC runs
> at constant rate with P/T states and does not stop in deep C-states. And
> then the sched_clock_stable is set to 1. In such case the TSC time is
> used directly in the function of sched_clock_cpu. 
>    
>    Then I do another test on this box, in which the clock_stable flag is
> saved/restored in course of suspend/resume(I add this by using per-cpu
> structure). When entering the suspended state, the clock_stable will be
> cleared. And when the system is resumed, the clock_stable will be set
> again. But unfortunately the soft lockup still exists. The file of
> dmesg_after_test2 is the dmesg log after I save/restore the clock_stable
> flag in course of suspend/resume.
> 
>    How about clearing the sched_clock_stable flag even when TSC doesn't
> stop in deep C-state?  From my test it seems that the TSC value is
> unknown after doing suspend/resume. 

I'm seeing this as well (Ingo, sorry for not searching more in the
archives before sending my other message.)

Any ideas on what I can do here?

Yes, the clock changes a bunch on resume, that's natural, we should
be able to handle this properly, right?

thanks,

greg k-h
