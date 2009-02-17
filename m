Return-Path: <linux-kernel-owner+w=401wt.eu-S1753945AbZBQRC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbZBQRC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 12:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbZBQRCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 12:02:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33658 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbZBQRCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 12:02:47 -0500
Date: Tue, 17 Feb 2009 12:02:44 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Masami Hiramatsu <mhiramat@redhat.com>
cc: Nick Piggin <npiggin@suse.de>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <peterz@infradead.org>, akpm <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: irq-disabled vs vmap vs text_poke
In-Reply-To: <499AEA72.9090702@redhat.com>
Message-ID: <alpine.DEB.1.10.0902171158180.910@gandalf.stny.rr.com>
References: <20090213141839.GA31922@Krystal> <4995A0B7.1030705@redhat.com> <20090213165555.GA4684@Krystal> <4995B88C.2090900@redhat.com> <20090213185725.GC7124@Krystal> <4995E925.3080506@redhat.com> <4999808B.5080505@redhat.com> <20090216153145.GB19182@wotan.suse.de>
 <20090216172441.GA12576@Krystal> <499A1A43.6000009@redhat.com> <20090217030353.GA31504@wotan.suse.de> <499AEA72.9090702@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 17 Feb 2009, Masami Hiramatsu wrote:
> 
> Thanks, I think text_poke() doesn't need high performance currently,
> because it's not called so frequently, nor from the normal operation.
> 
> However, Would dynamic ftrace need performance?

Are you talking about replacing what dynamic ftrace does now with 
text_poke? Well, It takes just under a second right now to do all the 
conversions. Looking at the list on my booted box, it converts 19805 
locations. It takes care to run stop machine, and it also has code to 
handle NMIs on the other CPUS while it runs.

Changing text must be done extremely carefully on a running box. If the 
code being changed is also executed on another CPU then you will most 
likely take a GPF on that CPU.

Also, every arch must do things a bit different, due to the way modules 
are handled.

-- Steve

