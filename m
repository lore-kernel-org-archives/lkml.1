Return-Path: <linux-kernel-owner+w=401wt.eu-S1757179AbXFZK6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179AbXFZK6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 06:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbXFZK6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 06:58:42 -0400
Received: from aun.it.uu.se ([130.238.12.36]:33873 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbXFZK6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 06:58:41 -0400
Date: Tue, 26 Jun 2007 12:35:01 +0200 (MEST)
Message-Id: <200706261035.l5QAZ1gb018736@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: eranian@hpl.hp.com, mikpe@it.uu.se
Subject: Re: [PATCH 1/2] Always probe the NMI watchdog
Cc: B.Steinbrink@gmx.de, ak@suse.de, ingo@elte.hu, levon@movementarian.org,
       linux-kernel@vger.kernel.org, oprofile-list@lists.sourceforge.net,
       perfmon@napali.hpl.hp.com, wcohen@redhat.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007 02:57:55 -0700, Mikael Pettersson wrote:
> > Keeping parts of the PMU HW permanently reserved whether or not
> > the watchdog is enabled would be a BUG.
> > 
> True. But the upside is that you guarantee the activation of the NMI
> watchdog will always succeed which may be a valuable property given the
> goal of the NMI watchdog. Otherwise, if Oprofile or perfmon are active,
> the NMI will fail to grab a single counter.

That relates more to policy than mechanism. I for one don't
consider the watchdog "sacred".

I think it's entirely reasonable that if the watchdog is disabled
(echo 0 > /proc/sys/kernel/nmi_watchdog) in order to give the
_full_ PMU HW to something else, then that something else needs
to be disabled (or otherwise instructed to give up the HW) before
the watchdog can be reenabled. If you don't want to risk not
being able to restart the watchdog, don't disable it.
