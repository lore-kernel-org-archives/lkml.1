Return-Path: <linux-kernel-owner+w=401wt.eu-S1757868AbZKXHxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868AbZKXHxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 02:53:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757807AbZKXHxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 02:53:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49502 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757732AbZKXHxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 02:53:36 -0500
Date: Tue, 24 Nov 2009 08:52:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip v5 00/10] kprobes: Kprobes jump optimization support
Message-ID: <20091124075249.GC21991@elte.hu>
References: <20091123232115.22071.71558.stgit@dhcp-100-2-132.bos.redhat.com>
 <20091124020315.GA6221@nowhere>
 <20091124032008.GD6752@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091124032008.GD6752@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Tue, Nov 24, 2009 at 03:03:19AM +0100, Frederic Weisbecker wrote:
> > On Mon, Nov 23, 2009 at 06:21:16PM -0500, Masami Hiramatsu wrote:
> > >   When the optimized-kprobe is hit before optimization, its handler
> > >  changes IP(instruction pointer) to copied code and exits. So, the
> > >  instructions which were copied to detour buffer are executed on the detour
> > >  buffer.
> > 
> > 
> > 
> > Hm, why is it playing such hybrid game there?
> > If I understand well, we have executed int 3, executed the
> > handler and we jump back to the detour buffer?
> > 
> 
> I got it, I think. We have instructions to patch. And the above turn 
> this area into dead code, safe to patch.
> 
> But still, stop_machine() seem to make it not necessary anymore.

i think 'sending an IPI to all online CPUs' might be an adequate 
sequence to make sure patching effects have propagated. I.e. an 
smp_call_function() with a dummy function?

	Ingo
