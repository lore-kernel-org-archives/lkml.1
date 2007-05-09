Return-Path: <linux-kernel-owner+w=401wt.eu-S1757441AbXEINih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbXEINih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 09:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbXEINia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 09:38:30 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:33524 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbXEINi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 09:38:29 -0400
Date: Wed, 9 May 2007 15:38:13 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
 (PCI_MULTITHREAD_PROBE)
Message-ID: <20070509153813.52a7c397@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070509095302.GA13053@kroah.com>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>
	<20070508141149.GJ4226@stusta.de>
	<alpine.LFD.0.98.0705080819350.3974@woody.linux-foundation.org>
	<20070508183846.28a94797@gondolin.boeblingen.de.ibm.com>
	<20070509095302.GA13053@kroah.com>
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

On Wed, 9 May 2007 02:53:02 -0700,
Greg KH <greg@kroah.com> wrote:

> > 2. Sheer volume of devices on a bus. Even if the indivdual probing
> > doesn't take long, having all devices probed one after the other may
> > take a lot of time. Putting the actual probe on a thread makes it
> > possible to run several probes in parallel, thereby cutting probing
> > time.
> 
> Again, not for PCI, right?

It seems that everyone agrees now that moving PCI over to a new probing
model without individual driver support was a bad idea. So generic
multithreaded probing is dead.

> If you want to implement this for your bus type, fine, I have no
> objection to that at all, but not for PCI, it's just not worth it.

Infrastructure for async probing might not be such a bad idea, though.
(Aren't there some huge PCI-based machines?) However, I don't really
care whether PCI or SCSI or $HUGE_BUS use it, but serial synchronous
probing on a bus looks like a killer on most large systems.
