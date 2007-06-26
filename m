Return-Path: <linux-kernel-owner+w=401wt.eu-S1754954AbXFZI1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbXFZI1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 04:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbXFZI1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 04:27:44 -0400
Received: from aun.it.uu.se ([130.238.12.36]:65052 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbXFZI1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 04:27:43 -0400
Date: Tue, 26 Jun 2007 10:04:15 +0200 (MEST)
Message-Id: <200706260804.l5Q84F2D017936@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: B.Steinbrink@gmx.de, eranian@hpl.hp.com
Subject: Re: [PATCH 1/2] Always probe the NMI watchdog
Cc: ak@suse.de, ingo@elte.hu, levon@movementarian.org,
       linux-kernel@vger.kernel.org, oprofile-list@lists.sourceforge.net,
       perfmon@napali.hpl.hp.com, wcohen@redhat.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2007 23:04:25 +0200, B.Steinbrink@gmx.de wrote:
> > I think the tricky part is that we do want to reserve perfctr1 even
> > though the NMI watchdog is not active. This comes from the fact that
> > the NMI watchdog knows about only one counter and if it can't get that
> > one, it probably fails.  By reserving it from the start, we ensure NMI
> > watchdog will work when eventually activated.
> 
> Can you enable it later on at all? It failed for me when I tried,
> because it didn't know which hardware to use. Had to pass the kernel
> parameter to make the proc files do anything. Seems like it has to be
> enable at boot to work at all.
> 
> And AFAICT we never unconditionally reserved a perfctr for the watchdog.

Yes you can dynamically enable/disable the NMI watchdog,
at least if you booted with it enabled.

> In 2.6.21 the nmi watchdog, if enabled, just reserved its perfctrs and
> everything else had to deal with it. Since the cleanup, the watchdog
> will release its perfctr when disabled, so another subsystem can grab
> it. But that also means that that other subsystem must release it again
> before you can reenable the watchdog.

Which is the obvious and correct way to handle a shared resource.

Keeping parts of the PMU HW permanently reserved whether or not
the watchdog is enabled would be a BUG.

/Mikael
