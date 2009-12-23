Return-Path: <linux-kernel-owner+w=401wt.eu-S1756657AbZLWShL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbZLWShL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 13:37:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755691AbZLWShK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 13:37:10 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46852 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538AbZLWShJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 13:37:09 -0500
Date: Wed, 23 Dec 2009 13:36:58 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] Fix tracing infrastructure to support multiple
	includes when defining CREATE_TRACE_POINTS
Message-ID: <20091223183658.GA4115@hmsreliant.think-freely.org>
References: <1260218966.3518.4.camel@gandalf.stny.rr.com> <20091207205341.GH8073@hmsreliant.think-freely.org> <20091214195058.GB31323@hmsreliant.think-freely.org> <20091215160852.GA18710@hmsreliant.think-freely.org> <1260936829.2146.447.camel@gandalf.stny.rr.com> <20091216114903.GA29609@hmsreliant.think-freely.org> <20091216160452.GC29609@hmsreliant.think-freely.org> <1261505039.25193.1342.camel@gandalf.stny.rr.com> <20091223120224.GA6520@hmsreliant.think-freely.org> <1261576713.25193.2542.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261576713.25193.2542.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam-Score: -3.6 (---)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 08:58:33AM -0500, Steven Rostedt wrote:
> On Wed, 2009-12-23 at 07:02 -0500, Neil Horman wrote:
> > On Tue, Dec 22, 2009 at 01:03:59PM -0500, Steven Rostedt wrote:
> > > On Wed, 2009-12-16 at 11:04 -0500, Neil Horman wrote:
> > > 
> > > 
> > > > +#if !defined(_TRACE_NAPI_H_) || defined(TRACE_HEADER_MULTI_READ)
> > > >  #define _TRACE_NAPI_H_
> > > >  
> > > 
> > > Ug, I'm still getting panics because of this. I found out that it's
> > > because napi->dev can be NULL.
> > > 
> > > Here's what I did to solve it:
> > Gahhh, you're right, We had to do the same thing in net-next's commit
> > f2798eb4e01b095f273f4bf40f511c9d69c0e1da.  If you queue to the backlog, the
> > backlog napi instance has no net device and so its null.  This is exactly the
> > right fix.
> 
> OK, I'll update the patch and apply it.
> 
> But this doesn't need to go into 33 correct. We can let it brew for 34?
> 
Yeah, the thing I was depending on it for got NAK'ed anyway, so its just a
straight bugfix + a cleanup of the napi_poll tracepoint.  It can definately wait
until 34.

Thanks!
Neil

> -- Steve
> 
> 
> 
