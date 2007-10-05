Return-Path: <linux-kernel-owner+w=401wt.eu-S1763408AbXJEQ10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763408AbXJEQ10 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 12:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759673AbXJEQ06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 12:26:58 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:59980
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757929AbXJEQ05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 12:26:57 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "Miguel Ojeda" <maxextreme@gmail.com>
Subject: Re: [RFC][PATCH] New message-logging API (kprint)
Date: Fri, 5 Oct 2007 11:26:50 -0500
User-Agent: KMail/1.9.6
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Vegard Nossum" <vegard.nossum@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Kyle Moffett" <mrmacman_g4@mac.com>,
       "Michael Holzheu" <holzheu@linux.vnet.ibm.com>,
       "Joe Perches" <joe@perches.com>,
       "Dick Streefland" <dick.streefland@altium.nl>,
       "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>,
       "Jesse Barnes" <jesse.barnes@intel.com>,
       "Arnd Bergmann" <arnd@arndb.de>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Emil Medve" <Emilian.Medve@freescale.com>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       "linux@horizon.com" <linux@horizon.com>
References: <1191528247.13580.11.camel@grianne> <200710042059.25721.rob@landley.net> <653402b90710050001k29ed8e3by1ccc4a0ede818b9f@mail.gmail.com>
In-Reply-To: <653402b90710050001k29ed8e3by1ccc4a0ede818b9f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710051126.50816.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 October 2007 2:01:08 am Miguel Ojeda wrote:
> > Last I checked, the current prink() worked just fine.  Why is this _not_
> > the dreaded "infrastructure in search of a use"?  What exactly can we
> > _not_ do with the current code?  What does this allow us to remove and
> > simplify?
> >
> > I'm confused about what people are trying to accomplish here...
>
> I think we all are trying to give ideas to improve the current logging API.
>
> If something works, it's great; but it doesn't mean that it can't be
> improved, right?

I'm all for improving the kernel, but my definition of "improved" does not 
include every possible change.  I balance "smaller and simpler" with "more 
features".  Complexity is a cost, we should get something in return.

Making the same functionality simpler makes it "cheaper" from a development 
standpoint.  Smaller and simpler means less overhead, less to understand, 
less to go wrong.  It's also attractive to me personally, because I am a Bear 
of Very Little Brain and between the dozen or so projects I try to follow, I 
have trouble fitting all the details in my head when they're tricky or they 
change ever time I look at them.  (Especially when I get distracted from one 
of those projects for 3-6 months and come back to find it changed.)

I recognize constantly having to learn new things as part of the cost of 
living, and making things more complicated happens as you add features.  But 
when somebody reinvents the wheel it's really nice to have clearly spelled 
out the advantages of the new wheel vs the old one.  It's nice for there to 
_be_ clear advantages, offsetting the increased complexity cost.

In this case, upon asking, the only potential advantage here seems to be "now 
we can translate dmesg output into Chinese more easily", which is something 
you could already do in userspace already via regular expressions in a 
translating dmesg, and which has the primary effect of making the resulting 
dmesg useless to report to lkml without really improving the amount of sense 
it makes to nontechnical end users (who really aren't the target of the 
english dmesg output, either).  The "linux developer who can't read english" 
niche is inherently somewhat problematic, as has been discussed here before.

The cost of this patch is making the kernel bigger, the in-kernel printk api 
more complicated, and the userspace dmesg noticeably more complex just to 
implement the same functionality against the new API.  Documenting the 
changes is nice, but doesn't reduce this increase in complexity.

The original idea (selectively compile out printk() instances based on log 
level to conserve space) is explicitly not addressed by this patch, and in 
fact this patch might actually make it harder to implement (by complicating 
the code).

*shrug*  That doesn't mean my objections are important to anyone else, just 
that I don't personally see any reason to be enthusiastic about this patch.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
