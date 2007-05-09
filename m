Return-Path: <linux-kernel-owner+w=401wt.eu-S1758392AbXEISg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392AbXEISg7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 14:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756751AbXEISgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 14:36:47 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:21312 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758121AbXEISgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 14:36:45 -0400
Date: Wed, 9 May 2007 20:36:19 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: david@lang.hm
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Greg K-H <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Duncan Sands <duncan.sands@math.u-psud.fr>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
 (PCI_MULTITHREAD_PROBE)
Message-ID: <20070509203619.5a8e2f5c@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <Pine.LNX.4.64.0705091050410.4467@asgard.lang.hm>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>
	<20070508183846.28a94797@gondolin.boeblingen.de.ibm.com>
	<alpine.LFD.0.98.0705081123080.3974@woody.linux-foundation.org>
	<20070508212117.0be9dfe5@gondolin.boeblingen.de.ibm.com>
	<alpine.LFD.0.98.0705081227230.3882@woody.linux-foundation.org>
	<alpine.LFD.0.98.0705081249540.3882@woody.linux-foundation.org>
	<Pine.LNX.4.64.0705081314440.29403@asgard.lang.hm>
	<20070509095812.016035ee@gondolin.boeblingen.de.ibm.com>
	<Pine.LNX.4.64.0705090128180.2213@asgard.lang.hm>
	<20070509111515.0cb3e63a@gondolin.boeblingen.de.ibm.com>
	<Pine.LNX.4.64.0705090216030.2213@asgard.lang.hm>
	<20070509152024.1a57d82a@gondolin.boeblingen.de.ibm.com>
	<Pine.LNX.4.64.0705090910050.4467@asgard.lang.hm>
	<20070509190736.35cf51d2@gondolin.boeblingen.de.ibm.com>
	<Pine.LNX.4.64.0705091007160.4467@asgard.lang.hm>
	<20070509194845.1caf5fd0@gondolin.boeblingen.de.ibm.com>
	<Pine.LNX.4.64.0705091050410.4467@asgard.lang.hm>
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

On Wed, 9 May 2007 10:53:52 -0700 (PDT),
david@lang.hm wrote:

> if you want the registration to use hotplug and be async then do do the 
> registration during step 2 and make step 4 be a noop, in fact some drivers 
> may do all their work in step 2, while others (everything currently) will 
> do all their work during step 1

The added benefit of setup() I was thinking of was being able to
enable/disable devices later on (where enable entails the "heavy
lifting").

Say you have a range of devices you only use seldomly for some special
purpose. They may take a long time to get up and use a lot of resources
when they're on. You don't want to slow the boot process down for them,
so they start disabled with just very basic setup (the fast stuff)
done. (It is also useful if you want some manual configuration between
the fast stuff and the heavy lifting.) When you need them, you spin
them up (may take some time) and then use them. Afterwards, you could
spin them down again. (This is what the ccw/ccwgroup/ap bus online
attribute does today.)
