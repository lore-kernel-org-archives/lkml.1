Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbYF0HSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbYF0HSQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 03:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbYF0HSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 03:18:05 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:40712 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751204AbYF0HSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 03:18:03 -0400
Date: Fri, 27 Jun 2008 12:49:48 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: balbir@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dipankar Sarma <dipankar@in.ibm.com>, Vatsa <vatsa@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC v1] Tunable sched_mc_power_savings=n
Message-ID: <20080627071948.GA15424@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: Andi Kleen <andi@firstfloor.org>,
	balbir@linux.vnet.ibm.com,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Suresh B Siddha <suresh.b.siddha@intel.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Dipankar Sarma <dipankar@in.ibm.com>,
	Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>
References: <20080625191100.GI21892@dirshya.in.ibm.com> <87k5gcqpbm.fsf@basil.nowhere.org> <4863AF57.3040005@linux.vnet.ibm.com> <4863DB29.1020304@firstfloor.org> <20080626185254.GA12416@dirshya.in.ibm.com> <4863F93C.9040102@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4863F93C.9040102@firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen <andi@firstfloor.org> [2008-06-26 22:17:00]:

> Vaidyanathan Srinivasan wrote:
> 
> Playing devil's advocate here.
> 

[...]

> >  The
> > power QoS framework set_acceptable_latency() ensures that the lowest
> > latency set across the system wins.  
> 
> But that only helps kernel drivers, not user space, doesn't it?

Yes the QoS notification is mainly for kernel drivers, but
applications can control them using the /dev/[...,network_latency,...]
interface as documented in Documentations/power/pm_qos_interface.txt

The device drivers are expected to get feedback (tunable?) from
applications that are dependent on those drivers and set the correct
power saving level.  Multimedia applications are expected to make use
of this interface to set/communicate the correct power saving levels
for audio drivers.

Many application can set different latency requirement, but the least
will win.  Here the PM-QoS framework in kernel arbitrates between
applications and resolves conflicts by choosing the least latency or
most conservative power saving mode.

--Vaidy

[...]
