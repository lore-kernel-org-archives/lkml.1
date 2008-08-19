Return-Path: <linux-kernel-owner+w=401wt.eu-S1753232AbYHSB5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbYHSB5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 21:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbYHSB5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 21:57:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:60423 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546AbYHSB5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 21:57:21 -0400
Subject: Re: ftrace introduces instability into kernel 2.6.27(-rc2,-rc3)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Steven Rostedt <srostedt@redhat.com>
Cc: Eran Liberty <liberty@extricom.com>, linuxppc-dev@ozlabs.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org
In-Reply-To: <48A9901B.1080900@redhat.com>
References: <48591941.4070408@extricom.com> <48A92E15.2080709@extricom.com>
	 <48A9901B.1080900@redhat.com>
Content-Type: text/plain
Date: Tue, 19 Aug 2008 11:51:32 +1000
Message-Id: <1219110692.8062.0.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-18 at 11:07 -0400, Steven Rostedt wrote:
> Eran Liberty wrote:
> > After compiling a kernel with ftrace I started to experience all sorts 
> > of crashes.
> 
> Just to make sure...
> 
> ftrace enables markers too, and RCU has tracing with the markers. This 
> may not be the problem, but I just want to eliminate as many variables 
> as possible.
> Could you disable ftrace, but keep the markers on too.  Also, could you 
> enable ftrace again and turn on the FTRACE_STARTUP_TEST.

I spent some time last week tracking one of those crashes and it appears
that we are getting corruption of some of the non-volatile registers.

So far, I found out that it -seems- to be coming from stack frame
corruption during a timer interrupt.

I haven't had a chance to dig further yet.

Cheers,
Ben.


