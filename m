Return-Path: <linux-kernel-owner+w=401wt.eu-S1752476AbYKLCCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbYKLCCO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 21:02:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbYKLCB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 21:01:57 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38072 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751384AbYKLCB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 21:01:56 -0500
Date: Tue, 11 Nov 2008 18:01:54 -0800
From: Jeremy Higdon <jeremy@sgi.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] ide: ->ide_dma_clear_irq() -> ->clear_irq()
Message-ID: <20081112020154.GD231878@sgi.com>
References: <200808192031.40288.bzolnier@gmail.com> <48AB478B.5040209@ru.mvista.com> <48CEDD89.5060107@ru.mvista.com> <200809151529.50424.bzolnier@gmail.com> <48CF7986.2020302@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48CF7986.2020302@ru.mvista.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2008 at 01:16:54PM +0400, Sergei Shtylyov wrote:
> >>>>Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >>>>        
> >>>Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> >>>      
> >>   Not feeling sure about this patch -- ->waiting_for_dma probably 
> >>should've been left where it was...
> >>    
> >
> >Well, it doesn't change behavior and I think having ->clear_irq method
> >independent from the transfer mode is a preffered approach.
> >  
> 
>   But its implementations will have to depend on it anyway. And 
> clearing the IDE interrupt in general already depends on the transfer 
> mode -- the BMIDE interrupt which is a (delayed) reflection of INTRQ is 
> cleared implicitly by the dma_end() method -- except in at least sgiioc4 
> driver.
>   BTW, sgiioc4 seems another candidate for clear_irq() implementation 
> -- currently clearing is done implicitly by the read_status() method (I 
> don't quite understand why it clears DMA error interrupt there). 
> However, since there's no documentation, I'm not sure how the IDE 
> interrupt is latched by IOC4.

The person who originally wrote sgiioc4 has been gone for a long time.

I'm guessing that the DMA error is cleared there, because any DMA error
status has already been processed above, and it's easier to clear
unconditionally than to test and clear, and there's no ill effect to
clearing something that's already clear.

jeremy
