Return-Path: <linux-kernel-owner+w=401wt.eu-S966665AbXEHUhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966665AbXEHUhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933223AbXEHUhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:37:17 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:2532 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286AbXEHUhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:37:14 -0400
Date: Tue, 8 May 2007 22:36:53 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@stusta.de>, Greg K-H <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
 (PCI_MULTITHREAD_PROBE)
Message-ID: <20070508223653.1bb63b08@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <alpine.LFD.0.98.0705081227230.3882@woody.linux-foundation.org>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>
	<20070508141149.GJ4226@stusta.de>
	<alpine.LFD.0.98.0705080819350.3974@woody.linux-foundation.org>
	<20070508183846.28a94797@gondolin.boeblingen.de.ibm.com>
	<alpine.LFD.0.98.0705081123080.3974@woody.linux-foundation.org>
	<20070508212117.0be9dfe5@gondolin.boeblingen.de.ibm.com>
	<alpine.LFD.0.98.0705081227230.3882@woody.linux-foundation.org>
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

On Tue, 8 May 2007 12:31:22 -0700 (PDT),
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > What if two devices become hotplugged at the same time? Does this imply 
> > that the bus _always_ needs to do some serializing there?
> 
> You want to test it? Be my guest.

It was more a rhetorical question. If not all drivers can handle it,
serialize at the bus level. But if all drivers can, there's no reason
for the bus to do it. On a bus with a small number of drivers, I
prefer to have the drivers in good shape. (This kind of implies that e.
g. pci needs to serialize, but css/ccw doesn't, and doesn't have to.)

> But the final nail in the coffin is that doing it at the bus level is 
> INFERIOR. As you yourself admitted, it's better to do some things 
> synchronously.

How so? It is possible to do some stuff synchronously. But why
shouldn't other things be done asynchronously?
(And there is a place both for bus-level parallelism and driver-level
parallelism. Just depends on your bus/driver/device.)
