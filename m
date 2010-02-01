Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab0BARsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 12:48:38 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:57365 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab0BARsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 12:48:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aOmrMQ+cTkrBEc3fxPXzPuU3CHxjxHIHoU92e8/LprfcaxwQD+Jg9E29TkkN/NkU6n
         XMcZfdFdVynDBtwdLKpEohSynoKqkBI05exwau4o9KvfLDlyEUgjSba2Vj6WDqXr0haI
         1DpNA3ZGZGlNIETapL5Fydn7stqBfZ33kZCM0=
Date: Mon, 1 Feb 2010 18:48:34 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Lock dependency based tree report in perf lock
Message-ID: <20100201174831.GB5241@nowhere>
References: <20100129231723.GB5052@nowhere> <1264841188.24455.54.camel@laptop> <20100130185736.GC5675@nowhere> <1265012704.24455.80.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265012704.24455.80.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 09:25:04AM +0100, Peter Zijlstra wrote:
> On Sat, 2010-01-30 at 19:57 +0100, Frederic Weisbecker wrote:
> > On Sat, Jan 30, 2010 at 09:46:28AM +0100, Peter Zijlstra wrote:
> > > On Sat, 2010-01-30 at 00:17 +0100, Frederic Weisbecker wrote:
> > > > 
> > > > 
> > > > Anyway, that's just an idea, not trivial I must admit.
> > > 
> > > lockdep actually collects all this information, so writing it out isn't
> > > too hard.
> > 
> > 
> > 
> > Lockdep collects the theorical dependencies but not the practical
> > scenarios.
> > 
> > Say B and C depend on A, you'll get:
> > 
> >    A
> >   / \
> >  B   C
> > 
> > But nothing can tell you that if A is taken, B and C will always
> > be taken. You may have different scenarios based on this dependency,
> > which is not something that lockdep logs, right?
> 
> Right. But we keep track of the full held lock stack, which is what was
> requested.



Ah, I see what you mean. Yeah we have that, but it is a runtime check
feature, and the representation is linear. We should not add further
tracepoint based on this to get the possible scenarios of locking,
we should rather deduce them from the current tracepoints we have.

Would be a bad idea to add even more overhead.

