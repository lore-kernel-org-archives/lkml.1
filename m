Return-Path: <linux-kernel-owner+w=401wt.eu-S1759214AbYJKQtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759214AbYJKQtu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 12:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754523AbYJKQtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 12:49:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:53158 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329AbYJKQtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 12:49:39 -0400
Date: Sat, 11 Oct 2008 09:49:30 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, torvalds@osdl.org
Subject: Re: libata: set queue SSD flag for SSD devices
Message-ID: <20081011094930.3cf55ea5@infradead.org>
In-Reply-To: <1223743124.4159.27.camel@localhost.localdomain>
References: <200810101904.m9AJ42Gq018897@hera.kernel.org>
	<20081010202515.446857cc@lxorguk.ukuu.org.uk>
	<20081010200528.GJ19428@kernel.dk>
	<20081010175508.3d1ed2a4@infradead.org>
	<1223710417.4159.11.camel@localhost.localdomain>
	<20081011140600.GR19428@kernel.dk>
	<1223739853.4159.17.camel@localhost.localdomain>
	<20081011090407.6de9b8b4@infradead.org>
	<1223743124.4159.27.camel@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Oct 2008 18:38:44 +0200
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Sat, 2008-10-11 at 09:04 -0700, Arjan van de Ven wrote:
> > On Sat, 11 Oct 2008 17:44:13 +0200
> > James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > 
> > > 
> > > > So we need something a bit more involved, but not too complex. A
> > > > fine line...
> > > 
> > > It's a policy ... just let userspace do it so the user can tune
> > > it. That's what EMC does now (except I think they key of inquiry
> > > strings rather than cache size).
> > 
> > 
> > while the chosen elevator obviously is policy, the kernel really
> > should pick a sensible default based on what it knows.
> > Lets put it this way: if userland needs to do a tuning to the kernel
> > based on data only provided by the kernel, and will always do it the
> > same way, we should have made that choice the default policy in the
> > kernel in the first place.
> 
> Well, this is a bit of a nasty layering problem.  We certainly don't
> want the Block layer to know how to poke at SATA, SCSI and other
> esoteric media to see what elevator should be the default, so we'd
> have to craft a new block API that the lower subsystems would
> implement for this.  I'm really not sure it's worth the trouble when
> the boot system can do it simply from userspace, but I'll defer to
> Jens.
> 

these devices already give the elevator layer information about the
device, like optimal/max io size etc.
having the elevator take a "don't bother optimizing for seeks" flag
is very much along the same lines, it's a device property that the
elevator needs to learn about in order to send the right kinds of IO
down.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
