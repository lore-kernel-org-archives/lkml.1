Return-Path: <linux-kernel-owner+w=401wt.eu-S932977AbZHVU1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932977AbZHVU1t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 16:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755844AbZHVU1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 16:27:49 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:56340 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831AbZHVU1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 16:27:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=r1VJiKpkwA1hLxaFPttvT10oGU9QS4MpqFJxiZbCt59HCTzk3RXOUnOoU+RUqD4PD1
         C7rlDqQCbgw+dMk5FBe3ynw28fEXOm7bPrDjNc45BZOg5CxTR6WIFgShW4zooShgfSX+
         C5uCNgkZHklhc41QxigtibiKB0pfeokh+Ebuk=
Subject: RFC: THE OFFLINE SCHEDULER
From: raz ben yehuda <raziebe@gmail.com>
To: riel@redhat.com
Cc: mingo@elte.hu, peterz@infradead.org, andrew motron <akpm@osdl.org>,
       wiseman@macs.biu.ac.il, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Sun, 23 Aug 2009 02:27:51 +0300
Message-Id: <1250983671.5688.21.camel@raz>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

			The Open University of Israel
		  Department of Mathematics and computer science	
			
		  	 	FINAL PAPER
			     OFFLINE  SCHEDULER



OFFSCHED is a platform aimed to assign an assignment to an offloaded processor.An offloaded processor is a processor that is hot un-plugged from the operating system.

Description

In today’s computer world, we find that most processors have several embedded cores and hyper-threading. Most programmers do not really use these powerful features and let the operating system do the work.
At most, a programmer will bound an application to a certain processor or assign an interrupt to a different processor. At the end, we get system busy in maintaining tasks across processors, balancing interrupts, flushing TLBs and DTLBs using atomic operations even when not needed and worst of all, spin locks across processors in vein; and the more processors the merrier. I argue that in some cases, part of this behavior is due to fact the multiple core operating system is not service oriented but a system oriented. There is no easy way to assign a processor to do a distinct service, undisturbed, accurate, and fast as long as the processor is an active part of an operating system and still be a part of most of the operating system address space.

OFFSCHED Purpose

The purpose of the OFFSCHED is to create a platform for services. For example, assume a firewall is being attacked; the Linux operating system will generate endless number of interrupts and/or softirqs to analyze the traffic and throw out bad packets. This is on the expense of “good” packets. Have you ever tried to “ssh” to an attacked machine? Who protects the operating system ?
What if we can simply do the packet analysis outside the operating system, without being interrupted ?
Why not assign a core to do only “firewalling”? Or just routing? Design a new type of Real Time system? Maybe assign it as an ultra accurate timer? Create a delaying service that does not just spin? Offload a TCP stack? perhaps a new type of a locking scheme? New type bottom-halves? Debug a running kernel through an offloaded processor? Maybe assign a GPU to do other things than just graphics?
Amdahl Law teaches us that linear speed-up is not very feasible , so why not spare a processor to do certain tasks better?
Technologically speaking, I am referring to the Linux kernel ability to virtually hot unplug a (SMT) processor ;but instead of letting it wonder in endless “halts”, assign it a service.

OFFSCHED project can be found at :
http://sos-linux.svn.sourceforge.net/viewvc/sos-linux/OFFSCHED/

I have implemented:

1. OFFSCHED-RT. 	A different kind of a real time system.
2. OFFSCHED-TIMER.	A 1us timer.
3. OFFSCHED-RTOP. 	Remote top. OFFSCHED throws top-like information to a nother machine, while the OFFSCHED machine is not accessible
4. OFFSCHED NAPI. 	Offloaded NAPI
5. OFFCSHED SECURED. 	A firewall that protects the operating system.

PATCHES
This email is followed by three patches. hopefully they will make the mainline.

patch 1: offsched core. this is actually a set of utilities
that enable a redirection of the cpu_down to offsched. offsched itself is a set of drivers.

patch 2:
	A tiny patch to export cpu_up.

patch 3:
	include files


There are several more patches,they serve special purpose . like napi or rtop.

Author: Raz Ben Yehuda


