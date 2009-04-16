Return-Path: <linux-kernel-owner+w=401wt.eu-S1753375AbZDPLJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbZDPLJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 07:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbZDPLJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 07:09:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38624 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbZDPLJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 07:09:41 -0400
Date: Thu, 16 Apr 2009 07:09:20 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Problem with CREATE_TRACE_POINTS and recursion safety
Message-ID: <20090416110920.GB10487@infradead.org>
References: <49E67D1D.8020704@goop.org> <alpine.DEB.2.00.0904152042350.4459@gandalf.stny.rr.com> <49E6847B.9000003@goop.org> <alpine.DEB.2.00.0904152201390.4459@gandalf.stny.rr.com> <20090416022305.GA22378@Krystal> <49E69CED.9050706@goop.org> <alpine.DEB.2.00.0904152302530.4459@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904152302530.4459@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 11:09:14PM -0400, Steven Rostedt wrote:
> I hate to do this because it adds some more work to the developer adding a 
> new trace point header, but we could just remove the CREATE_TRACE_POINTS 
> and do in the trace/events/*.h headers:
> 
> #ifdef CREATE_FOO_TRACE_POINTS
> #include <trace/define_trace.h>
> #endif
> 
> in all tracepoint headers. I originally had it this way with just the 
> CREATE_TRACE_POINTS, but Christoph Hellwig and Mathieu both suggested 
> putting that into define_trace.h.  It seems so much cleaner to keep it in 
> define_trace.h, but if it is causing too many headaches, it may not be 
> worth it :-/

I still don't like the magic include in every trace header.

What about

#define CREATE_FOO_TRACE_POINTS	"subsystem"

to only create them for a given subsystem?

