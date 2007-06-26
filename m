Return-Path: <linux-kernel-owner+w=401wt.eu-S1754191AbXFZJ6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbXFZJ6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 05:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbXFZJ6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 05:58:11 -0400
Received: from ccerelbas03.cce.hp.com ([161.114.21.106]:50670 "EHLO
	ccerelbas03.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbXFZJ6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 05:58:10 -0400
Date: Tue, 26 Jun 2007 02:57:55 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: B.Steinbrink@gmx.de, ak@suse.de, ingo@elte.hu, levon@movementarian.org,
       linux-kernel@vger.kernel.org, oprofile-list@lists.sourceforge.net,
       perfmon@napali.hpl.hp.com, wcohen@redhat.com
Subject: Re: [PATCH 1/2] Always probe the NMI watchdog
Message-ID: <20070626095755.GA13085@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <200706260804.l5Q84F2D017936@harpo.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706260804.l5Q84F2D017936@harpo.it.uu.se>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael,

On Tue, Jun 26, 2007 at 10:04:15AM +0200, Mikael Pettersson wrote:
> On Mon, 25 Jun 2007 23:04:25 +0200, B.Steinbrink@gmx.de wrote:
> > > I think the tricky part is that we do want to reserve perfctr1 even
> > > though the NMI watchdog is not active. This comes from the fact that
> > > the NMI watchdog knows about only one counter and if it can't get that
> > > one, it probably fails.  By reserving it from the start, we ensure NMI
> > > watchdog will work when eventually activated.
> > 
> > Can you enable it later on at all? It failed for me when I tried,
> > because it didn't know which hardware to use. Had to pass the kernel
> > parameter to make the proc files do anything. Seems like it has to be
> > enable at boot to work at all.
> > 
> > And AFAICT we never unconditionally reserved a perfctr for the watchdog.
> 
> Yes you can dynamically enable/disable the NMI watchdog,
> at least if you booted with it enabled.
> 
> > In 2.6.21 the nmi watchdog, if enabled, just reserved its perfctrs and
> > everything else had to deal with it. Since the cleanup, the watchdog
> > will release its perfctr when disabled, so another subsystem can grab
> > it. But that also means that that other subsystem must release it again
> > before you can reenable the watchdog.
> 
> Which is the obvious and correct way to handle a shared resource.
> 
Agreed.

> Keeping parts of the PMU HW permanently reserved whether or not
> the watchdog is enabled would be a BUG.
> 
True. But the upside is that you guarantee the activation of the NMI
watchdog will always succeed which may be a valuable property given the
goal of the NMI watchdog. Otherwise, if Oprofile or perfmon are active,
the NMI will fail to grab a single counter.

-- 

-Stephane
