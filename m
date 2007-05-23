Return-Path: <linux-kernel-owner+w=401wt.eu-S1763272AbXEWIb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763272AbXEWIb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 04:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757335AbXEWIbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 04:31:19 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:46343 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754200AbXEWIbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 04:31:18 -0400
Date: Wed, 23 May 2007 17:30:26 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: pata_platform: Disable prereset logic.
Message-ID: <20070523083026.GA29851@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Tejun Heo <htejun@gmail.com>, Jeff Garzik <jgarzik@pobox.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20070523064408.GA29593@linux-sh.org> <4653F62C.4070700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4653F62C.4070700@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 10:07:08AM +0200, Tejun Heo wrote:
> Paul Mundt wrote:
> > On a number of boards the current prereset logic seems to misbehave:
> > 
> > scsi0 : pata_platform
> > ata1: PATA max PIO0 cmd 0xb06001f0 ctl 0xb06003f6 bmdma 0x00000000 irq 0
> > ata1: device not ready (errno=-19), forcing hardreset
> > ata1: BUG: prereset() requested invalid reset type
> > 
> > This triggers when there is no card inserted in the slot.
> > 
> > Simply disabling the prereset gets rid of this, and doesn't seem to cause
> > any problems for either PCMCIA or CF cards when they're actually present.
> 
> NACK.  The BUG printking needs fixing but you can't just kill
> prereset().  Did it work properly on 2.6.21.1?  Can you modify
> ata_wait_ready() such that it prints out the status value while waiting?
> 
ata_wait_ready() works fine, it reports 0xff immediately (and this is
what I would expect when there is no card inserted).

The board that exhibits this behaviour wasn't supported in the older
kernels, I can backport and test if it will be useful, though.
