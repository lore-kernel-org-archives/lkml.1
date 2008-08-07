Return-Path: <linux-kernel-owner+w=401wt.eu-S1755254AbYHGSTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbYHGSTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 14:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbYHGST0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 14:19:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269AbYHGSTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 14:19:25 -0400
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       akpm@linux-foundation.org, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Subject: Re: LTTng finds abnormally long APIC interrupt handler : 58.2 ms
References: <20080805182007.GA4631@Krystal>
	<alpine.DEB.1.10.0808051523370.28170@gandalf.stny.rr.com>
	<20080807160907.GA11255@Krystal>
	<alpine.DEB.1.10.0808071314320.20931@gandalf.stny.rr.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Thu, 07 Aug 2008 14:15:57 -0400
In-Reply-To: <alpine.DEB.1.10.0808071314320.20931@gandalf.stny.rr.com> (Steven Rostedt's message of "Thu, 7 Aug 2008 13:41:09 -0400 (EDT)")
Message-ID: <y0mwsisitcy.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Steven Rostedt <rostedt@goodmis.org> writes:

> [...]
>> It all holds in a small module. Having the ability to connect any marker
>> on any generic probe from the lttng marker interface has been very
>> useful to do all this. Actually, this module has to be built into the
>> kernel because ftrace does not permit breeing the trace_ops data
>> structure. :/
>
> I did this purposely. The reason is that there is no safe way to release
> the trace_ops, because you never know if something is in the function
> you pointed to. If you remove the module after that, it crashes.
>
> I've been thinking of exporting it, and make it so that once you 
> register something to the trace_ops, I'll up the module count, and never 
> let that module unload.

This issue will need some sort of resolution if systemtap is to be
able to hook up to ftrace.  Perhaps we could have a second/nested API
that suffers the costs of explicit reference counting, but does permit
dynamic attach and robust detach.


- FChE
