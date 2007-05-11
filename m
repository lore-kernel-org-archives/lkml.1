Return-Path: <linux-kernel-owner+w=401wt.eu-S1763140AbXEKBZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763140AbXEKBZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 21:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759410AbXEKBZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 21:25:34 -0400
Received: from koto.vergenet.net ([210.128.90.7]:45297 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759332AbXEKBZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 21:25:33 -0400
Date: Fri, 11 May 2007 10:25:31 +0900
From: Simon Horman <horms@verge.net.au>
To: Timur Tabi <timur@freescale.com>
Cc: Kim Phillips <kim.phillips@freescale.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org,
       Ismail =?iso-8859-1?Q?D=F6nmez?= <ismail@pardus.org.tr>,
       Kumar Gala <galak@kernel.crashing.org>,
       Michael Schmitz <schmitz@debian.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: Kconfig warnings on latest GIT
Message-ID: <20070511012529.GC10715@verge.net.au>
References: <200705080004.14570.ismail@pardus.org.tr> <20070508143127.38fafa3c.kim.phillips@freescale.com> <4640D988.1040504@freescale.com> <20070510051042.GA16812@verge.net.au> <46434ED0.6030808@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46434ED0.6030808@freescale.com>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 11:56:48AM -0500, Timur Tabi wrote:
> Simon Horman wrote:
> 
> >>So my question is: in which Kconfig do I define "UCC_FAST_TEMP" and 
> >>"UCC_SLOW_TEMP"?  At first I thought, just put it in drivers/Kconfig, but 
> >>that Kconfig does nothing but including other Kconfigs.  I believe that if I 
> >>submit a patch that adds "UCC_FAST_TEMP" and "UCC_SLOW_TEMP" to 
> >>drivers/Kconfig, it will be rejected.  Either that, or I'll spend six weeks 
> >>trying to persuade everyone that it's a good idea.
> >>
> >>Does anyone have any suggestions on how I can fix this?
> >That does seem like a reasonable suggestion, and one that
> >would probably work well with the other similar problems
> >that have been introduced sice 2.6.21.
> 
> Looks like the fix is simpler than I thought.  Instead of having
> 
> UCC_GETH
> 	select UCC_FAST
> 
> I need to do
> 
> UCC_FAST
> 	default y if UCC_GETH

I pondered something like that, but I couldn't get it quite right :(

> I'll have a patch that fixes this out later today.
> 
> I chose the first method because I wanted each individual UCC device
> driver to select UCC_FAST or UCC_SLOW as appropriate, so that I
> wouldn't have to update arch/powerpc/sysdev/qe_lib/Kconfig every time
> we add a new UCC driver.  Oh well.

-- 
Horms
  H: http://www.vergenet.net/~horms/
  W: http://www.valinux.co.jp/en/

