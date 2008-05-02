Return-Path: <linux-kernel-owner+w=401wt.eu-S935129AbYEBNWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935129AbYEBNWd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 09:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762293AbYEBNWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 09:22:25 -0400
Received: from s15216962.onlinehome-server.info ([217.160.22.205]:59242 "EHLO
	s15216962.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759321AbYEBNWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 09:22:24 -0400
Date: Fri, 2 May 2008 15:22:07 +0200
From: Enrico Weigelt <weigelt@metux.de>
To: linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Slow DOWN, please!!!
Message-ID: <20080502132207.GC7997@nibiru.local>
Reply-To: weigelt@metux.de
References: <20080429.190352.137408408.davem@davemloft.net> <20080430183149.78d97597.akpm@linux-foundation.org> <alpine.LFD.1.10.0804301841290.5994@woody.linux-foundation.org> <200805011259.47343.rjw@sisk.pl> <alpine.LFD.1.10.0805010816340.5994@woody.linux-foundation.org> <20080501183551.GA26149@foursquare.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080501183551.GA26149@foursquare.net>
User-Agent: Mutt/1.4.1i
X-Terror: bin laden, kill bush, Briefbombe, Massenvernichtung, KZ, 
X-Nazi: Weisse Rasse, Hitlers Wiederauferstehung, 42, 
X-Antichrist: weg mit schaeuble, ausrotten, heiliger krieg, al quaida, 
X-Killer: 23, endloesung, Weltuntergang, 
X-Doof: wer das liest ist doof
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi folks,


<big_snip>

Just a few naive thoughts:

a) What about reducing code size ?

Some parts, IMHO, doen't necessarily need to be in the kernel,
eg. certain filesystems. Less code, less patches to review, less
chance of kernel bugs. Of course this might also cause other 
impacts (eg. performance), so those decisions require great care.

b) Mutli-tier trees / patchlines

IMHO, a major problem are conflicting patches (eg. a core change
causes some driver to break). In measurement instrumentation 
(eg. timesync), there's typically one primary reference point 
(eg. atomic clock) as tier-0, where (a limited set of) tier-1's 
are synchronized against, tier-2 syncs against tier-1 and so on.

So for the linux kernel, we perhaps could have something like:

* tier-0: core
* tier-1: arch
* tier-2: hw drivers
* tier-3: sw drivers
* tier-4: userland interfaces

If a change from a lower tier wants to it's upper tier, it first
MUST fit it's current mainline and carefully checked. Of course
this introduces longer times for an individual change to go to
into release (since it has to pass several tiers), but IMHO the
chance of new bugs in release should be reduced this way.

Of course there might be chances in a lower tier, which obviously 
won't affect several intermediate tiers. Those could skip some tiers.

For example, I'm currently working on an /proc interface for 
changing process privileges. In my model, this had to be settled
in #4, but shouldn't touch drivers (#2,#3), but maybe arch (#1).
So these changes could be kicked directly to #2. 


What do you think about this ?


cu
-- 
---------------------------------------------------------------------
 Enrico Weigelt    ==   metux IT service - http://www.metux.de/
---------------------------------------------------------------------
 Please visit the OpenSource QM Taskforce:
 	http://wiki.metux.de/public/OpenSource_QM_Taskforce
 Patches / Fixes for a lot dozens of packages in dozens of versions:
	http://patches.metux.de/
---------------------------------------------------------------------
