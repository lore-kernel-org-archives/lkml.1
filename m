Return-Path: <linux-kernel-owner+w=401wt.eu-S1753072AbYHGVgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072AbYHGVgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 17:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbYHGVfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 17:35:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34225 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756662AbYHGVfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 17:35:18 -0400
Date: Thu, 7 Aug 2008 17:35:16 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Bodo Eggert <7eggert@gmx.de>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Roland McGrath <roland@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 0/5] ftrace: to kill a daemon
In-Reply-To: <E1KRD1p-0001SX-0p@be1.7eggert.dyndns.org>
Message-ID: <alpine.DEB.1.10.0808071730470.10092@gandalf.stny.rr.com>
References: <aYipy-5FM-9@gated-at.bofh.it> <E1KRD1p-0001SX-0p@be1.7eggert.dyndns.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 7 Aug 2008, Bodo Eggert wrote:

> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > The idea I came
> > up with was to make a tmp.s file for every object just after it is compiled.
> 
> make -j would cause these files to overwrite each other, wouldn't it?

I simplified my explanation. I really used something like this:

for init/main.o:

init/.tmp_mc_main.s  : for the list file
init/.tmp_mc_main.o  : for the list compiled object.
init/.tmp_gl_main.o  : for the object converted static to global.
init/.tmp_mx_main.o  : for the merged list and global object.


The tmp.s was to keep the focus on the concept. But the actual 
implementation handles multi-threaded builds.

I use distcc and build with -j40. I had no issues.

Thanks,

-- Steve

