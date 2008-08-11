Return-Path: <linux-kernel-owner+w=401wt.eu-S1754774AbYHKS3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbYHKS3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 14:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756379AbYHKS2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 14:28:34 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:65172 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756317AbYHKS2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 14:28:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmoFAAMcoEhMRKxB/2dsb2JhbACBX6oR
Date: Mon, 11 Aug 2008 14:28:31 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, rdunlap@xenotime.net,
       mpm@selenic.com, tglx@linutronix.de
Subject: Re: [PATCH 4/5] kmemtrace: SLUB hooks.
Message-ID: <20080811182831.GC32207@Krystal>
References: <1218388447-5578-2-git-send-email-eduard.munteanu@linux360.ro> <1218388447-5578-3-git-send-email-eduard.munteanu@linux360.ro> <1218388447-5578-4-git-send-email-eduard.munteanu@linux360.ro> <1218388447-5578-5-git-send-email-eduard.munteanu@linux360.ro> <48A046F5.2000505@linux-foundation.org> <1218463774.7813.291.camel@penberg-laptop> <48A048FD.30909@linux-foundation.org> <1218464177.7813.293.camel@penberg-laptop> <48A04AEE.8090606@linux-foundation.org> <alpine.DEB.1.10.0808111033320.29861@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808111033320.29861@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:25:15 up 67 days, 23:06,  7 users,  load average: 0.03, 0.30,
	0.44
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Mon, 11 Aug 2008, Christoph Lameter wrote:
> 
> > Pekka Enberg wrote:
> > 
> > > The function call is supposed to go away when we convert kmemtrace to
> > > use Mathieu's markers but I suppose even then we have a problem with
> > > inlining?
> > 
> > The function calls are overwritten with NOPs? Or how does that work?
> 
> I believe in the latest version they are just a variable test. But when 
> Mathieu's immediate code makes it in (which it is in linux-tip), we will 
> be overwriting the conditionals with nops (Mathieu, correct me if I'm 
> wrong here).
> 

The current immediate values in tip does a load immediate, test, branch,
which removes the cost of the memory load. We will try to get gcc
support to be able to declare patchable static jump sites, which could
be patched with NOPs when disabled. But that will probably not happen
"now".

Mathieu

> But the calls themselves are done in the unlikely branch. This is 
> important, as Mathieu stated in previous thread. The reason is that all 
> the stack setup for the function call is also in the unlikely branch, and 
> the normal fast path does not take a hit for the function call setup.
> 
> -- Steve
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
