Return-Path: <linux-kernel-owner+w=401wt.eu-S1762506AbXHHMdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762506AbXHHMdD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 08:33:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbXHHMcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 08:32:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38537 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998AbXHHMcw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 08:32:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [ibm-acpi-devel] suspend/hibernation regression between 2.6.19 and 2.6.20 w/ Thinkpad T41
Date: Wed, 8 Aug 2007 14:42:12 +0200
User-Agent: KMail/1.9.5
Cc: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>,
       ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
References: <200708051902.18801.toralf.foerster@gmx.de> <200708081122.55036.toralf.foerster@gmx.de> <20070808120416.GA554@khazad-dum.debian.net>
In-Reply-To: <20070808120416.GA554@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708081442.12641.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 8 August 2007 14:04, Henrique de Moraes Holschuh wrote:
> On Wed, 08 Aug 2007, Toralf Förster wrote:
> > Am Dienstag, 7. August 2007 17:38 schrieb Rafael J. Wysocki:
> > > Actually, you don't need the patch above, just do
> > > "echo shutdown > /sys/power/disk" before the hibernation (or use
> > > BTW, can you please try this patch before you do that:
> > > http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.23-rc2/patches/19-ACPI-Enable-GPEs-before-_WAK-is-called.patch
> > 
> > This patch applied at commit cfee47f doesn't solve the regression.
> > 
> > > 
> > > So place "echo shutdown > /sys/power/disk" before that into your script.
> > yep, that works for me.
> 
> FYI, some other thinkpad models break badly if you use shutdown instead of
> platform.  Sound goes away on wake, etc.
> 
> I am still very suspicious that the way we do wake-from-suspend-to-disk is
> to blame... 

Yes, that's one possible reason.

We also don't enter S4 in the right way, AFAICS, but the infrastructure
allowing us to change that is only in -mm.  Anyway, here's the patch to fix
that (it's on top of some other patches, but the link to them is given in the
message): http://lkml.org/lkml/2007/8/7/316

> I wish we loaded the kernel just once, maybe from the boot loader.

Well, that's not so easy.  That will work for the bare image, but if we want it
to be compressed and/or encrypted, then the boot loader will need to
contain all of the necessary code.

I may be doable by using a special boot kernel with ACPI disabled and only
as many drivers as required to load the image, but that will make it more
difficult to set up and to recover from errors.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
