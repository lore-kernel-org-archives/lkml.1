Return-Path: <linux-kernel-owner+w=401wt.eu-S1758956AbXE1Mc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956AbXE1Mc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 08:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbXE1Mcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 08:32:50 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:56834 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbXE1Mct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 08:32:49 -0400
Date: Mon, 28 May 2007 13:10:56 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, Romano Giannetti <romanol@upcomillas.es>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Message-ID: <20070528121056.GA29143@srcf.ucam.org>
References: <1180008394.15600.26.camel@localhost> <20070527184402.GA21161@srcf.ucam.org> <20070528010506.GA24186@srcf.ucam.org> <200705281011.17338.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705281011.17338.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2007 at 10:11:15AM +0200, Rafael J. Wysocki wrote:
> On Monday, 28 May 2007 03:05, Matthew Garrett wrote:
> > This /mostly/ works - I've had my test machine cycling through a suspend 
> > cycle every 10 seconds for the past hour without any difficulties 
> > providing I unload USB first. If USB is loaded, the suspend occasionally 
> > fails with one of the devices returning -EBUSY and causing it to be 
> > aborted. I haven't looked into this in any detail yet, but it's 
> > presumably sufficiently generic code that it's potentially biting people 
> > on PPC anyway.
> 
> Most probably.
> 
> Still, please take what I said in the other thread into consideration: We've
> been using the freezer for so long that at least some drivers started to rely
> on it being used.
> 
> Even if there are no such drivers on your system, they can be used by other
> systems.

Sure, but if any of these drivers run on PPC then they're broken anyway. 
The assumption that processes will be frozen during suspend is true in 
the specific case of ACPI and some of the ARM platforms, but not true on 
PPC or APM systems. We either need to fix the drivers to stop assuming 
this or add the process freezer to the other PM systems. Right now, 
they're buggy.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
