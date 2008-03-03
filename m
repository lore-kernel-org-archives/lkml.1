Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbYCCL5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbYCCL5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 06:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbYCCL5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 06:57:36 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:44687 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751740AbYCCL5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 06:57:35 -0500
X-SourceIP: 80.56.237.116
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Max Krasnyanskiy <maxk@qualcomm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Rostedt <rostedt@goodmis.org>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org,
       David Rientjes <rientjes@google.com>
In-Reply-To: <47C8771C.1070001@qualcomm.com>
References: <20080227222103.673194000@chello.nl>
	 <1204311351.6243.130.camel@lappy> <20080229190223.GA17820@elte.hu>
	 <47C87084.3090208@qualcomm.com> <1204318980.6243.133.camel@lappy>
	 <47C8771C.1070001@qualcomm.com>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 12:57:25 +0100
Message-Id: <1204545445.11412.6.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-29 at 13:20 -0800, Max Krasnyanskiy wrote:
> Peter Zijlstra wrote:
> 
> > But yeah, this was just a quick hack to show the idea, glad you like it.
> > Will try to flesh it out a bit in the coming week.
> 
> Are you going to add code for "boot" cpuset ?
> I wrote user-space code that is does that, but as I understand from previous 
> discussions we want to create that in the kernel.

Yeah, I'll be trying to (lack of cgroup fu for the moment).

I think something like

 /cgroup
 /cgroup/system
 /cgroup/system/boot

 /cgroup/big_honking_app
 /cgroup/rt_domain

Where the system group includes all IRQs and all unbound kernel threads
(by default). The system/boot group will contain all of userspace.

Doing it in this way ought to allow for some weird setups. The system
group can overlap with anything that does need system services. The boot
group must be a subset thereof, and can be shrunk to a small part of the
machine.



