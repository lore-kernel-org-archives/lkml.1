Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491Ab0AZQJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab0AZQJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 11:09:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241Ab0AZQJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 11:09:05 -0500
Received: from bar.sig21.net ([80.81.252.164]:56391 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141Ab0AZQJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 11:09:04 -0500
Date: Tue, 26 Jan 2010 17:08:11 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Renzo Davoli <renzo@cs.unibo.it>, Mark Wielaard <mjw@redhat.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kyle Moffett <kyle@moffetthome.net>, tytso@mit.edu,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
Message-ID: <20100126160811.GA3242@sig21.net>
References: <20100123114729.GA7828@redhat.com>
 <20100123194820.GM21263@thunk.org>
 <f73f7ab81001241742t1f827ddetd958e1949787020f@mail.gmail.com>
 <alpine.LFD.2.00.1001250845180.3574@localhost.localdomain>
 <20100125170254.GB22862@redhat.com>
 <alpine.LFD.2.00.1001250930320.3574@localhost.localdomain>
 <1264451453.3028.59.camel@springer.wildebeest.org>
 <alpine.LFD.2.00.1001251236160.3574@localhost.localdomain>
 <20100126000237.GA15936@cs.unibo.it>
 <alpine.LFD.2.00.1001251605320.3574@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001251605320.3574@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.6 (---)
X-Spam-21-Report: No, score=-3.6 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.758,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 04:07:21PM -0800, Linus Torvalds wrote:
> On Tue, 26 Jan 2010, Renzo Davoli wrote:
> > 
> > The solution is that everybody can code his/her optimized kernel/user 
> > interface for tracing in his/her kernel module, i.e. utrace.
> 
> I don't think people understand. That is simply not a "solution". That is 
> a PROBLEM. The thing you describe is an absolute disaster. Which is 
> exactly why I rant against it.
> 
> The last thing we want to have is "here, take this, and make your own 
> kernel module mess around it optimized for your particular crazy 
> scenario".
> 
> But every SINGLE post in this thread that has argued for utrace has argued 
> exactly this way. 

I haven't followed much of the utrace discussions, but my impression was
that utrace primarily is a cleanup effort, replacing "don't change it,
you might break it" code with a clean, well defined (and even documented)
implementation.  To make it easier for people not familiar
with the low-level architecture details to experiment with
debugging stuff.

Two points to consider:

1. If you'd merge utrace + ptrace-on-utrace, but never anything else
   which uses the utrace API, wouldn't it still be an improvement?

2. A well defined utrace API makes debugging code more hackable, thus more
   likely that someone might come up with a brilliant killer debug
   feature in the future. (This might sound lame, but there are already
   a few people doing crazy things with utrace while I'm not aware
   that people have done such experiments based on the current ptrace impl.)

BTW, the ptrace improvements discussed elsewhere in this thread
(like using an fd intead of signals/wait) are orthogonal
to utrace, no?  IMHO it's a seperate discussion.


Johannes
