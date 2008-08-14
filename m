Return-Path: <linux-kernel-owner+w=401wt.eu-S1754358AbYHNRYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbYHNRYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 13:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbYHNRY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 13:24:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35760 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbYHNRY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 13:24:28 -0400
Message-ID: <48A46897.4040900@zytor.com>
Date: Thu, 14 Aug 2008 10:17:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Steven Rostedt <srostedt@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [RFC PATCH] x86 alternatives : fix LOCK_PREFIX race with	preemptible
 kernel and CPU hotplug
References: <20080813193011.GC15547@Krystal> <20080813193715.GQ1366@one.firstfloor.org> <20080813200119.GA18966@Krystal> <20080813234156.GA25775@Krystal> <48A375E3.9090609@zytor.com> <48A388CE.2020404@goop.org> <20080814014944.GA31883@Krystal> <48A3A806.8060509@goop.org> <20080814151805.GA29507@Krystal> <48A459B1.2070601@zytor.com> <20080814165802.GC517@Krystal>
In-Reply-To: <20080814165802.GC517@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> 
> Sure, here are the updated tables. Basically, they show no significant
> difference between the NOP and the DS segment selector prefix
> approaches.
> 

Actually, unless I have blown my T-test completely, they show with a 80% 
and 74% confidence (respective for the two benchmarks) that the DS case 
is slightly *better* (0.26% and 0.20% better, respective), which makes 
it a no-brainer.  Doing around 10 runs of each is likely to confirm this 
conclusion by pushing it into the 90+% interval.

Note that since the difference is so small, and so can also be due to 
some kind of systematic error (lower ambient temperature during the DS 
run making the disk drive slightly faster, what have you.)

	-hpa
