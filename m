Return-Path: <linux-kernel-owner+w=401wt.eu-S932071AbXAaBNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbXAaBNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 20:13:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932082AbXAaBNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 20:13:10 -0500
Received: from mga06.intel.com ([134.134.136.21]:10566 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932071AbXAaBNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 20:13:09 -0500
X-Greylist: delayed 580 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Jan 2007 20:13:08 EST
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,259,1167638400"; 
   d="scan'208"; a="190910493:sNHT26617430"
Date: Tue, 30 Jan 2007 16:30:49 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Srinivasa Ds <srinivasa@in.ibm.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, ashok.raj@intel,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       mingo@redhat.com
Subject: Re: [Need Help] Cpuhotplug operations on 32-bit mode of xeon-64bit processor crashes the system.
Message-ID: <20070130163049.D32010@unix-os.sc.intel.com>
References: <45B47200.6030908@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5.1i
In-Reply-To: <45B47200.6030908@in.ibm.com>; from srinivasa@in.ibm.com on Mon, Jan 22, 2007 at 01:42:48PM +0530
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for my delayed response. I was away on vacation.

What platform is this? what do you mean by crashing? Do you see a
system freeze or oops?

thanks,
suresh

On Mon, Jan 22, 2007 at 01:42:48PM +0530, Srinivasa Ds wrote:
> I saw cpuhotplug operations on 32-bit mode of xeon-64bit processors 
> crashing the system. This happens on latest 2.6.20-rc5 kernel also. Same 
> (i386 cpuhotplug code) runs fine on xeon-32bit processors.
> Steps to reproduce.
> ====================
> echo 0 > /sys/devices/system/cpu/cpu6/online
> echo 1 > /sys/devices/system/cpu/cpu6/online
> ================================
> dmesg shows.
> ==============
> Breaking affinity for irq 4
> cpu_mask_to_apicid: Not a valid mask!
> CPU 6 is now offline
> =======================
> 
> On debugging the problem, I found that problem is not in cpuhotplug code 
> but in apic part. Execution of  "stale" IPI's by onlined cpus(which we 
> offlined earlier) is causing the crash. Now we need to debug,why IPI's 
> are reaching the offlined cpu's too.
> 
> 1)   During the calculation of apicid's, if cpu to which IPI has to 
> deliver is not in
> same apic cluster,it prints "Not a valid mask" error and returns "0xFF" 
> which means broadcast the IPI's to all cpus(which are offlined too) and 
> hence the problem.
> 
> 2) I booted the system with maxcpus=2 boot parameter, and tried cpu 
> hotplugging on it.
> but still problem recreates(I think there is no concept of apic clusters 
> if there are only 2 cpus). Hence it makes me to conclude that problem is 
> in delivery of IPI's.
> 
> So Iam completely stuck here. Iam not able to move forward in debugging. 
> So could someone(may be intel folks) please throw some light on this.
> 
> Thanks in advance
>   Srinivasa DS
>   LTC-IBM
