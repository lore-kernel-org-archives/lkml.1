Return-Path: <linux-kernel-owner+w=401wt.eu-S1763636AbXEYQY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763636AbXEYQY0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 12:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760756AbXEYQYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 12:24:19 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:47553
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbXEYQYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 12:24:18 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Uwe Bugla <uwe.bugla@gmx.de>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
Date: Fri, 25 May 2007 18:23:35 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
References: <20070524195616.234280@gmx.net> <200705251652.19911.mb@bu3sch.de> <200705251759.30065.uwe.bugla@gmx.de>
In-Reply-To: <200705251759.30065.uwe.bugla@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705251823.35584.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 May 2007 17:59:29 Uwe Bugla wrote:
> Am Freitag, 25. Mai 2007 16:52 schrieben Sie:
> > On Friday 25 May 2007 15:59:49 Uwe Bugla wrote:
> > > Well if you're so clever in software development then please provide an
> > > exception handling for the ssb module which is specifically NOT needed by
> > > my onboard controller, OK?
> > > Just provide compatibility to non-wireless NICs, i. e. to non-ssb
> > > devices.
> >
> > What are you talking about?
> 
> First of all, what is an ssb device please? AFAICS it looks like an extension 
> of b44.c as far as module selection is concerned in kernel configuration.
> 
> What it's function / purpose?
> Does its function / purpose apply to every platform?

The Sonics Silicon Backplane (ssb) is _part_ of the b44 device.
It ALWAYS has been.
In earlier drivers the ssb code was included in the b44 driver.

> >
> > > I think you cannot just bind ssb tightly to b44.c, can you?
> >
> > You have no clue about how the b44 hardware works, do you?
> 
> Should I? My broadcom 4401 is broken, but only in that specific mm1-tree.
> It's not broken in 2.6.22-rc2 for instance. So that's your patch that breaks 
> it.

I doubt that very much.
In the wireless-dev tree, which includes the _exactly_ same ssb abd b44
version as -mm, it works fine. I just verified this.
I'm almost 100% sure that your kernel is broken in a completely different
way unrelated to ssb.
In the initial mail you said that the IRQ output of lspci says that
the IRQ was 255? If lspci is really saying IRQ 255 this is _NOT_ a ssb
bug, but some bug in either the PCI subsystem or some other IRQ related
subsystem (APIC, ACPI or something else).

> > > In so far the way how ssb is attached is buggy and wrong, apart from the
> > > fact that my controller is broken, disfunctional.
> >
> > Please explain in detail how ssb is wrong.
> 
> I do not state that ssb is wrong, but I state that the ATTACHMENT of ssb to 
> b44.c is wrong. That's a big difference.
> In all earlier kernels that b44 device has been fine, and ssb has never been 
> seen.

The ssb code was included in the b44 driver module.

> > So, now I count the machines (not that this number matters AT ALL):
> > One, two, three. Oh, there we go. What a surprise...
> 
> Nice for you, but on my machine it is broken, the broadcom 4401 onboard NIC 
> controller is unusable.

And you are not even TRYING to resolve it.
What should I do, in your opinion?? It works for me. W.t.f. should I do?

> Do you mean to build a kernel without any ACPI functions?

There are kernel commandline options for this.
I think (don't remember 100%) they are noapic and noacpi


-- 
Greetings Michael.
