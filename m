Return-Path: <linux-kernel-owner+w=401wt.eu-S2993063AbXDSAh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993063AbXDSAh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 20:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993064AbXDSAh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 20:37:26 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:51936 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993063AbXDSAhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 20:37:25 -0400
X-Originating-Ip: 24.6.145.253
Date: Wed, 18 Apr 2007 20:35:22 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Dave Jones <davej@redhat.com>
cc: Len Brown <lenb@kernel.org>, davej@codemonkey.org.uk,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] Kill off legacy power management stuff.
In-Reply-To: <20070418235806.GD20204@redhat.com>
Message-ID: <Pine.LNX.4.64.0704182028320.5826@localhost.localdomain>
References: <Pine.LNX.4.64.0704122025380.3628@CPE00045a9c397f-CM001225dbafb6>
 <200704181524.16980.lenb@kernel.org> <Pine.LNX.4.64.0704181615510.18034@localhost.localdomain>
 <200704181723.16241.lenb@kernel.org> <20070418235806.GD20204@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-14.854, required 5, ALL_TRUSTED -1.80, BAYES_00 -15.00,
	INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_NJABL_DUL 1.95,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2007, Dave Jones wrote:

> On Wed, Apr 18, 2007 at 05:23:15PM -0400, Len Brown wrote:
>
>  > > p.p.s.  patch improvements that will let me avoid doing any of that
>  > > myself always welcome. :-)
>  >
>  > well, I'm sorry that I've known about the APM issue for a long time
>  > and done nothing about it.  I did ping davej when he broke it,
>  > but his to-do list is probably even longer than mine.
>
> ping timeout.
>
> I don't recall too many of the details surrounding those changes,
> but I certainly won't stand in the way of anyone trying to fix it.
> It sounds like you and Robert are on top of it, or do you want me to
> poke at it ?

well, before i get even more confused by what was (once upon a time) a
fairly straightforward removal patch, the first obvious question is --
are there *any* circumstances that *require* a config selection of
CONFIG_PM_LEGACY, as opposed to a selection of APM and/or ACPI?  if
there are, then it can't simply be removed.  my original patch
submission was based on the assumption that absolutely no one needed
the legacy stuff anymore and absolutely everything related to it could
be scrapped.

so, first things first:  what *needs* legacy PM at the moment?

rday

p.s.  i'm confused by the header file include/linux/pm_legacy.h,
especially this part:

========================
#ifdef CONFIG_PM_LEGACY
...
# else /* CONFIG_PM_LEGACY */

#define PM_IS_ACTIVE() 0
...
#endif
=======================

  so the macro "PM_IS_ACTIVE()" represents whether *legacy* PM has
been selected.  in other words, it makes no (apparent) sense that the
value of that macro would represent some kind of contention mechanism
between APM and ACPI, which is entirely independent from the legacy
stuff.  right?

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
