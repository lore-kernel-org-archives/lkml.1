Return-Path: <linux-kernel-owner+w=401wt.eu-S1756899AbYEZTYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899AbYEZTYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 15:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756456AbYEZTX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 15:23:57 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:33106 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401AbYEZTXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 15:23:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=tDlYxrXVW0NPL0JcB1D6MvmRwLIS4CEQSt857MCop0SORbBOiTlUWkZ+mO8+FLF7dAn43oUBmPExyfve94fL7cFHxbn21Nv2OAxX0+owd5Mwi6tMajef9ClTV8/X41gPzbaUF9T1pvYBkj0eWeTP77a3N+WIUrnuWe7/GtA5GZk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 22/40] ide-floppy: start DMA engine in idefloppy_transfer_pc1()
Date: Tue, 27 May 2008 20:58:48 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, Borislav Petkov <petkovbb@gmail.com>,
       linux-kernel@vger.kernel.org
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain> <20080518185745.5636.55162.sendpatchset@localhost.localdomain> <4832AF59.1020808@ru.mvista.com>
In-Reply-To: <4832AF59.1020808@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805272058.48223.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 May 2008, Sergei Shtylyov wrote:
> Hello.
> 
> Bartlomiej Zolnierkiewicz wrote:
> 
> > Start DMA engine and set PC_FLAG_DMA_IN_PROGRESS flag in
> > idefloppy_transfer_pc1() instead of idefloppy_issue_pc()
> 
>     Good. I have long ago noticed that DMA is started too early in ide-floppy 
> which is known to cobfuse some chips (like PDC20246) and was going to do a 
> patch at first but the lack of hardware (and time) stopped me...
> 
> > so the Status Register and the Interrupt Reason Register
> > are checked first.
> 
> > Cc: Borislav Petkov <petkovbb@gmail.com>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> > Index: b/drivers/ide/ide-floppy.c
> > ===================================================================
> > --- a/drivers/ide/ide-floppy.c
> > +++ b/drivers/ide/ide-floppy.c
> [...]
> > @@ -568,6 +569,12 @@ static ide_startstop_t idefloppy_transfe
> >  
> >  	ide_set_handler(drive, &idefloppy_pc_intr, timeout, expiry);
> >  
> > +	/* Begin DMA, if necessary */
> > +	if (pc->flags & PC_FLAG_DMA_OK) {
> > +		pc->flags |= PC_FLAG_DMA_IN_PROGRESS;
> > +		hwif->dma_ops->dma_start(drive);
> > +	}
> > +
> 
>     May be too early still... ide-cd does this after writing the command packet.

I would rather say that ide-cd is doing things too late.

Now that's your patch opportunity!  No excuses this time... ;)

Thanks,
Bart
