Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbYHOWvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbYHOWvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 18:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbYHOWu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 18:50:56 -0400
Received: from gw.goop.org ([64.81.55.164]:42528 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbYHOWuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 18:50:55 -0400
Message-ID: <48A6082E.70405@goop.org>
Date: Fri, 15 Aug 2008 15:50:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Roland McGrath <roland@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>, srostedt@redhat.com
Subject: Re: [PATCH] ftrace: use only 5 byte nops for x86
References: <alpine.DEB.1.10.0808141755030.2911@gandalf.stny.rr.com> <48A4C491.4050301@goop.org> <20080815092231.GB22209@elte.hu> <48A6037B.6030202@zytor.com> <alpine.LFD.1.10.0808151542330.3324@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808151542330.3324@nehalem.linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> I also suspect that we'd really be much better off just fixing the generic 
> NOP tables for the 5-byte nop. As far as I could tell, from all the 
> numbers that have been posted, absolutely _none_ show that there is any 
> point at all to the 2-instruction 3/2-byte sequence.
>
> So instead of having a magic special ftrace-only thing, why not just do it 
> right, and fix the generic 5-byte nop sequence?
>   

Well, there's two distinct issues here.  There's the need for a
single-instruction 5 byte nop, and the need for efficient nops.  It so
happens in this case that they're the same thing.  But in general, the
generic nop interface is intended to return the most efficient nop, not
an atomic nop (or with any other properties).  To handle it generically,
we'd either need to redefine the meaning of the existing nop-padding
interface, or add an "atomic nop" interface.

    J
