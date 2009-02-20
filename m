Return-Path: <linux-kernel-owner+w=401wt.eu-S1756737AbZBTX6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737AbZBTX6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 18:58:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbZBTX6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 18:58:14 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:1750 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538AbZBTX6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 18:58:13 -0500
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Feb 2009 18:58:13 EST
From: "David Schwartz" <davids@webmaster.com>
To: <linux-kernel@vger.kernel.org>
Subject: RE: SMP Kernel
Date: Fri, 20 Feb 2009 15:52:39 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKKEPADKAD.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
In-Reply-To: <499EC317.6010506@sundmangroup.com>
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Fri, 20 Feb 2009 15:53:16 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Fri, 20 Feb 2009 15:53:16 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hi,
> Ok, since the memory is shared between all the cores the Kernel can be
> invoked by any core receiving an interrupt and thus executed by that core?

Right.

> If the above is right then how come that two separate CPUs can wake up,
> schedule and context-switch completely in parallel?
> Are there an independent scheduler per cpu?

There is a scheduler that can run on any CPU that needs to schedule.
However, the scheduler is designed to be scalable across large numbers of
CPUs.

There is meaningful distinction between "there is one scheduler that can run
on any CPU" and "each CPU has its own scheduler". Whether you look at the
scheduler running on one CPU as the same scheduler or a different scheduler
as the scheduler running on another CPU is purely a question of semantics.

If I run two copies of 'ls', are they the same program or not?

> Directly from the sched-design.txt
>
> - 'perfect' SMP scalability. With the new scheduler there is no 'big'
>    runqueue_lock anymore - it's all per-CPU runqueues and locks - two
>    tasks on two separate CPUs can wake up, schedule and context-switch
>    completely in parallel, without any interlocking. All
>    scheduling-relevant data is structured for maximum scalability.

So the scheduler operates on per-CPU data structures, allowing multiple CPUs
to run the scheduler code at the same time without slowing each other down.

DS


