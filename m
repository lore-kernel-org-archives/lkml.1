Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbYDSBLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbYDSBLd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 21:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751135AbYDSBLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 21:11:24 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:46015 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbYDSBLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 21:11:23 -0400
Date: Fri, 18 Apr 2008 18:11:22 -0700 (PDT)
From: dean gaudet <dean@arctic.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Joe Perches <joe@perches.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Alternative implementation of the generic __ffs
In-Reply-To: <1208567093.10414.20.camel@brick>
Message-ID: <alpine.DEB.1.10.0804181810500.6108@twinlark.arctic.org>
References: <20080331171506.GA24017@mailshack.com>  <20080401084710.GB4787@elte.hu> <20080401094618.GA24862@mailshack.com>  <alpine.DEB.1.10.0804060958580.7751@twinlark.arctic.org>  <1207507897.18129.1246358115@webmail.messagingengine.com> 
 <alpine.DEB.1.10.0804061320470.7751@twinlark.arctic.org>  <1207563950.7880.1246457209@webmail.messagingengine.com>  <20080418201809.GA5036@mailshack.com>  <alpine.DEB.1.10.0804181642150.6108@twinlark.arctic.org>  <1208563762.10414.19.camel@brick> 
 <alpine.DEB.1.10.0804181719390.6108@twinlark.arctic.org>  <1208566724.4891.25.camel@localhost> <1208567093.10414.20.camel@brick>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008, Harvey Harrison wrote:

> On Fri, 2008-04-18 at 17:58 -0700, Joe Perches wrote:
> > On Fri, 2008-04-18 at 17:20 -0700, dean gaudet wrote:
> > > any reasonable compiler should figure out the two are the same... but i 
> > > really prefer spelling out the lack of dependencies of the computations by 
> > > breaking it out per-bit.
> > 
> > It seems gcc 4.3 (-Os or -O2) isn't a reasonable compiler.
> > 
> > I think this might be best:
> > 
> > int ffs32(unsigned int value)
> > {
> > 	int x;
> > 
> > 	value &= -value;
> > 	if (!(value & 0x55555555))
> > 		x = 1;
> > 	else
> > 		x = 0;
> > 	if (!(value & 0x33333333))
> > 		x |= 2;
> > 	if (!(value & 0x0f0f0f0f))
> > 		x |= 4;
> > 	if (!(value & 0x00ff00ff))
> > 		x |= 8;
> > 	if (!(value & 0x0000ffff))
> > 		x |= 16;
> > 
> > 	return x;
> > }
> > 
> 
> That produces the shortest assembly for me, also uses the fewest
> registers.

unfortunately it kind of defeats the purpose of the original code... which 
is high parallelism / no-dependencies.

have you benchmarked it?

-dean

