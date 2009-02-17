Return-Path: <linux-kernel-owner+w=401wt.eu-S1754571AbZBQRtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbZBQRtF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 12:49:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbZBQRsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 12:48:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53571 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379AbZBQRso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 12:48:44 -0500
Date: Tue, 17 Feb 2009 12:48:42 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Masami Hiramatsu <mhiramat@redhat.com>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <peterz@infradead.org>, akpm <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: irq-disabled vs vmap vs text_poke
In-Reply-To: <20090217172850.GB14435@Krystal>
Message-ID: <alpine.DEB.1.10.0902171246510.910@gandalf.stny.rr.com>
References: <4995E925.3080506@redhat.com> <4999808B.5080505@redhat.com> <20090216153145.GB19182@wotan.suse.de> <20090216172441.GA12576@Krystal> <499A1A43.6000009@redhat.com> <20090217030353.GA31504@wotan.suse.de> <499AEA72.9090702@redhat.com>
 <alpine.DEB.1.10.0902171158180.910@gandalf.stny.rr.com> <20090217171845.GA14435@Krystal> <alpine.DEB.1.10.0902171224050.910@gandalf.stny.rr.com> <20090217172850.GB14435@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 17 Feb 2009, Mathieu Desnoyers wrote:

> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > 
> > On Tue, 17 Feb 2009, Mathieu Desnoyers wrote:
> > > > 
> > > 
> > > Anyway dynamic ftrace only need to do code patching at early boot,
> > > right? Or do you need also to patch the call sites a bit later too ?
> > > Because there is a text_poke_early for that purpose : modifying code
> > > when it is still writable.
> > 
> > It modifies the code both at early boot up, and when it is enabled later 
> > on at run time.
> > 
> > -- Steve
> > 
> 
> OK, so without text_poke, how does it deal with kernel with text pages
> marked read-only after boot ?

Actually, we cheat. If DYNAMIC_FTRACE is configured in, we do not set the 
text sections to read only. But if this needs to be fixed, we can easily 
change it so that before we do the convesion, we set all text back to 
write and after the conversion we set it back to read.  The conversion 
itself is done via stop_machine, so we do not need to worry about other 
things going on.

-- Steve

