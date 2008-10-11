Return-Path: <linux-kernel-owner+w=401wt.eu-S1757583AbYJKQjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbYJKQjA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 12:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179AbYJKQiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 12:38:51 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:46011 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753616AbYJKQiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 12:38:50 -0400
Subject: Re: libata: set queue SSD flag for SSD devices
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, torvalds@osdl.org
In-Reply-To: <20081011090407.6de9b8b4@infradead.org>
References: <200810101904.m9AJ42Gq018897@hera.kernel.org>
	 <20081010202515.446857cc@lxorguk.ukuu.org.uk>
	 <20081010200528.GJ19428@kernel.dk> <20081010175508.3d1ed2a4@infradead.org>
	 <1223710417.4159.11.camel@localhost.localdomain>
	 <20081011140600.GR19428@kernel.dk>
	 <1223739853.4159.17.camel@localhost.localdomain>
	 <20081011090407.6de9b8b4@infradead.org>
Content-Type: text/plain
Date: Sat, 11 Oct 2008 18:38:44 +0200
Message-Id: <1223743124.4159.27.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-10-11 at 09:04 -0700, Arjan van de Ven wrote:
> On Sat, 11 Oct 2008 17:44:13 +0200
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > 
> > > So we need something a bit more involved, but not too complex. A
> > > fine line...
> > 
> > It's a policy ... just let userspace do it so the user can tune it.
> > That's what EMC does now (except I think they key of inquiry strings
> > rather than cache size).
> 
> 
> while the chosen elevator obviously is policy, the kernel really should
> pick a sensible default based on what it knows.
> Lets put it this way: if userland needs to do a tuning to the kernel
> based on data only provided by the kernel, and will always do it the
> same way, we should have made that choice the default policy in the
> kernel in the first place.

Well, this is a bit of a nasty layering problem.  We certainly don't
want the Block layer to know how to poke at SATA, SCSI and other
esoteric media to see what elevator should be the default, so we'd have
to craft a new block API that the lower subsystems would implement for
this.  I'm really not sure it's worth the trouble when the boot system
can do it simply from userspace, but I'll defer to Jens.

James


