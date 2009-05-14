Return-Path: <linux-kernel-owner+w=401wt.eu-S1753843AbZENN0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbZENN0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 09:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbZENN0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 09:26:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42292 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbZENN0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 09:26:39 -0400
Date: Thu, 14 May 2009 09:26:34 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       zhaolei@cn.fujitsu.com, laijs@cn.fujitsu.com,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH v4] ftrace: add a tracepoint for
 __raise_softirq_irqoff()
In-Reply-To: <20090514124013.GC21241@Krystal>
Message-ID: <alpine.DEB.2.00.0905140926010.30591@gandalf.stny.rr.com>
References: <49FFDF9C.7040505@cn.fujitsu.com> <20090505161604.GA15524@Krystal> <4A07D3B3.10605@cn.fujitsu.com> <20090511134019.GB10932@Krystal> <alpine.DEB.2.00.0905111003280.14976@gandalf.stny.rr.com> <20090511142734.GA12722@Krystal>
 <alpine.DEB.2.00.0905111039470.2492@gandalf.stny.rr.com> <20090511151353.GA14391@Krystal> <4A094677.5090900@cn.fujitsu.com> <4A0BF82A.2070208@cn.fujitsu.com> <20090514124013.GC21241@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 14 May 2009, Mathieu Desnoyers wrote:
> > From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > 
> > This patch is modified from Mathieu Desnoyers' patch. The original patch
> > can be found here: 
> > 	http://marc.info/?l=linux-kernel&m=123791201816245&w=2
> > This tracepoint can trace the time stamp when softirq action is raised. 
> > 
> > Changelog for v1 -> v2: 
> > 1: Use TRACE_EVENT instead of DEFINE_TRACE
> > 2: Move the tracepoint from raise_softirq_irqoff() to
> >    __raise_softirq_irqoff()
> > 
> > Changelog for v2 -> v3: 
> > Move the definition of __raise_softifq_irqoff() to .c file when
> > CONFIG_TRACEPOINTS is enabled, to avoid recursive includes
> > 
> > Changelog for v3 -> v4: 
> > 1: Come back to v2, and use forward declarations to avoid
> >    recursive includes as Mathieu's suggestion
> > 2: Modifiy the tracepoint name
> > 3: Add comments for this tracepoint
> > 
> 
> This is a step in the right direction, but please see my email to Lai
> about the fact that this assumes correct and undocumented include
> dependencies in kernel/trace/events.c. Not explicitely stating the
> include dependencies is a build error waiting to happen.
> 
> Including interrupt.h under a ifdef would allow keeping track of
> TRACE_EVENT specific build dependencies neatly on a per header basis.

This is all moot, the events.c file no longer exists and as not an issue.

-- Steve

