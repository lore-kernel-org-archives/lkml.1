Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbZFFMRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbZFFMRz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 08:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbZFFMRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 08:17:48 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:59978 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbZFFMRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 08:17:47 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
Date: Sat, 6 Jun 2009 07:17:44 -0500
User-Agent: KMail/1.9.9
Cc: Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Harald Welte <HaraldWelte@viatech.com>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <200906041227.10529.lkml@morethan.org> <alpine.LFD.2.01.0906041038130.4880@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0906041038130.4880@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906060717.46964.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu June 4 2009, Linus Torvalds wrote:
> 
> On Thu, 4 Jun 2009, Michael S. Zick wrote:
> >
> > Yes, I build test cases with and without - -
> > It was a fixed-speed kernel build that first hit the 4 hour up-time mark.
> > I just reposted that build today (the -09143lk).
> > 
> > > Features like that easily put a huge stress on power regulators etc, if 
> > > they result in sudden changes in current draw.  Underspecced capacitors 
> > > etc can cause CPU "brown-outs", which in turn can easily cause total 
> > > failure. 
> > 
> > There is also a possible thermal issue with these machines - -
> > I doubt that VIA runs their qualification testing in bake ovens;
> > which is what NetBook cases amount too.  ;)
> 
> If the fixed-speed case runs for longer, it's not likely to be a thermal 
> issue. The fixed speed case should be the higher-power one.
> 

I can respond to that point now; VIA Tech has answered some of my questions -

The mainstream kernel, e_powersaver, is *under-clocking* my machine -

The cpuid instruction provides the minimum and maximum GSF values 
(Guaranteed Stable Frequency) for that processor mask run -
Passing that on as the lower and upper limits to e_powersaver should
stop that problem.  Will be testing this RSN.

Once you start operating the processor outside of the reported-by-silicon mask
limits - quote: "there is no quarantee of stable operation" - -

To that I add my opinion:
For a severely under-clocked machine (already possibly un-stable) - -
Thermal effects are almost certain to be present.
 
To paraphrase VIA Tech once again: "Don't do that."  ;)

Mike
