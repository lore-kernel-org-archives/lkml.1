Return-Path: <linux-kernel-owner+w=401wt.eu-S1757617AbYFGAVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617AbYFGAVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 20:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbYFGAVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 20:21:32 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:57758 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbYFGAVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 20:21:31 -0400
Date: Fri, 06 Jun 2008 18:21:20 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: SMP Affinity Issue with IRQ#
In-reply-to: <fa.1w61C2V3iARylIuoDG4axNStuwg@ifi.uio.no>
To: Khaled Al-Hamwi <khaled.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <4849D480.2090806@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.1w61C2V3iARylIuoDG4axNStuwg@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Khaled Al-Hamwi wrote:
> Hi list,
> 
> I am trying to evaluate the performance of a Linux box when working as
> IP forwarder.
> I have a hardware traffic generator IXIA T400 on one end.
> On the other end, I have a Linux box with kernel 2.6.16 and quad-core xeon CPU.
> 
> These two systems are connected through two crossover Gigabit cables and NICs.
> The traffic is sent from IXIA through one NIC to the forwarding machine
> and then it is forwarded back through the other NIC to IXIA.
> 
> I have two issues related to SMP affinity.
> The first one is that when I set the SMP affinity through
> /proc/irq/<IRQ#>/smp_affinity, it changes dynamically.
> Is there any load balancing in the system that changes the affinity
> after some time or after some packets are received?
> Is there a way to set it permanently?

Likely the irqbalance daemon is doing it. You should be able to stop it. 
(Or you have the kernel IRQ balancing config option enabled, which you 
likely shouldn't.)

> 
> The second issue is that changing the SMP affinity results in
> different delay and throughput measurements.
> I am assigning each NIC to a different CPU.
> If I used a different assignment but still each NIC is assigned to a
> different CPU, I am getting different performance results.
> I would expect that changing the assignment should yield the same
> performance results.
> The CPUs are identical and should have similar performance.
> Here, I have two examples of two different assignments:
> Example 1:
> /proc/irq/16/smp_affinity (eth0)  ->   CPU#1
> /proc/irq/20/smp_affinity (eth1)  ->   CPU#2
> Example 2:
> /proc/irq/16/smp_affinity (eth0)  ->   CPU#3
> /proc/irq/20/smp_affinity (eth1)  ->   CPU#2
> Which one of these two configurations can be used as a reference for
> performance evaluation?
> 
> Any ideas??

I believe the current Intel quad core CPUs are really two dual-core CPU 
dies in a common package. Splitting the network interrupts across the 
two physical CPU chips will likely give you worse performance.
