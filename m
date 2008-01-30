Return-Path: <linux-kernel-owner+w=401wt.eu-S964872AbYA3VXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964872AbYA3VXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:23:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933338AbYA3VUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:20:14 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:41131 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757291AbYA3VUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:20:11 -0500
Date: Wed, 30 Jan 2008 22:20:11 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Adrian Bunk <bunk@kernel.org>, davem@davemloft.net,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] scsi/qlogicpti.c section fixes
Message-ID: <20080130212011.GA26621@uranus.ravnborg.org>
References: <20080130200336.GN29368@does.not.exist> <1201726817.3292.84.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201726817.3292.84.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 03:00:16PM -0600, James Bottomley wrote:
> 
> On Wed, 2008-01-30 at 22:03 +0200, Adrian Bunk wrote:
> > This patch fixes the following section mismatches:
> > 
> > <--  snip  -->
> > 
> > ...
> > WARNING: drivers/scsi/qlogicpti.o(.devexit.text+0x8): Section mismatch in reference from the function qpti_sbus_remove() to the function .init.text:qpti_chain_del()
> > WARNING: drivers/scsi/qlogicpti.o(.devinit.text+0x56c): Section mismatch in reference from the function qpti_sbus_probe() to the function .init.text:qpti_map_regs()
> > WARNING: drivers/scsi/qlogicpti.o(.devinit.text+0x580): Section mismatch in reference from the function qpti_sbus_probe() to the function .init.text:qpti_register_irq()
> > WARNING: drivers/scsi/qlogicpti.o(.devinit.text+0x594): Section mismatch in reference from the function qpti_sbus_probe() to the function .init.text:qpti_get_scsi_id()
> > WARNING: drivers/scsi/qlogicpti.o(.devinit.text+0x5b8): Section mismatch in reference from the function qpti_sbus_probe() to the function .init.text:qpti_map_queues()
> > WARNING: drivers/scsi/qlogicpti.o(.devinit.text+0x780): Section mismatch in reference from the function qpti_sbus_probe() to the function .init.text:qpti_chain_add()
> > ...
> 
> OK, look, this is really getting out of hand.
We now at last have some infrastructure that does proper consistency
check of the use of annotation.
So it is by no means getting out-of-hands..

To my understanding Adrian just fixed a potential oops.
You have a driver that surely are thought to be hotplugable -
otherwise qpti_sbus_probe() would not have been annotated __devinit.
And had it ever been hotplugged then you had called a function in
a __init section that was long gone.

> __init is possibly justifiable with a few hundred k savings on boot.
> __devinit and the rest are surely killable on the grounds they provide
> little benefit for all the pain they cause.
For the embedded people a few kb here and there is worth it.

> all __exit seems to do is set us up for unreferenced pointers in
> discarded sections, so could we kill that too?
Again - savings when we build-in the drivers.
And without the checks we see 'funny' linker errors on the architectues
that can continue to add the .exit.text in /DISCARD/

	Sam
