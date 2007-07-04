Return-Path: <linux-kernel-owner+w=401wt.eu-S1759456AbXGDUtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456AbXGDUtt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 16:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755485AbXGDUtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 16:49:40 -0400
Received: from www.osadl.org ([213.239.205.134]:48729 "EHLO mail.tglx.de"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755307AbXGDUtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 16:49:39 -0400
Subject: v2.6.21.5-rt19
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: RT-Users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       "jcaceres@ccrma.Stanford.EDU" <jcaceres@ccrma.Stanford.EDU>,
       Carsten Emde <Carsten.Emde@osadl.org>
Content-Type: text/plain
Date: Wed, 04 Jul 2007 22:49:15 +0200
Message-Id: <1183582155.3291.160.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm pleased to announce the v2.6.21.5-rt19 kernel on behalf of Ingo.

It can be downloaded from the usual place:
 
     http://people.redhat.com/mingo/realtime-preempt/
  
More info about the -rt patch set can be found in the RT wiki:
   
     http://rt.wiki.kernel.org

Changes since 2.6.21.5-rt18:

- Fixed a nasty and hard to track down slowness / boot problem on SMP
machines with CONFIG_NOHZ enabled. The problem was caused by the timer
wheel base lock held during the get_next_timer_interrupt() call in the
idle path, which eventually led to a bogus PI boosting of the idle task
and in consequence a stale wrong scheduler selection for the affected
idle task.

Kudos to Carsten Emde, who patiently and meticulously isolated the
problem and provided the traces, which allowed to identify the root
cause.

Problem solution: Prevent idle task boosting

- back port of the ntp / clock_was_set fix

- integration of the processor_idle fix from Venki Pallipadi, which
resolves boot issues on some platforms

- ep93xx clock events fix from Manfred Gruber


To build a 2.6.21.5-rt19 tree, the following patches should be applied:
  
    http://kernel.org/pub/linux/kernel/v2.6/linux-2.6.21.5.tar.bz2
    http://people.redhat.com/mingo/realtime-preempt/patch-2.6.21.5-rt19

Thanks,

	tglx


