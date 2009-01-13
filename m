Return-Path: <linux-kernel-owner+w=401wt.eu-S1759625AbZAMXzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759625AbZAMXzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:55:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754980AbZAMXzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:55:32 -0500
Received: from broadrack.ru ([195.178.208.66]:35193 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754234AbZAMXzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:55:31 -0500
Date: Wed, 14 Jan 2009 02:55:29 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: David Rientjes <rientjes@google.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
Message-ID: <20090113235529.GB32190@ioremap.net>
References: <20090113085244.GA13796@ioremap.net> <alpine.DEB.2.00.0901130134090.25386@chino.kir.corp.google.com> <20090113115408.GA22289@ioremap.net> <20090113121510.68a55fe9@lxorguk.ukuu.org.uk> <20090113122904.GC25011@ioremap.net> <alpine.DEB.2.00.0901131116220.8522@chino.kir.corp.google.com> <20090113214627.GC27227@ioremap.net> <alpine.DEB.2.00.0901131459001.22290@chino.kir.corp.google.com> <20090113233502.GA31490@ioremap.net> <alpine.DEB.2.00.0901131539050.30953@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0901131539050.30953@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 03:43:56PM -0800, David Rientjes (rientjes@google.com) wrote:
> > Which does not work. Even besides documenation issue, which really means
> > that no one really tried to work with it :)
> 
> Please.  A lack of thorough documentation, while it should be fixed, does 
> not imply that a feature is not being used.

Out of curiousity, how feature can be used, if no one except hardcore
kernel hackers know how to work with it? I do not insult, no, I'm really
curious. This may explain, why admins I worked with about this issue did
not fully succeeded with tuning.

> > It is exactly the purpose of the patch: to kill what is requested to be
> > killed.
> > 
> 
> There are global system-wide oom conditions, cpuset-constrained oom 
> conditions, memory controller oom conditions, and mempolicy oom 
> conditions.  You're patch affects them all, yet it is quite possible that 
> killing oom_victim_name will not alleviate the oom condition in a disjoint 
> cpuset.  It would have been needlessly killed because you make no 
> distinction on the constraint of the oom.

Still it is possible to start a fork-bomb and kill the machine in some
cases, but we allow this. And also allow to limit amount of the
processes started by the user.

This is the same: we have several ways to solve oom-killer problem. Some
of them work in some cases, some in other. Proposed patch is another way
to deal with the problem. And in some cases it may be wrong. But if user
specified that behaviour, he knows what he is doing. Especially when
there is no way to properly implement the solution using existing
methods.

> > I wonder how do you expect users to guess via libastral that even
> > adjusted score does not work, since it happens that task is so special,
> > that it can not be killed :)
> > 
> > My knowledge about cpusets is somewhat between zero and void, even more
> > I opened mm/kill.c the first time when created a patch (oom-killer is
> > not that interesting actually, but it is a matter of taste of course).
> > 
> 
> Being ignorant about cpusets doesn't justify you breaking their oom 
> handling.

I did not break cpuset oom-handling, I provided a way to implement it
differently to solve the problem. Yes, this may have side effects, if
people care, they will not use the feature and leave victim name as NULL
(although allowing Kenny to live breaks the absolute fundamentals).
Those people who do need this functionality will work with it.

-- 
	Evgeniy Polyakov
