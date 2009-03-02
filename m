Return-Path: <linux-kernel-owner+w=401wt.eu-S1757195AbZCBSzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195AbZCBSzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 13:55:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbZCBSzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 13:55:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:51083 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbZCBSy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 13:54:59 -0500
Date: Mon, 2 Mar 2009 10:55:00 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Steven Rostedt <rostedt@goodmis.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC][PATCH] x86: make text_poke() atomic
Message-ID: <20090302105500.569e1270@infradead.org>
In-Reply-To: <20090302183617.GA25105@Krystal>
References: <alpine.DEB.2.00.0902231125520.18221@gandalf.stny.rr.com>
	<20090223173108.GB1441@Krystal>
	<alpine.DEB.2.00.0902231236340.18221@gandalf.stny.rr.com>
	<49A82851.5080707@redhat.com>
	<20090227180724.GA17947@Krystal>
	<49A83237.40604@redhat.com>
	<20090227185316.GA19811@Krystal>
	<49A853CD.3020607@redhat.com>
	<49AC10E9.1090102@redhat.com>
	<20090302102841.7e099670@infradead.org>
	<20090302183617.GA25105@Krystal>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Mar 2009 13:36:17 -0500
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> * Arjan van de Ven (arjan@infradead.org) wrote:
> > > 
> > > Use map_vm_area() instead of vmap() in text_poke() for avoiding
> > > page allocation and delayed unmapping, and call
> > > vunmap_page_range() and local_flush_tlb() directly because this
> > > mapping is temporary and local.
> > > 
> > > At the result of above change, text_poke() becomes atomic and can
> > > be called from stop_machine() etc.
> > 
> > .... but text_poke() realistically needs to call stop_machine()
> > since you can't poke live code.... so that makes me wonder how
> > useful this is...
> 
> Hi Arjan,
> 
> Stop machine is not required when inserting a breakpoint. 

that is your assumption; when I spoke with CPU architects they
cringed ;(



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
