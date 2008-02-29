Return-Path: <linux-kernel-owner+w=401wt.eu-S934061AbYB2Wvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934061AbYB2Wvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 17:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760259AbYB2Wvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 17:51:36 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:47083 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbYB2Wvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 17:51:35 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Fix the bcm43xx driver breakage in 2.6.24/25.
Date: Fri, 29 Feb 2008 23:49:30 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Zaytsev <alexey.zaytsev@gmail.com>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Stefano Brivio <stefano.brivio@polimi.it>,
       Jeff Garzik <jgarzik@pobox.com>, Greg KH <greg@kroah.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
References: <47C01D03.9030601@gmail.com> <200802291105.35713.mb@bu3sch.de> <20080229205400.GG27212@elte.hu>
In-Reply-To: <20080229205400.GG27212@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802292349.31415.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 February 2008 21:54:00 Ingo Molnar wrote:
> 
> * Michael Buesch <mb@bu3sch.de> wrote:
> 
> > On Friday 29 February 2008 09:21:19 Andrew Morton wrote:
> > > On Sat, 23 Feb 2008 16:17:55 +0300 Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:
> > > 
> > > > Theese two patches fix a problem instroduced in Linux 2.6.24, and
> > > > still present in the current Linus' 2.6.25 tree.
> > > > 
> > > > The bcm43xx Wifi driver won't work any more, if the b44 Ethernet
> > > > driver is enabled. This happens because the b44 driver
> > > > needlessly enables the b43_pci_bridge code, which claims
> > > > the same pci ids as the bcm43xx driver. The b43_pci_bridge
> > > > code is needed for the b43{legacy} drivers, but for the
> > > > b44, only the "ssb pci core" is needed.
> > > 
> > > Hate to stick my head into this beehive, but...
> > > 
> > > I have a patch queued (the-scheduled-bcm43xx-removal.patch) which 
> > > will remove this driver from 2.6.26.
> > > 
> > > Is that bad?
> > 
> > Not at all. The b43 driver from 2.6.26 will work. So there's no reason 
> > to keep bcm43xx. Alexey just tested a patch that backports the fix to 
> > 2.6.24 and it works fine.
> 
> yeah, i'd support the removal of it too, if the transition is smooth and 
> the regressions are resolved. And it should be smooth, as long as users 
> are able to load the firmware blob, right? There's also an entry for it 

As far as I can see, yes. The b43 driver is pretty mature these days.
It does base on the codebase of the bcm43xx driver and the most intrusive
changes date back over a year ago. The driver got lots of testing in the
meantime.
I do own the most common device flavours (except the 4311. So if somebody
has one do donate.. :) ) and I don't see any regressions.

Most "regressions" come from people not installing the updated firmware.
But that's an issue we simply cannot solve in the driver.

Of course, as I always said, if some last-minute regression appears, we
will defer the bcm43xx removal. So I hope I'm not _really_ the worst
maintainer ever, although I try hard to, when it comes to patches I
really dislike. ;)

-- 
Greetings Michael.
