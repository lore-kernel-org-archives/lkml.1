Return-Path: <linux-kernel-owner+w=401wt.eu-S934875AbZARSaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934875AbZARSaI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 13:30:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765350AbZARS3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 13:29:55 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40981 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765092AbZARS3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 13:29:54 -0500
Date: Sun, 18 Jan 2009 18:29:55 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Pavel Machek <pavel@suse.cz>, Carsten Schlote <c.schlote@konzeptpark.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][ATA] Add ide-disk led-trigger to ATA subsystem
Message-ID: <20090118182955.5e994064@lxorguk.ukuu.org.uk>
In-Reply-To: <49734FC6.9070500@garzik.org>
References: <1231600107.10065.4.camel@kplaws107lx>
	<20090118081140.GA1944@ucw.cz>
	<49734FC6.9070500@garzik.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Jan 2009 10:50:30 -0500
Jeff Garzik <jeff@garzik.org> wrote:

> Pavel Machek wrote:
> > On Sat 2009-01-10 16:08:27, Carsten Schlote wrote:
> >>  void ata_sff_exec_command(struct ata_port *ap, const struct
> >> ata_taskfile *tf)
> >>  {
> >> +	ledtrig_ide_activity();
> >> +
> >>  	DPRINTK("ata%u: cmd 0x%X\n", ap->print_id, tf->command);
> >>  
> >>  	iowrite8(tf->command, ap->ioaddr.command_addr);
> >>
> > 
> > Is there a more generic place so that we won't have to modify all the
> > libata drivers?
> 
> 
> One would think you could do this at the block layer...

ata_sff_exec_command is also on a timing critical path so the wrong place
to be touching other stuff. It's mid command issue.
