Return-Path: <linux-kernel-owner+w=401wt.eu-S1753287Ab0AZXUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab0AZXUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:20:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136Ab0AZXUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:20:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55235 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab0AZXUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:20:31 -0500
X-Authority-Analysis: v=1.0 c=1 a=Yo9lNqkTXJIA:10 a=7U3hwN5JcxgA:10 a=d2fmCDMrxO5Rixl-3d8A:9 a=nKqxMcCOFy1QuuNQDKPzI_L2T7cA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 1/5] tracing: Prevent kernel oops with corrupted buffer
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20100126223900.GA5223@nowhere>
References: <20100126220923.534282809@goodmis.org>
	 <20100126221712.447066697@goodmis.org>
	 <20100126143223.e4332098.akpm@linux-foundation.org>
	 <20100126223900.GA5223@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 26 Jan 2010 18:20:28 -0500
Message-ID: <1264548028.31321.458.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-26 at 23:39 +0100, Frederic Weisbecker wrote:
> On Tue, Jan 26, 2010 at 02:32:23PM -0800, Andrew Morton wrote:
> > > +	if (WARN_ON_ONCE(pid < 0)) {
> > > +		strcpy(comm, "<XXX>");
> > > +		return;
> > > +	}
> > > +
> > >  	if (pid > PID_MAX_DEFAULT) {
> > >  		strcpy(comm, "<...>");
> > >  		return;
> > 
> > But why is it WARN_ON_ONCE()?  That will only fix the problem a single
> > time.  On the second occurrence, it will oops again.
> 
> 
> 
> The warning will be produced only once, but after that,
> the condition is still checked like a simple if:
> 
> #define WARN_ON_ONCE(condition)	({				\
> 	static bool __warned;					\
> 	int __ret_warn_once = !!(condition);			\
> 								\
> 	if (unlikely(__ret_warn_once))				\
> 		if (WARN_ON(!__warned)) 			\
> 			__warned = true;			\
> 	unlikely(__ret_warn_once);				\
> })
> 
> 
> And since this function can be called anytime we have a trace
> to print to the user, we don't want to encumber with thousands
> of warnings.

Exactly!

-- Steve


