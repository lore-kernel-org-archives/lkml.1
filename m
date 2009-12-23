Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbZLWN6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbZLWN6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 08:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755146AbZLWN6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 08:58:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48218 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954AbZLWN6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 08:58:36 -0500
X-Authority-Analysis: v=1.0 c=1 a=NF6sa4JFLCQA:10 a=7U3hwN5JcxgA:10 a=7aRE5iHDxGlvz9Ws3JIA:9 a=7SGbiB9_mWccp9qvrGxC9u8CKokA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] Fix tracing infrastructure to support multiple
 includes when defining CREATE_TRACE_POINTS
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20091223120224.GA6520@hmsreliant.think-freely.org>
References: <20091207201829.GG8073@hmsreliant.think-freely.org>
	 <1260218831.3518.3.camel@gandalf.stny.rr.com>
	 <1260218966.3518.4.camel@gandalf.stny.rr.com>
	 <20091207205341.GH8073@hmsreliant.think-freely.org>
	 <20091214195058.GB31323@hmsreliant.think-freely.org>
	 <20091215160852.GA18710@hmsreliant.think-freely.org>
	 <1260936829.2146.447.camel@gandalf.stny.rr.com>
	 <20091216114903.GA29609@hmsreliant.think-freely.org>
	 <20091216160452.GC29609@hmsreliant.think-freely.org>
	 <1261505039.25193.1342.camel@gandalf.stny.rr.com>
	 <20091223120224.GA6520@hmsreliant.think-freely.org>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 23 Dec 2009 08:58:33 -0500
Message-ID: <1261576713.25193.2542.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-23 at 07:02 -0500, Neil Horman wrote:
> On Tue, Dec 22, 2009 at 01:03:59PM -0500, Steven Rostedt wrote:
> > On Wed, 2009-12-16 at 11:04 -0500, Neil Horman wrote:
> > 
> > 
> > > +#if !defined(_TRACE_NAPI_H_) || defined(TRACE_HEADER_MULTI_READ)
> > >  #define _TRACE_NAPI_H_
> > >  
> > 
> > Ug, I'm still getting panics because of this. I found out that it's
> > because napi->dev can be NULL.
> > 
> > Here's what I did to solve it:
> Gahhh, you're right, We had to do the same thing in net-next's commit
> f2798eb4e01b095f273f4bf40f511c9d69c0e1da.  If you queue to the backlog, the
> backlog napi instance has no net device and so its null.  This is exactly the
> right fix.

OK, I'll update the patch and apply it.

But this doesn't need to go into 33 correct. We can let it brew for 34?

-- Steve


