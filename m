Return-Path: <linux-kernel-owner+w=401wt.eu-S1753610AbYLMXw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbYLMXw2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 18:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbYLMXwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 18:52:19 -0500
Received: from mailout-venus.uni-duesseldorf.de ([134.99.128.32]:54757 "EHLO
	mail.rz.uni-duesseldorf.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751372AbYLMXwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 18:52:18 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Sun, 14 Dec 2008 00:52:15 +0100 (CET)
From: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Subject: Re: [PATCH 2/3] ide: add ide_[un]lock_hwgroup() helpers
In-reply-to: <200812140015.51978.bzolnier@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Elias Oltmanns <eo@nebensachen.de>
Message-id: <alpine.DEB.1.00.0812140042360.10340@zirkon.biophys.uni-duesseldorf.de>
References: <200811182116.00351.bzolnier@gmail.com>
 <alpine.DEB.1.00.0811190236550.24738@zirkon.biophys.uni-duesseldorf.de>
 <200812140015.51978.bzolnier@gmail.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> [ Sorry for the late reply. ]

No worries - I haven't been very active either. It's home improvement season 
down under...

> > Something I've run into while working on the locking stuff: what happens if the 
> > above ide_lock_hwgroup(hwgroup) sleeps for long enough to trigger the request 
> > timer? 
> 
> AFAICS this happens before the hwgroup timeout timer is armed and IDE is not
> using block layer request timers yet so we should be fine here..

OK; I'll just let it block while SCSI requests are in flight. Thanks for 
pondering this :-)

There's another change I'll send via Geert: since in Falcon, IDE uses stdma_intr 
as interrupt handler (interrupts dispatched there to whichever driver has 
exclusive use of the ST-DMA and associated interrupt), and this handler has been 
registered prior to IDE setup it is not necessary to request the IDE interrupt 
on Falcon when probing the IDE interface. In fact, this results in the IDE 
interrupt possibly getting run while the lock is not being held by IDE. 

Other than that it all seems to work fine. 

	Michael

