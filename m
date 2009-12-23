Return-Path: <linux-kernel-owner+w=401wt.eu-S1755116AbZLWMCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbZLWMCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 07:02:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755060AbZLWMCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 07:02:30 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54839 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069AbZLWMC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 07:02:28 -0500
Date: Wed, 23 Dec 2009 07:02:24 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] Fix tracing infrastructure to support multiple
	includes when defining CREATE_TRACE_POINTS
Message-ID: <20091223120224.GA6520@hmsreliant.think-freely.org>
References: <20091207201829.GG8073@hmsreliant.think-freely.org> <1260218831.3518.3.camel@gandalf.stny.rr.com> <1260218966.3518.4.camel@gandalf.stny.rr.com> <20091207205341.GH8073@hmsreliant.think-freely.org> <20091214195058.GB31323@hmsreliant.think-freely.org> <20091215160852.GA18710@hmsreliant.think-freely.org> <1260936829.2146.447.camel@gandalf.stny.rr.com> <20091216114903.GA29609@hmsreliant.think-freely.org> <20091216160452.GC29609@hmsreliant.think-freely.org> <1261505039.25193.1342.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261505039.25193.1342.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam-Score: -3.5 (---)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 22, 2009 at 01:03:59PM -0500, Steven Rostedt wrote:
> On Wed, 2009-12-16 at 11:04 -0500, Neil Horman wrote:
> 
> 
> > +#if !defined(_TRACE_NAPI_H_) || defined(TRACE_HEADER_MULTI_READ)
> >  #define _TRACE_NAPI_H_
> >  
> 
> Ug, I'm still getting panics because of this. I found out that it's
> because napi->dev can be NULL.
> 
> Here's what I did to solve it:
Gahhh, you're right, We had to do the same thing in net-next's commit
f2798eb4e01b095f273f4bf40f511c9d69c0e1da.  If you queue to the backlog, the
backlog napi instance has no net device and so its null.  This is exactly the
right fix.

Thanks!
Neil

> 
