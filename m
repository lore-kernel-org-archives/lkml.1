Return-Path: <linux-kernel-owner+w=401wt.eu-S1752277AbZDGIVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbZDGIVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 04:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbZDGIVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 04:21:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36349 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbZDGIVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 04:21:34 -0400
Date: Tue, 7 Apr 2009 10:23:42 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Brice Goglin <Brice.Goglin@inria.fr>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Chris Worley <worleys@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Off topic: Numactl "distance" wrong
Message-ID: <20090407082342.GM17934@one.firstfloor.org>
References: <86802c440904031448yc6d499ckd9cb969ce136f477@mail.gmail.com> <87r609jtc2.fsf@basil.nowhere.org> <20090407111539.F0F5.A69D9226@jp.fujitsu.com> <49DAF003.1070605@inria.fr> <20090407070530.GJ17934@one.firstfloor.org> <alpine.DEB.2.00.0904070035570.20262@chino.kir.corp.google.com> <20090407075908.GL17934@one.firstfloor.org> <alpine.DEB.2.00.0904070058070.20262@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904070058070.20262@chino.kir.corp.google.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If so, that would violate the specification since values 0-9 are reserved.  
> But the validation method still checks and you're not arguing against it, 
> right?  
> 
> slit_valid() is intended to prevent invalid tables from being used because 

No actually it was intended to prevent tables that confuse the scheduler/VM
from being used. At least that is what I wrote it for. The only check
that is really needed is that remote != local, the rest is fluff
admittedly and could be all dropped.

> they are incorrect and, thus, can't possibly be used the describe the 
> physical topology.

As long as the scheduler/VM does roughly the right thing it's ok.

> 
> > In general this thread seems to contain much more speculation than
> > facts.
> > 
> 
> The fact, which you seem to be ignoring, is node hotplug would require 
> this table to change anyway.  It's quite possible using an _SLI method to 
> dynamically reconfigure the localities, including those that were 
> statically described by the BIOS at boot.  So while you may be satisfied 
> with the ACPI 2.0 way of thinking, machines have actually changed in the 
> last five years.

That may be all true in theory, but Linux doesn't implement node hotplug in this
way (not even on architectures like ia64 that would do it in theory) 
In general node hotplug in Linux is pretty useless because you
can only add, never remove, so people don't really use it.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
