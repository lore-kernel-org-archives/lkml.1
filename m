Return-Path: <linux-kernel-owner+w=401wt.eu-S1759149AbZAMIw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759149AbZAMIw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 03:52:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbZAMIwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 03:52:47 -0500
Received: from netgear.net.ru ([195.178.208.66]:37905 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbZAMIwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 03:52:47 -0500
Date: Tue, 13 Jan 2009 11:52:44 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: David Rientjes <rientjes@google.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
Message-ID: <20090113085244.GA13796@ioremap.net>
References: <20090112153304.GA19995@ioremap.net> <20090112154922.6003750b@lxorguk.ukuu.org.uk> <20090112155030.GA21063@ioremap.net> <20090112155239.5f677a17@lxorguk.ukuu.org.uk> <20090112155615.GA21350@ioremap.net> <20090112161931.6203f96e@lxorguk.ukuu.org.uk> <20090112162938.GA22647@ioremap.net> <496BCB7A.2010804@tmr.com> <20090112231728.GA23803@ioremap.net> <alpine.DEB.2.00.0901121746220.20329@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0901121746220.20329@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 05:53:47PM -0800, David Rientjes (rientjes@google.com) wrote:
> On Tue, 13 Jan 2009, Evgeniy Polyakov wrote:
> 
> > Like anything that spawns a thread or process per request/client, or
> > preallocates set of them which connect to the huge object like database.
> > Most of the time database/server is killed first instead of comparably
> > small clients.
> 
> No, the reverse is true: when a task is chosen for oom kill based on the 
> badness heuristic, the oom killer first attempts to kill any child task 
> that isn't attached to the same mm.  If the child shares an mm, both tasks 
> must die before memory freeing can occur.

It is a theory, not a practice. OOM-killer most of time starts from ssh,
database and lighttpd on the tested machines, when it could start in
the reverse order and do not touch ssh at all. Better not from daemon
itself, but its fastcgi spawned processes.

> > In some cases it is possible to tune the environment, in
> > others it is not that simple. This patch works for such situatons
> > perfectly and does not require additional administrative burden, since
> > it does not make thinge worse as a whole, but only better for the very
> > commonly used cases, that's why I propose it for inclusion.
> > 
> 
> It's an inappropriate addition since /proc/pid/oom_adj scores exist which 
> can prefer or protect certain tasks over others when the oom killer 
> chooses a target, including oom kill immunity.  These scores are inherited 
> from parent tasks and can be tuned after the fork to your oom kill target 
> preference.

I agree, that there are ways to tune the way oom-killer selects the
victim, and likely after hours of games this subtly will work for the
specified workload. What I propose is the simplest way for the most
commonly used case. It is a help for the admin and not the force to
invent complex machinery which will be error-prone and hard to debug
when eventually oom happens. This will work, but it is way more complex
than what I propose, without immediately visible net effects on other
parts of the originally balanced system.

-- 
	Evgeniy Polyakov
