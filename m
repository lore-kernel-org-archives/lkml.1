Return-Path: <linux-kernel-owner+w=401wt.eu-S1753647AbYHNDgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbYHNDgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 23:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbYHNDgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 23:36:05 -0400
Received: from gw.goop.org ([64.81.55.164]:51300 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbYHNDgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 23:36:04 -0400
Message-ID: <48A3A806.8060509@goop.org>
Date: Wed, 13 Aug 2008 20:35:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
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
References: <alpine.DEB.1.10.0808082113090.3707@gandalf.stny.rr.com> <20080813175213.GA8679@Krystal> <alpine.LFD.1.10.0808131119290.3462@nehalem.linux-foundation.org> <20080813184142.GM1366@one.firstfloor.org> <20080813193011.GC15547@Krystal> <20080813193715.GQ1366@one.firstfloor.org> <20080813200119.GA18966@Krystal> <20080813234156.GA25775@Krystal> <48A375E3.9090609@zytor.com> <48A388CE.2020404@goop.org> <20080814014944.GA31883@Krystal>
In-Reply-To: <20080814014944.GA31883@Krystal>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> A virtualized guest kernel could use that to limit its use of the
> overall machine CPU resources in different time periods. Policies can
> determine how many physical CPU a virtual machine can be tied to, and
> that may change depending on e.g. the workload or time of day. Having
> the ability to efficiently switch to UP for a long period of time seems
> important in this use-case.

Not very convinced.  Unplugging cpus is a pretty coarse way to control 
resource use.  There are lots of other mechanisms.  And it's not like an 
uncontended lock is all that expensive these days...

    J

