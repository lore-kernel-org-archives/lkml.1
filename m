Return-Path: <linux-kernel-owner+w=401wt.eu-S937873AbXHHUPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937873AbXHHUPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 16:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934457AbXHHUPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 16:15:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40583 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765702AbXHHUPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 16:15:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [ibm-acpi-devel] suspend/hibernation regression between 2.6.19 and 2.6.20 w/ Thinkpad T41
Date: Wed, 8 Aug 2007 22:24:38 +0200
User-Agent: KMail/1.9.5
Cc: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>,
       ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
References: <200708051902.18801.toralf.foerster@gmx.de> <200708081442.12641.rjw@sisk.pl> <20070808144854.GB9587@khazad-dum.debian.net>
In-Reply-To: <20070808144854.GB9587@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708082224.39337.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 8 August 2007 16:48, Henrique de Moraes Holschuh wrote:
> On Wed, 08 Aug 2007, Rafael J. Wysocki wrote:
> > > I wish we loaded the kernel just once, maybe from the boot loader.
> > 
> > Well, that's not so easy.  That will work for the bare image, but if we want it
> > to be compressed and/or encrypted, then the boot loader will need to
> > contain all of the necessary code.
> 
> Doing things right always have an associated cost, or we'd be doing it right
> since day one...
> 
> > I may be doable by using a special boot kernel with ACPI disabled and only
> > as many drivers as required to load the image, but that will make it more
> > difficult to set up and to recover from errors.
> 
> Better than the walking bomb we have now.  When waking from suspend-to-disk,
> we should not overwrite ANY non-kernel data which has ties to external
> systems (the hardware, the firmware).  Instead, we should re-init everything
> (re-init hardware to make sure we know in which state it is, re-init
> ourselves, to make sure we match the firmware and hardware state), as if we
> were booting a cold system in the first place.

Yes, we've already had an agreement about that on linux-pm, now the problem is
to implement it and not to break things in the process ...


-- 
"Premature optimization is the root of all evil." - Donald Knuth
