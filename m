Return-Path: <linux-kernel-owner+w=401wt.eu-S1754745AbZGXXbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbZGXXbI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 19:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbZGXXbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 19:31:07 -0400
Received: from mail2.shareable.org ([80.68.89.115]:55404 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbZGXXbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 19:31:06 -0400
Date: Sat, 25 Jul 2009 00:30:57 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: sen wang <wangsen.linux@gmail.com>, mingo@elte.hu,
       akpm@linux-foundation.org, kernel@kolivas.org, npiggin@suse.de,
       arjan@infradead.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: report a bug about sched_rt
Message-ID: <20090724233057.GO27755@shareable.org>
References: <454c71700907240604h4673f117j8ed58b9f2ee54798@mail.gmail.com> <1248441290.6987.52.camel@twins> <454c71700907240626w127fd890ufa91ef90cbcaaa@mail.gmail.com> <1248442415.6987.56.camel@twins> <454c71700907240644h7469e2a5sfcb57f202a2e184d@mail.gmail.com> <1248443656.6987.61.camel@twins> <454c71700907240724u76b970e5y5af0fc114cc92f83@mail.gmail.com> <1248446910.6987.111.camel@twins> <20090724154036.GG27755@shareable.org> <1248451279.6987.138.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248451279.6987.138.camel@twins>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Fri, 2009-07-24 at 16:40 +0100, Jamie Lokier wrote:
> > Peter Zijlstra wrote:
> > > If you're using the bandwidth throttle to control your RT tasks so as
> > > not to starve your SCHED_OTHER tasks, then I will call your system ill
> > > designed.
> > 
> > What mechanism should be used to avoid starving SCHED_OTHER tasks, in
> > the event there are unforeseen bugs or unpredictable calculation times
> > in an RT task?
> 
> For bugs the throttle works, like I said a well functioning system is
> not supposed to hit the throttle, obviously a bug precludes the well
> functioning qualification :-)
> 
> Unpredictable calculation times can be dealt with on the application
> design level, for example using techniques such as outlined here:
> 
>   http://feanor.sssup.it/~faggioli/papers/OSPERT-2009-dlexception.pdf
> 
> These really are things you should know about before writing an RT
> application ;-)

Certainly those things can be used, if you are really serious about RT
behaviour.  They are quite complex.

For simple things like "try to keep the buffer to my DVD writer full"
(no I don't know how much CPU that requires - it's a kind of "best
effort but try very hard!"), it would be quite useful to have
something like RT-bandwidth which grants a certain percentage of time
as an RT task, and effectively downgrades it to SCHED_OTHER when that
time is exceeded to permit some fairness with the rest of the system.

You can do that in userspace using the techniques in the PDF, and I
have looked at such techniques many years ago (2.2 days!), but the
same could be said about RT-bandwidth.  But it's much easier to just
set a kernel parameter.

-- Jamie

