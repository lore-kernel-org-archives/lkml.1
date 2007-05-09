Return-Path: <linux-kernel-owner+w=401wt.eu-S1756587AbXEIJbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbXEIJbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 05:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754483AbXEIJba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 05:31:30 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:32942 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809AbXEIJb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 05:31:29 -0400
Message-ID: <464194B6.3090907@s5r6.in-berlin.de>
Date: Wed, 09 May 2007 11:30:30 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: david@lang.hm, Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Greg K-H <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Duncan Sands <duncan.sands@math.u-psud.fr>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11 (PCI_MULTITHREAD_PROBE)
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>	<20070508141149.GJ4226@stusta.de>	<alpine.LFD.0.98.0705080819350.3974@woody.linux-foundation.org>	<20070508183846.28a94797@gondolin.boeblingen.de.ibm.com>	<alpine.LFD.0.98.0705081123080.3974@woody.linux-foundation.org>	<20070508212117.0be9dfe5@gondolin.boeblingen.de.ibm.com>	<alpine.LFD.0.98.0705081227230.3882@woody.linux-foundation.org>	<alpine.LFD.0.98.0705081249540.3882@woody.linux-foundation.org>	<Pine.LNX.4.64.0705081314440.29403@asgard.lang.hm>	<20070509095812.016035ee@gondolin.boeblingen.de.ibm.com>	<Pine.LNX.4.64.0705090128180.2213@asgard.lang.hm> <20070509111515.0cb3e63a@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070509111515.0cb3e63a@gondolin.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck wrote:
> On Wed, 9 May 2007 01:33:14 -0700 (PDT),
> david@lang.hm wrote:
> 
>> 1. why should different, unrelated busses need to wait for each other? 
>> picking two, why can't you have SCSI and USB going through their timeouts 
>> at the same time?
> 
> If they don't have dependencies on each other, yes. Some busses should
> be finished before probing for others start (e.g. low-level busses).

If there are dependencies, then a driver on the lower-level bus simply
hot-inserts a bus to the higher-level bus's driver when the lower-level
probe is done.

E.g. PCI or CardBus detects insertion of a IEEE 1394 controller,
ohci1394 adds a new IEEE 1394 bus to ieee1394 core, ieee1394core
discovers e.g. storage devices on this bus and kicks off sbp2's probe,
sbp2 adds them to SCSI core, SCSI core does the inquiry and kicks off a
SCSI command set driver's probe.  Meanwhile, userspace just waits for a
certain SCSI device to appear.  (And userspace inserts drivers according
to uevents a.k.a. hotplug events if the drivers weren't statically linked.)
-- 
Stefan Richter
-=====-=-=== -=-= -=--=
http://arcgraph.de/sr/
