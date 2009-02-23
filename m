Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113AbZBWCdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbZBWCdp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 21:33:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbZBWCdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 21:33:37 -0500
Received: from tomts36.bellnexxia.net ([209.226.175.93]:64214 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752629AbZBWCdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 21:33:36 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoMFACOaoUlMQWXi/2dsb2JhbACBbtIShA8G
Date: Sun, 22 Feb 2009 21:33:33 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/6] ftrace, x86: make kernel text writable only for
	conversions
Message-ID: <20090223023332.GA5430@Krystal>
References: <20090220011316.379904625@goodmis.org> <20090220011521.003556651@goodmis.org> <87y6vyuzsn.fsf@basil.nowhere.org> <alpine.DEB.2.00.0902221741040.18221@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0902221741040.18221@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:30:23 up 1 day, 18:04,  3 users,  load average: 0.25, 0.41,
	0.40
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> 
> 
> On Sun, 22 Feb 2009, Andi Kleen wrote:
> 
> > Steven Rostedt <rostedt@goodmis.org> writes:
> > 
> > > From: Steven Rostedt <srostedt@redhat.com>
> > >
> > > Impact: keep kernel text read only
> > >
> > > Because dynamic ftrace converts the calls to mcount into and out of
> > > nops at run time, we needed to always keep the kernel text writable.
> > >
> > > But this defeats the point of CONFIG_DEBUG_RODATA. This patch converts
> > > the kernel code to writable before ftrace modifies the text, and converts
> > > it back to read only afterward.
> > >
> > > The conversion is done via stop_machine and no IPIs may be executed
> > > at that time. The kernel text is set to write just before calling
> > > stop_machine and set to read only again right afterward.
> > 
> > The very old text poke code I had for this just used a dynamic
> > mapping elsewhere instead to modify the code. That's much less
> > intrusive than changing the complete mappings. Any reason you can't use 
> > that too?
> > 
> 
> We are changing over 19000 locations in the kernel. This touches almost 
> all kernel text pages anyway. You want to map a page in and out for over 
> 19000 locations?
> 
> -- Steve
> 

Hi Steve,

Can you provide numbers to indicate why it's required to be so intrusive
in the kernel mappings while doing these modifications ? I think opening
such time window where standard code mapping is writeable globally in
config RO_DATA kernels could open the door to unexpected side-effects,
so ideally going through the "backdoor" page mapped by text_poke seems
safer. Given similar performance, I would tend to use a text_poke-like
approach.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
