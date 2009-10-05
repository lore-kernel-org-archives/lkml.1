Return-Path: <linux-kernel-owner+w=401wt.eu-S1758461AbZJEDdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461AbZJEDdm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 23:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758424AbZJEDdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 23:33:41 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:50175 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758346AbZJEDdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 23:33:41 -0400
Date: Mon, 5 Oct 2009 09:02:56 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Len Brown <lenb@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Shaohua Li <shaohua.li@intel.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [git pull request] ACPI Processor Aggregator Driver for
 2.6.32-rc1
Message-ID: <20091005033256.GA26592@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <alpine.LFD.2.00.0910030145140.25240@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0910030145140.25240@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Len Brown <lenb@kernel.org> [2009-10-03 01:56:32]:

>     This driver does not use the kernel's CPU hot-plug mechanism
>     because after the transient emergency is over, the system must
>     be returned to its normal state, and hotplug would permanently
>     break both cpusets and binding.
>     

Why does hotplug break cpusets and binding?


>     So to force idle, the driver creates a power saving thread.
>     The scheduler will migrate the thread to the preferred CPU.
>     The thread has max priority and has SCHED_RR policy,
>     so it can occupy one CPU.  To save power, the thread will
>     invoke the deep C-state entry instructions.
>     
>     To avoid starvation, the thread will sleep 5% of the time
>     time for every second (current RT scheduler has threshold
>     to avoid starvation, but if other CPUs are idle,
>     the CPU can borrow CPU timer from other,
>     which makes the mechanism not work here)
>     
>     Vaidyanathan Srinivasan has proposed scheduler enhancements
>     to allow injecting idle time into the system.  This driver doesn't
>     depend on those enhancements, but could cut over to them
>     when they are available.
>     
>     Peter Z. does not favor upstreaming this driver until
>     the those scheduler enhancements are in place.  However,
>     we favor upstreaming this driver now because it is useful
>     now, and can be enhanced over time.
>     
>     Signed-off-by: Shaohua Li <shaohua.li@intel.com>
>     NACKed-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>     Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
>     Signed-off-by: Len Brown <len.brown@intel.com>

This is a first a patch with a NACKed-by, could we please have more
discussion on the proposed design.

-- 
	Balbir
