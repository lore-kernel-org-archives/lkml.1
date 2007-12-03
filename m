Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784AbXLCQ27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbXLCQ27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 11:28:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750914AbXLCQ2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 11:28:52 -0500
Received: from web36609.mail.mud.yahoo.com ([209.191.85.26]:45411 "HELO
	web36609.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750866AbXLCQ2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 11:28:51 -0500
X-YMail-OSG: ttuZM3EVM1lH6GG24QZCVbwLiD5b9_ZEhKPYlUbk46QjeRg8kT3vNzYBqIODldtr1s03HxVHxQ--
X-RocketYMMF: rancidfat
Date: Mon, 3 Dec 2007 08:28:50 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: Kernel Development & Objective-C
To: Gilboa Davara <gilboad@gmail.com>,
       LKML Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Avi Kivity <avi@argo.co.il>
In-Reply-To: <1196685331.3969.20.camel@gilboa-work-dev.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <989744.46837.qm@web36609.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Gilboa Davara <gilboad@gmail.com> wrote:

> 
> On Mon, 2007-12-03 at 07:12 +0200, Avi Kivity wrote:
> > Andi Kleen wrote:
> > > Avi Kivity <avi@argo.co.il> writes:
> > >   
> > >> [I really doubt there are that many of these; syscall
> > >> entry/dispatch/exit, interrupt dispatch, context switch, what else?]
> > >>     
> > >
> > > Networking, block IO, page fault, ... But only the fast paths in these 
> > > cases. A lot of the kernel is slow path code and could probably
> > > be written even in an interpreted language without much trouble.
> > >
> > >   
> > 
> > Even these (with the exception of the page fault path) are hardly "we 
> > care about a single instruction" material suggested above.  Even with a 
> > million packets per second per core (does such a setup actually exist?)  
> > You have a few thousand cycles per packet.  For block you'd need around 
> > 5,000 disks per core to reach such rate
> 
> Intel's newest dual 10GbE NIC can easily (?) throw ~14M packets per
> second. (theoretical peak at 1514bytes/frame)
> Granted, installing such a device on a single CPU/single core machine is
> absurd - but even on an 8 core machine (2 x Xeon 53xx/54xx / AMD
> Barcelona) it can still generate ~1M packets/s per core.
> 
> Now assuming you're doing low-level (passive) filtering of some sort
> (frame/packet routing, traffic interception and/or packet analysis)
> using hardware assistance (TSO, complete TCP offloading, etc) is off the
> table and each and every cycle within netif_receive_skb (and friends)
> -counts-.
> 
> I don't suggest that the kernel should be (re)designed for such (niche)
> applications but on other hand, if it works...

I was involved in a 10GBe project like you're describing not too
long ago. Only the driver, and only a tight, lean, special purpose
driver at that, was able to deal with line rate volumes. This was
in a real appliance, where faster CPUs were not an option. In fact,
not hardware changes were possible due to the issues with squeezing
in the 10GBe nics. This project would have been impossible without
the speed and deterministic behavior of th ekernel C environment.


Casey Schaufler
casey@schaufler-ca.com
