Return-Path: <linux-kernel-owner+w=401wt.eu-S1759583AbYHOQIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759583AbYHOQIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 12:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753630AbYHOQI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 12:08:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752973AbYHOQI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 12:08:29 -0400
Date: Fri, 15 Aug 2008 09:06:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, Steven Rostedt <rostedt@goodmis.org>,
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
       Christoph Lameter <cl@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86 alternatives : fix LOCK_PREFIX race with preemptible
 kernel and CPU hotplug
In-Reply-To: <20080814205815.GA14076@Krystal>
Message-ID: <alpine.LFD.1.10.0808150854140.3324@nehalem.linux-foundation.org>
References: <20080814205815.GA14076@Krystal>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 14 Aug 2008, Mathieu Desnoyers wrote:
>
> Changing the 0x90 (single-byte nop) currently used into a 0x3E DS segment
> override prefix should fix this issue. Since the default of the atomic
> instructions is to use the DS segment anyway, it should not affect the
> behavior.

Ok, so I think this is an _excellent_ patch, but I'd like to also then use 
LOCK_PREFIX in include/asm-x86/futex.h.

See commit 9d55b9923a1b7ea8193b8875c57ec940dc2ff027.

		Linus
