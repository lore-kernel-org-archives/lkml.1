Return-Path: <linux-kernel-owner+w=401wt.eu-S965352AbXC1Iec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965352AbXC1Iec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 04:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934014AbXC1Ieb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 04:34:31 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:24977 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933960AbXC1Iea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 04:34:30 -0400
Date: Wed, 28 Mar 2007 10:36:25 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: gregkh@suse.de, Adrian Bunk <bunk@stusta.de>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove the broken PCI_MULTITHREAD_PROBE option
Message-ID: <20070328103625.23910f1e@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070327225006.GC4478@kroah.com>
References: <20070327010251.GX16477@stusta.de>
	<20070327130351.51aff00e@gondolin.boeblingen.de.ibm.com>
	<20070327225006.GC4478@kroah.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2007 15:50:06 -0700,
Greg KH <greg@kroah.com> wrote:

> > Greg, what about driver-core-per-subsystem-multithreaded-probing.patch?
> > PCI_MULTITHREAD_PROBE shoudn't be broken with that, only in mainline?
> 
> Do you want to enable PCI multithreaded probing using your patch?  I
> don't think the world is ready for pci multithreaded probing as was
> determined by the zillion of bug reports from people who like to enable
> config options that state in big letters, "THIS WILL BREAK YOUR BOX"...

But IIRC, that was without my patch? Wouldn't per-subsystem
multithreaded probing just expose bugs that could also be exposed on
SMP systems?

> And I'm still questioning if we should add your patch at all, as I don't
> think any other subsystems need it.  Do you?

The css/ccw busses may profit from it, since we tend to have thousands
of devices there. OTOH, we've already tried to make probing as
asynchronous as possible, so maybe there isn't that much gain. I'd need
to do some measurements (when I find some time...)
