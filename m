Return-Path: <linux-kernel-owner+w=401wt.eu-S1759892AbZCBSgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892AbZCBSgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 13:36:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754146AbZCBSgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 13:36:24 -0500
Received: from tomts13.bellnexxia.net ([209.226.175.34]:49785 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758048AbZCBSgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 13:36:22 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhIFALO0q0lMQW1W/2dsb2JhbACBWdRAhBoG
Date: Mon, 2 Mar 2009 13:36:17 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Arjan van de Ven <arjan@infradead.org>
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
Message-ID: <20090302183617.GA25105@Krystal>
References: <alpine.DEB.2.00.0902231125520.18221@gandalf.stny.rr.com> <20090223173108.GB1441@Krystal> <alpine.DEB.2.00.0902231236340.18221@gandalf.stny.rr.com> <49A82851.5080707@redhat.com> <20090227180724.GA17947@Krystal> <49A83237.40604@redhat.com> <20090227185316.GA19811@Krystal> <49A853CD.3020607@redhat.com> <49AC10E9.1090102@redhat.com> <20090302102841.7e099670@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090302102841.7e099670@infradead.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:34:57 up 2 days, 15:01,  3 users,  load average: 0.72, 0.55,
	0.39
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven (arjan@infradead.org) wrote:
> > 
> > Use map_vm_area() instead of vmap() in text_poke() for avoiding page
> > allocation and delayed unmapping, and call vunmap_page_range() and
> > local_flush_tlb() directly because this mapping is temporary and
> > local.
> > 
> > At the result of above change, text_poke() becomes atomic and can be
> > called from stop_machine() etc.
> 
> .... but text_poke() realistically needs to call stop_machine() since
> you can't poke live code.... so that makes me wonder how useful this
> is...

Hi Arjan,

Stop machine is not required when inserting a breakpoint. And cleverly
using this breakpoint technique can permit modifying other instructions
as well.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
