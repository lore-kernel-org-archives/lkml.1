Return-Path: <linux-kernel-owner+w=401wt.eu-S1756460AbYFFKUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460AbYFFKUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 06:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbYFFKUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 06:20:11 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:56409 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbYFFKUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 06:20:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18505.3955.869044.188567@frecb006361.adech.frec.bull.fr>
Date: Fri, 6 Jun 2008 12:20:35 +0200
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC -mm 0/6] sysv ipc: scale msgmnb with the number of cpus
In-Reply-To: <200806061823.22639.nickpiggin@yahoo.com.au>
References: <20080606060955.317871352@bull.net>
	<200806061823.22639.nickpiggin@yahoo.com.au>
X-Mailer: VM 7.19 under Emacs 23.0.50.1
From: Solofo.Ramangalahy@bull.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

Nick Piggin writes:
 > On Friday 06 June 2008 16:09, Solofo.Ramangalahy@bull.net wrote:
 > > The size in bytes of a SysV IPC message queue, msgmnb, is too small
 > > for large machines, but we don't want to bloat small machines
 > 
 > What's your evidence for this? Can you provide before / after
 > performance numbers?

Maybe I have not been clear enough that this is not directly about
performance, but more changing default value. So maybe "scale" in the
title is misleading.

The evidence would be that these default values are changed either
by a patch or "manually":
 > > Several methods are used already to modify (mainly increase) msgmnb:
 > > . distribution specific patch
 > > . system wide sysctl.conf
 > > . application specific tuning via /proc/sys/kernel/msgmnb

Further "evidence" could be googling for "linux msgmnb 65536", to see
that tuning for benchmarks or recommended application configuration
increase the value.

This is just settings default values. Performance test results would
not be different from those obtained by setting the values before
running the tests.

So here :
 > > Here is the timeline of the evolution of MSG* #defines:
 > > Year             1994         1999         1999          2008
 > > Version           1.0       2.3.27       2.3.30        2.6.24
 > > #define MSGMNI    128          128           16            16
 > > #define MSGMAX   4056         8192         8192          8192
 > > #define MSGMNB  16384        16384        16384         16384

I have 65536 instead of 16384 for msgmnb
(1982 instead of 16 for msgmni)
for my 4 cpus/4GB x86_64 machine.

Some result with pmsg used in recent discussions about performance gives:
16384/16: 
./pmsg 4 10 |grep Total
Total: 9795993

65536/1982:
./pmsg 4 10 |grep Total
Total: 9829590

 > Also, when scaling things like this, it is probably more usual to
 > use a log scale rather than linear, so that's a thought.

Agreed, in general.
Here, there are only 4 values, so I do not think it is worth using a
log scale.
If different values are desirable (finer grain, bigger,...), then the
formula can be easily refined:
min(MSGMNB * num_online_cpus(), MSGMNB * MSG_CPU_SCALE);
What I did for the formula is simply taking the old value, a known
modified value and the intermediate values.

I hope this answers your questions,
-- 
solofo





