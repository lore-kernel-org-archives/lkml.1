Return-Path: <linux-kernel-owner+w=401wt.eu-S1760171AbZAMXoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760171AbZAMXoa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:44:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755818AbZAMXoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:44:16 -0500
Received: from smtp-out.google.com ([216.239.45.13]:2096 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbZAMXoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:44:15 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-gmailtapped-by:x-gmailtapped;
	b=AhKKVocrRkq5LqO4mOAkku/P/PVjCU6Jp2ZpnyfR/OD27TIC5QUDmVtbKqM5igNK7
	YBELaDV7K9n9Zb1udU28Q==
Date: Tue, 13 Jan 2009 15:43:56 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Evgeniy Polyakov <zbr@ioremap.net>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
In-Reply-To: <20090113233502.GA31490@ioremap.net>
Message-ID: <alpine.DEB.2.00.0901131539050.30953@chino.kir.corp.google.com>
References: <20090112231728.GA23803@ioremap.net> <alpine.DEB.2.00.0901121746220.20329@chino.kir.corp.google.com> <20090113085244.GA13796@ioremap.net> <alpine.DEB.2.00.0901130134090.25386@chino.kir.corp.google.com> <20090113115408.GA22289@ioremap.net>
 <20090113121510.68a55fe9@lxorguk.ukuu.org.uk> <20090113122904.GC25011@ioremap.net> <alpine.DEB.2.00.0901131116220.8522@chino.kir.corp.google.com> <20090113214627.GC27227@ioremap.net> <alpine.DEB.2.00.0901131459001.22290@chino.kir.corp.google.com>
 <20090113233502.GA31490@ioremap.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-GMailtapped-By: 172.28.16.147
X-GMailtapped: rientjes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009, Evgeniy Polyakov wrote:

> Which does not work. Even besides documenation issue, which really means
> that no one really tried to work with it :)
> 

Please.  A lack of thorough documentation, while it should be fixed, does 
not imply that a feature is not being used.

> > Again, your patch _completely_ breaks cpuset oom killing.  That is a 
> > completely separate issue than the memory controller, and it's 
> > disappointing you still don't see it.
> > 
> > In a cpuset constrained oom condition, we do not explicitly exclude all 
> > tasks that are in a disjoint, exclusive cpuset since it's quite possible 
> > that a task has allocated memory outside its cpuset (either because its 
> > cpuset assignment has changed or because its cpuset's mems has changed) 
> > and killing it would free memory in current's cpuset.  We do, however, 
> > prefer to kill a task within the same cpuset; that preference is 
> > implemented in the badness() scoring.
> > 
> > If a task exists on the system in a disjoint, exclusive cpuset that 
> > matches oom_victim_name, your patch will cause it to be killed even though 
> > badness() has penalized it for not sharing a cpuset (dividing its score by 
> > eight).  That probably needlessly killed oom_victim_name since it won't 
> > allow for future memory freeing in the oom-triggering cpuset and the 
> > original oom condition persists.
> 
> It is exactly the purpose of the patch: to kill what is requested to be
> killed.
> 

There are global system-wide oom conditions, cpuset-constrained oom 
conditions, memory controller oom conditions, and mempolicy oom 
conditions.  You're patch affects them all, yet it is quite possible that 
killing oom_victim_name will not alleviate the oom condition in a disjoint 
cpuset.  It would have been needlessly killed because you make no 
distinction on the constraint of the oom.

> I wonder how do you expect users to guess via libastral that even
> adjusted score does not work, since it happens that task is so special,
> that it can not be killed :)
> 
> My knowledge about cpusets is somewhat between zero and void, even more
> I opened mm/kill.c the first time when created a patch (oom-killer is
> not that interesting actually, but it is a matter of taste of course).
> 

Being ignorant about cpusets doesn't justify you breaking their oom 
handling.
