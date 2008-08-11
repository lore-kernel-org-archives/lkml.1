Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbYHKOjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbYHKOjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 10:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbYHKOjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 10:39:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46654 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754492AbYHKOjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 10:39:16 -0400
Message-ID: <48A04EC2.1080302@linux-foundation.org>
Date: Mon, 11 Aug 2008 09:37:54 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mathieu.desnoyers@polymtl.ca, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, rdunlap@xenotime.net, mpm@selenic.com,
       tglx@linutronix.de
Subject: Re: [PATCH 4/5] kmemtrace: SLUB hooks.
References: <1218388447-5578-1-git-send-email-eduard.munteanu@linux360.ro>  <1218388447-5578-2-git-send-email-eduard.munteanu@linux360.ro>  <1218388447-5578-3-git-send-email-eduard.munteanu@linux360.ro>  <1218388447-5578-4-git-send-email-eduard.munteanu@linux360.ro>  <1218388447-5578-5-git-send-email-eduard.munteanu@linux360.ro>  <48A046F5.2000505@linux-foundation.org> <1218463774.7813.291.camel@penberg-laptop> <48A048FD.30909@linux-foundation.org> <alpine.DEB.1.10.0808111027370.29861@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0808111027370.29861@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:

> The kmemtrace_mark_alloc_node itself is an inline function, which calls 
> another inline function "trace_mark" which is designed to test a 
> read_mostly variable, and will do an "unlikely" jmp if the variable is 
> set (which it is when tracing is enabled), to the actual function call.
> 
> There should be no extra function calls when this is configured on but 
> tracing disabled. We try very hard to keep the speed of the tracer as 
> close to a non tracing kernel as possible when tracing is disabled.

Makes sense. But then we have even more code bloat because of the tests that
are inserted in all call sites of kmalloc.



