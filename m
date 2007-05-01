Return-Path: <linux-kernel-owner+w=401wt.eu-S1754962AbXEARVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbXEARVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 13:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbXEARVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 13:21:22 -0400
Received: from mail.electro-mechanical.com ([216.184.71.30]:53092 "EHLO
	mail.electro-mechanical.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754955AbXEARVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 13:21:20 -0400
Date: Tue, 1 May 2007 13:21:17 -0400
From: William Thompson <wt@electro-mechanical.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Mark Lord <liml@rtr.ca>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       albertcc@tw.ibm.com, Jeff Garzik <jgarzik@pobox.com>
Subject: Re: 2.6.20 libata cdrom
Message-ID: <20070501172117.GA20328@electro-mechanical.com>
References: <20070427175205.GD7809@electro-mechanical.com> <4635C35D.1020807@gmail.com> <20070430202107.GF5942@electro-mechanical.com> <4636C2C7.8090206@gmail.com> <20070501121703.GH5942@electro-mechanical.com> <46373AEE.6070908@rtr.ca> <20070501131818.GA18521@electro-mechanical.com> <46374354.7040307@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46374354.7040307@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 03:40:36PM +0200, Tejun Heo wrote:
> >> Tejun, don't we have a fallback for when IDENTIFY fails?
> >> If the drive rejects it (err=0x04), then this can mean only one thing:
> >> unsupported command, so we next must try PACKET_IDENTIFY.
> 
> Up until now, we've been depending on the device giving us the correct
> signature on reset.  This is the first reported case which screws that
> up.  Gee... Two crazy screwed up devices today.  What's going on?

libata-pata is getting it's field testing now!

> > Is it doing that just for this drive?  I use libata on another machine (Dell
> > Dimension 2400) and it finds the cdrom just fine.
> 
> That specific cdrom is crazy.  It's telling libata that it's a disk when
> it apparently isn't.

Wasn't sure, I thought it was something with the chipset.  Every Dell
Dimension L series machine has done this to me (The DMA thing, that is).
Some gateways have as well.

> > The one thing I do know, the machine with the non-working libata cdrom also
> > does not work with the ide driver *ONLY IF* DMA is turned on.
> 
> This is probably as Mark explained in the other thread.
> 
> Anyways, oh well, it looks like we need fallback mechanism to the other
> IDENTIFY command after all.  Jeff, any ideas or objections?

Got a patch or anything I can do to test?
