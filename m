Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887AbZBQRTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbZBQRTG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 12:19:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbZBQRSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 12:18:54 -0500
Received: from tomts20.bellnexxia.net ([209.226.175.74]:57293 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752316AbZBQRSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 12:18:54 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtoEAFd8mklMQWt2/2dsb2JhbACBbtE7hBMG
Date: Tue, 17 Feb 2009 12:18:45 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <peterz@infradead.org>, akpm <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: irq-disabled vs vmap vs text_poke
Message-ID: <20090217171845.GA14435@Krystal>
References: <4995B88C.2090900@redhat.com> <20090213185725.GC7124@Krystal> <4995E925.3080506@redhat.com> <4999808B.5080505@redhat.com> <20090216153145.GB19182@wotan.suse.de> <20090216172441.GA12576@Krystal> <499A1A43.6000009@redhat.com> <20090217030353.GA31504@wotan.suse.de> <499AEA72.9090702@redhat.com> <alpine.DEB.1.10.0902171158180.910@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902171158180.910@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:17:28 up 47 days, 17:15,  4 users,  load average: 0.13, 0.14,
	0.15
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Tue, 17 Feb 2009, Masami Hiramatsu wrote:
> > 
> > Thanks, I think text_poke() doesn't need high performance currently,
> > because it's not called so frequently, nor from the normal operation.
> > 
> > However, Would dynamic ftrace need performance?
> 
> Are you talking about replacing what dynamic ftrace does now with 
> text_poke? Well, It takes just under a second right now to do all the 
> conversions. Looking at the list on my booted box, it converts 19805 
> locations. It takes care to run stop machine, and it also has code to 
> handle NMIs on the other CPUS while it runs.
> 
> Changing text must be done extremely carefully on a running box. If the 
> code being changed is also executed on another CPU then you will most 
> likely take a GPF on that CPU.
> 
> Also, every arch must do things a bit different, due to the way modules 
> are handled.
> 
> -- Steve
> 

Anyway dynamic ftrace only need to do code patching at early boot,
right? Or do you need also to patch the call sites a bit later too ?
Because there is a text_poke_early for that purpose : modifying code
when it is still writable.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
