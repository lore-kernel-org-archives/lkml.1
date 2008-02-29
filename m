Return-Path: <linux-kernel-owner+w=401wt.eu-S1761734AbYB2UzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761734AbYB2UzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 15:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbYB2Uyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 15:54:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58322 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbYB2Uyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 15:54:49 -0500
Date: Fri, 29 Feb 2008 21:54:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michael Buesch <mb@bu3sch.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Zaytsev <alexey.zaytsev@gmail.com>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Stefano Brivio <stefano.brivio@polimi.it>,
       Jeff Garzik <jgarzik@pobox.com>, Greg KH <greg@kroah.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Fix the bcm43xx driver breakage in 2.6.24/25.
Message-ID: <20080229205400.GG27212@elte.hu>
References: <47C01D03.9030601@gmail.com> <20080229002119.5314aad2.akpm@linux-foundation.org> <200802291105.35713.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802291105.35713.mb@bu3sch.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael Buesch <mb@bu3sch.de> wrote:

> On Friday 29 February 2008 09:21:19 Andrew Morton wrote:
> > On Sat, 23 Feb 2008 16:17:55 +0300 Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:
> > 
> > > Theese two patches fix a problem instroduced in Linux 2.6.24, and
> > > still present in the current Linus' 2.6.25 tree.
> > > 
> > > The bcm43xx Wifi driver won't work any more, if the b44 Ethernet
> > > driver is enabled. This happens because the b44 driver
> > > needlessly enables the b43_pci_bridge code, which claims
> > > the same pci ids as the bcm43xx driver. The b43_pci_bridge
> > > code is needed for the b43{legacy} drivers, but for the
> > > b44, only the "ssb pci core" is needed.
> > 
> > Hate to stick my head into this beehive, but...
> > 
> > I have a patch queued (the-scheduled-bcm43xx-removal.patch) which 
> > will remove this driver from 2.6.26.
> > 
> > Is that bad?
> 
> Not at all. The b43 driver from 2.6.26 will work. So there's no reason 
> to keep bcm43xx. Alexey just tested a patch that backports the fix to 
> 2.6.24 and it works fine.

yeah, i'd support the removal of it too, if the transition is smooth and 
the regressions are resolved. And it should be smooth, as long as users 
are able to load the firmware blob, right? There's also an entry for it 
in Documentation/feature-removal-schedule.txt:

  What:   bcm43xx wireless network driver
  When:   2.6.26
  Files:  drivers/net/wireless/bcm43xx
  Why:    This driver's functionality has been replaced by the
          mac80211-based b43 and b43legacy drivers.
  Who:    John W. Linville <linville@tuxdriver.com>

	Ingo
