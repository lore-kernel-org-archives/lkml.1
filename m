Return-Path: <linux-kernel-owner+w=401wt.eu-S1756459AbYHKS3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459AbYHKS3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 14:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbYHKS3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 14:29:41 -0400
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:60552 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752978AbYHKS3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 14:29:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmoFAAMcoEhMRKxB/2dsb2JhbACBX6oR
Date: Mon, 11 Aug 2008 14:29:38 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, rdunlap@xenotime.net,
       mpm@selenic.com, tglx@linutronix.de
Subject: Re: [PATCH 4/5] kmemtrace: SLUB hooks.
Message-ID: <20080811182938.GD32207@Krystal>
References: <1218388447-5578-1-git-send-email-eduard.munteanu@linux360.ro> <1218388447-5578-2-git-send-email-eduard.munteanu@linux360.ro> <1218388447-5578-3-git-send-email-eduard.munteanu@linux360.ro> <1218388447-5578-4-git-send-email-eduard.munteanu@linux360.ro> <1218388447-5578-5-git-send-email-eduard.munteanu@linux360.ro> <48A046F5.2000505@linux-foundation.org> <1218463774.7813.291.camel@penberg-laptop> <48A048FD.30909@linux-foundation.org> <alpine.DEB.1.10.0808111027370.29861@gandalf.stny.rr.com> <48A04EC2.1080302@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48A04EC2.1080302@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:28:52 up 67 days, 23:09,  7 users,  load average: 0.22, 0.28,
	0.41
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux-foundation.org) wrote:
> Steven Rostedt wrote:
> 
> > The kmemtrace_mark_alloc_node itself is an inline function, which calls 
> > another inline function "trace_mark" which is designed to test a 
> > read_mostly variable, and will do an "unlikely" jmp if the variable is 
> > set (which it is when tracing is enabled), to the actual function call.
> > 
> > There should be no extra function calls when this is configured on but 
> > tracing disabled. We try very hard to keep the speed of the tracer as 
> > close to a non tracing kernel as possible when tracing is disabled.
> 
> Makes sense. But then we have even more code bloat because of the tests that
> are inserted in all call sites of kmalloc.
> 

The long-term goal is to turn the tests into NOPs, but only once we get
gcc support.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
