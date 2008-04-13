Return-Path: <linux-kernel-owner+w=401wt.eu-S1759327AbYDMPxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759327AbYDMPxV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 11:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754309AbYDMPxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 11:53:10 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44871 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111AbYDMPxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 11:53:09 -0400
Date: Sun, 13 Apr 2008 08:48:04 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai Lu <yinghai.lu@sun.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [rfc] hw resource debugging checks (was: Re: x86 git tree
 broken (bisected))
Message-ID: <20080413084804.2e511a3f@laptopd505.fenrus.org>
In-Reply-To: <20080413075845.GJ20332@elte.hu>
References: <200804102159.14563.rjw@sisk.pl>
	<20080410203800.GA14560@elte.hu>
	<200804110028.22290.rjw@sisk.pl>
	<200804112126.29455.rjw@sisk.pl>
	<20080413075845.GJ20332@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2008 09:58:45 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > > > btw., Xorg works fine here on a comparable AMD system - but i
> > > > use a rather new distro (Fedora 8) which has Xorg 7.2.
> > > 
> > > My system is an OpenSUSE 10.3 and it has Xorg 7.2 as well.
> > > 
> > > I think the problem is somehow related to the Radeon.
> > 
> > The bisection turned up commit 
> > ea1441bdf53692c3dc1fd2658addcf1205629661 "x86: use bus conf in NB
> > conf fun1 to get bus range on, on 64-bit" as the one causing
> > problems.
> 
> thanks Rafael for bisecting this!
> 
> This was a rather nasty problem - and i'm wondering what else we
> could do to harden our hw resource management code. I'm wondering, is
> there any particular reason why clearly broken resource setup is not
> detected somewhere, automatically, and WARN_ON()-ed about?

that would be very welcome, esp if kerneloops.org can pick them up.

One thing we also need to do as Linux is get more conservative;
(this isn't per se about this specific thing)

With MCFG for example we learned over time "if it smells funny don't use it".
That concept should be carried much further imo; for example on K8 you
can compare the acpi table to the chipset for numa support, and if they don't match,
we SHOULD ignore both entirely.
The same is true all over; Linux tends to behave as "oh but we think we can make it work anyway",
in general imo that's a mistake in the long term, at least for default configs. Because there
will be cases where that will break, be it special bioses or next gens of chipsets.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
