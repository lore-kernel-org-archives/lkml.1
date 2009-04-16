Return-Path: <linux-kernel-owner+w=401wt.eu-S1756323AbZDPNnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323AbZDPNnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 09:43:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755212AbZDPNmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 09:42:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39177 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbZDPNmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 09:42:51 -0400
Date: Thu, 16 Apr 2009 09:42:48 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Christoph Hellwig <hch@infradead.org>
cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Problem with CREATE_TRACE_POINTS and recursion safety
In-Reply-To: <20090416110920.GB10487@infradead.org>
Message-ID: <alpine.DEB.2.00.0904160941520.5262@gandalf.stny.rr.com>
References: <49E67D1D.8020704@goop.org> <alpine.DEB.2.00.0904152042350.4459@gandalf.stny.rr.com> <49E6847B.9000003@goop.org> <alpine.DEB.2.00.0904152201390.4459@gandalf.stny.rr.com> <20090416022305.GA22378@Krystal> <49E69CED.9050706@goop.org>
 <alpine.DEB.2.00.0904152302530.4459@gandalf.stny.rr.com> <20090416110920.GB10487@infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 16 Apr 2009, Christoph Hellwig wrote:

> On Wed, Apr 15, 2009 at 11:09:14PM -0400, Steven Rostedt wrote:
> > I hate to do this because it adds some more work to the developer adding a 
> > new trace point header, but we could just remove the CREATE_TRACE_POINTS 
> > and do in the trace/events/*.h headers:
> > 
> > #ifdef CREATE_FOO_TRACE_POINTS
> > #include <trace/define_trace.h>
> > #endif
> > 
> > in all tracepoint headers. I originally had it this way with just the 
> > CREATE_TRACE_POINTS, but Christoph Hellwig and Mathieu both suggested 
> > putting that into define_trace.h.  It seems so much cleaner to keep it in 
> > define_trace.h, but if it is causing too many headaches, it may not be 
> > worth it :-/
> 
> I still don't like the magic include in every trace header.
> 
> What about
> 
> #define CREATE_FOO_TRACE_POINTS	"subsystem"
> 
> to only create them for a given subsystem?

I tried this. But it seems that there's no way to compare strings with the 
preprocessor. You can compare numbers, but having each subsystem define 
its own number would be a pain to manage.

-- Steve

