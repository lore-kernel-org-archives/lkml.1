Return-Path: <linux-kernel-owner+w=401wt.eu-S1756385AbXEIJPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385AbXEIJPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 05:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754504AbXEIJPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 05:15:34 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:20914 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbXEIJPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 05:15:33 -0400
Date: Wed, 9 May 2007 11:15:15 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: david@lang.hm
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Greg K-H <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Duncan Sands <duncan.sands@math.u-psud.fr>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
 (PCI_MULTITHREAD_PROBE)
Message-ID: <20070509111515.0cb3e63a@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <Pine.LNX.4.64.0705090128180.2213@asgard.lang.hm>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>
	<20070508141149.GJ4226@stusta.de>
	<alpine.LFD.0.98.0705080819350.3974@woody.linux-foundation.org>
	<20070508183846.28a94797@gondolin.boeblingen.de.ibm.com>
	<alpine.LFD.0.98.0705081123080.3974@woody.linux-foundation.org>
	<20070508212117.0be9dfe5@gondolin.boeblingen.de.ibm.com>
	<alpine.LFD.0.98.0705081227230.3882@woody.linux-foundation.org>
	<alpine.LFD.0.98.0705081249540.3882@woody.linux-foundation.org>
	<Pine.LNX.4.64.0705081314440.29403@asgard.lang.hm>
	<20070509095812.016035ee@gondolin.boeblingen.de.ibm.com>
	<Pine.LNX.4.64.0705090128180.2213@asgard.lang.hm>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.12; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007 01:33:14 -0700 (PDT),
david@lang.hm wrote:

> 1. why should different, unrelated busses need to wait for each other? 
> picking two, why can't you have SCSI and USB going through their timeouts 
> at the same time?

If they don't have dependencies on each other, yes. Some busses should
be finished before probing for others start (e.g. low-level busses).

> 2. I'm not sure that you can always do the device enumeration before you 
> do the slow probing, there's another message in this thread that talks 
> about a USB device where you need to load firmware to it before you can 
> find out what is really there. in a case like this devices would either 
> show up in a random order during step #2, or they should not be added to 
> the system until step #3, which makes step #3 more then just waiting for 
> the async portions to finish.

I'm not sure whether that is not really a question of "one depends upon
the other". If the low level bus knows where to point its probe at, the
higher level should be able to look at sane devices after the firmware
has been loaded (or am I misunderstanding the situation here?)
