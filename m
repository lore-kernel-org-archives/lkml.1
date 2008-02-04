Return-Path: <linux-kernel-owner+w=401wt.eu-S1753197AbYBDLBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbYBDLBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 06:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbYBDLBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 06:01:34 -0500
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:59878 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbYBDLBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 06:01:33 -0500
Date: Mon, 4 Feb 2008 11:01:22 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Boaz Harrosh <bharrosh@panasas.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-scsi <linux-scsi@vger.kernel.org>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [build bug] drivers/scsi/NCR53C9x.c:913: error: 'Scsi_Cmnd' has
 no member named 'use_sg'
In-Reply-To: <47A20736.1080404@panasas.com>
Message-ID: <Pine.LNX.4.64N.0802041045500.23236@blysk.ds.pg.gda.pl>
References: <20080131172901.GA8589@elte.hu> <47A20736.1080404@panasas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008, Boaz Harrosh wrote:

> On Thu, Jan 31 2008 at 19:29 +0200, Ingo Molnar <mingo@elte.hu> wrote:
> > FYI, automated testing found the following build breakage:
> > 
> > drivers/scsi/NCR53C9x.c: In function 'esp_get_dmabufs':
> > drivers/scsi/NCR53C9x.c:913: error: 'Scsi_Cmnd' has no member named 'use_sg'
> > drivers/scsi/NCR53C9x.c:914: error: 'Scsi_Cmnd' has no member named 'request_bufflen'
> > 
> > config attached.
> > 
> > 	Ingo
> > 
> Cc linux-scsi mailing list.
> 
> This driver and others are scheduled to be removed in the scsi-pending tree
> and are awaiting ACKs from - disappeared - maintainers.

 Well, buried in some other activities.  You certainly have had my ack to 
remove dec_esp.c already and I started to work on replacement front-end 
drivers long ago.

 Unfortunately one of the three hardware configurations to be supported by 
the front-ends does not fit the interrupt handling model implemented by 
the esp_scsi.c core.  Or it is actually the other way round as you cannot 
adjust hardware to fit the driver, so I am in a process of rewriting the 
core a little bit in this respect -- the core switches to interrupt 
polling under some circumstances and does not expect a higher-priority 
interrupt of a different kind to arrive from the bus master controller the 
SCSI chips are attached to instead.

 Being no SCSI expert though I have to study the SCSI spec well enough to 
understand some bits and I am somewhat distracted these days, so it may 
take a while yet.  It is at the highest priority on my to-do list though.

  Maciej
