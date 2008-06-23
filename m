Return-Path: <linux-kernel-owner+w=401wt.eu-S1754476AbYFWGmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbYFWGmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 02:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbYFWGl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 02:41:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:38474 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbYFWGl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 02:41:58 -0400
Subject: Re: [PATCH 1/4] ide-pmac: media-bay support fixes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1214200453.8011.232.camel@pasglop>
References: <200806162124.43005.bzolnier@gmail.com>
	 <1213673979.8129.156.camel@pasglop> <1213674572.8129.159.camel@pasglop>
	 <200806171141.08865.bzolnier@gmail.com> <1214199343.8011.230.camel@pasglop>
	 <1214200453.8011.232.camel@pasglop>
Content-Type: text/plain
Date: Mon, 23 Jun 2008 16:41:52 +1000
Message-Id: <1214203312.8011.246.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Don't panic. It looks like it's something else in linux-next that's
> changing some ifdef's in the media-bay code which is causing that.
> 
> I managed to pull linux next at the merge point with your tree and
> things apply. I'll use that to test.

Ok, it doesn't work properly. It gets error trying to register
the IDE device. Booting with a CD drive in and no disk in the drive
gives the log below.

I've verified that it works without your patches. If I apply only patch
1, it doesn't build due to some wrong construct in the probe code. I've
hand fixed it, but then I hit a BUG_ON in ide_probe_port() (line 773).

mediabay boot time messages (before IDE probing) are:

mediabay0: Registered Heathrow media-bay
mediabay0: powering down
mediabay0: switching to 3
mediabay0: powering up
mediabay0: enabling (kind:3)
mediabay0: waiting reset (kind:3)
mediabay0: waiting IDE reset (kind:3)
mediabay0: waiting IDE ready (kind:3)
mediabay0: up before IDE init
mediabay1: Registered Heathrow media-bay
mediabay1: powering down
mediabay1: switching to 0
mediabay1: powering up
mediabay1: enabling (kind:0)
mediabay1: waiting reset (kind:0)
mediabay1: bay is up (kind:0)

Later, IDE registers:

(ide0 is another controller, only ide1 and ide2 are media bay based, and
ide2 has no device on it at all).

ide-pmac: Found Apple Heathrow ATA controller (macio), bus ID 1 (mediabay), irq  35
ide1 at 0xc7020000-0xc7020070,0xc7020160 on irq 35
ide-pmac: Found Apple Heathrow ATA controller (macio), bus ID 4 (mediabay), irq  67
ide2 at 0xc7022000-0xc7022070,0xc7022160 on irq 67
mediabay0: waiting IDE ready (kind:3)
mediabay 0, registering IDE...
IDE register error
mediabay0: powering down

 .../...

mediabay0: end of power down
mediabay0: switching to 3
mediabay0: powering up
mediabay0: enabling (kind:3)
mediabay0: waiting reset (kind:3)
mediabay0: waiting IDE reset (kind:3)

 .../...

mediabay0: waiting IDE ready (kind:3)
mediabay 0, registering IDE...
IDE register error
mediabay0: powering down
mediabay0: end of power down
mediabay0: switching to 3
mediabay0: powering up
mediabay0: enabling (kind:3)
mediabay0: waiting reset (kind:3)
mediabay0: waiting IDE reset (kind:3)
mediabay0: waiting IDE ready (kind:3)
mediabay 0, registering IDE...
IDE register error
mediabay0: powering down
mediabay0: end of power down
mediabay0: switching to 3
mediabay0: powering up
mediabay0: enabling (kind:3)
mediabay0: waiting reset (kind:3)
mediabay0: waiting IDE reset (kind:3)
mediabay0: waiting IDE ready (kind:3)
mediabay 0, registering IDE...
IDE register error
mediabay0: powering down
media-bay 0, IDE device badly inserted or unrecognised
mediabay0: end of power down

Cheers,
Ben.



