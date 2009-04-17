Return-Path: <linux-kernel-owner+w=401wt.eu-S1762107AbZDQQch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762107AbZDQQch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 12:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761874AbZDQQc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 12:32:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51821 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761771AbZDQQc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 12:32:26 -0400
Date: Fri, 17 Apr 2009 12:32:24 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: mathieu.desnoyers@polymtl.ca, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 2/4] x86/pvops: target CREATE_TRACE_POINTS to particular
 subsystems
In-Reply-To: <49E8AAC8.5080004@goop.org>
Message-ID: <alpine.DEB.2.00.0904171231270.14919@gandalf.stny.rr.com>
References: <1239950139-1119-1-git-send-email-jeremy@goop.org> <1239950139-1119-3-git-send-email-jeremy@goop.org> <alpine.DEB.2.00.0904171149100.14919@gandalf.stny.rr.com> <49E8AAC8.5080004@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 17 Apr 2009, Jeremy Fitzhardinge wrote:

> Steven Rostedt wrote:
> > Instead of doing it this way, what about not having this new header, and
> > just do:
> > 
> > 
> > #ifdef CREATE_IRQ_TRACE_POINTS
> > #define CREATE_TRACE_POINTS
> > #endif
> > #include <trace/define_trace.h>
> > 
> > Heck, define_trace.h is only defined when CREATE_TRACE_POINTS is defined,
> > why not just remove that and have:
> > 
> > #ifdef CREATE_IRQ_TRACE_POINTS
> > #define <trace/define_trace.h>
> > #endif
> > 
> > The whole trickery with the CREATE_TRACE_POINTS was to avoid the #if in the
> > trace headers anyway. If we can't avoid it. We don't need to add more
> > confusion to the mix.
> >   
> 
> OK, and remove the test for CREATE_TRACE_POINTS in define_trace.h altogether?
> Works for me.
> Uh, still needs the #undef CREATE_IRQ_TRACE_POINTS.

Ah yes! It needs to be:

#ifdef CONFIG_IRQ_TRACE_POINTS
#undef CONFIG_IRQ_TRACE_POINTS
#include <trace/define_trace.h>
#endif

Otherwise we get into the recursion again.

-- Steve

