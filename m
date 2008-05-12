Return-Path: <linux-kernel-owner+w=401wt.eu-S1758656AbYELJFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656AbYELJFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 05:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754845AbYELJEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 05:04:55 -0400
Received: from mail.gmx.net ([213.165.64.20]:37346 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754297AbYELJEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 05:04:54 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+8ejh8oyS8EieNDS6H07qs5KiiveDkd1SG3g74ow
	7x8RzMbSLAofVM
Subject: Re: volanoMark regression with kernel 2.6.26-rc1
From: Mike Galbraith <efault@gmx.de>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: vatsa@linux.vnet.ibm.com, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <1210568533.3151.13.camel@ymzhang>
References: <20080506115207.GA24862@linux.vnet.ibm.com>
	 <20080507173357.GA4424@linux.vnet.ibm.com>
	 <1210223914.3453.102.camel@ymzhang>
	 <20080508054047.GD32729@linux.vnet.ibm.com>
	 <1210226013.3453.113.camel@ymzhang>
	 <20080508061125.GC3644@linux.vnet.ibm.com>
	 <20080509155240.GH3612@linux.vnet.ibm.com>
	 <1210556351.3151.2.camel@ymzhang>
	 <20080512023758.GN3612@linux.vnet.ibm.com>
	 <1210563200.3151.10.camel@ymzhang>
	 <20080512045246.GP3612@linux.vnet.ibm.com>
	 <1210568533.3151.13.camel@ymzhang>
Content-Type: text/plain; charset=utf-8
Date: Mon, 12 May 2008 11:04:50 +0200
Message-Id: <1210583090.7402.4.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-05-12 at 13:02 +0800, Zhang, Yanmin wrote:

> A quick update:
> With 2.6.26-rc2 (﻿CONFIG_USER_SCHED=y), volanoMa﻿rk result on my 8-core stoakley
> is about 10% worse than the one of 2.6.26-rc1.

Here (Q6600), 2.6.26-rc2 ﻿CONFIG_USER_SCHED=y regression culprit for
volanomark is the same one identified for mysql+oltp.

(i have yet to figure out where the buglet lies, but there is definitely
one in there somewhere)

2.6.25.3-smp (baseline, no group scheduling)
test-1.log:Average throughput = 102412 messages per second
test-2.log:Average throughput = 99636 messages per second
test-3.log:Average throughput = 99373 messages per second

CONFIG_CGROUPS=n
CONFIG_USER_SCHED=y

2.6.26-rc2 - 18d95a2832c1392a2d63227a7a6d433cb9f2037e
test-1.log:Average throughput = 102341 messages per second
test-2.log:Average throughput = 101710 messages per second
test-3.log:Average throughput = 100572 messages per second


2.6.26-rc2 + 18d95a2832c1392a2d63227a7a6d433cb9f2037e
test-1.log:Average throughput = 79506 messages per second
test-2.log:Average throughput = 78168 messages per second
test-3.log:Average throughput = 78200 messages per second

CONFIG_CGROUPS=y
CONFIG_USER_SCHED=y

2.6.26-rc2 - 18d95a2832c1392a2d63227a7a6d433cb9f2037e
test-1.log:Average throughput = 103494 messages per second
test-2.log:Average throughput = 100832 messages per second
test-3.log:Average throughput = 98840 messages per second

2.6.26-rc2 + 18d95a2832c1392a2d63227a7a6d433cb9f2037e
test-1.log:Average throughput = 80132 messages per second
test-2.log:Average throughput = 79410 messages per second
test-3.log:Average throughput = 79609 messages per second

CONFIG_CGROUPS=y
CONFIG_CGROUP_SCHED=y

2.6.26-rc2 - 18d95a2832c1392a2d63227a7a6d433cb9f2037e
test-1.log:Average throughput = 103026 messages per second
test-2.log:Average throughput = 101152 messages per second
test-3.log:Average throughput = 102616 messages per second

2.6.26-rc2 + 18d95a2832c1392a2d63227a7a6d433cb9f2037e
test-1.log:Average throughput = 104174 messages per second
test-2.log:Average throughput = 101390 messages per second
test-3.log:Average throughput = 101212 messages per second

(but there are no task groups set up...)


