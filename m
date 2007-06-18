Return-Path: <linux-kernel-owner+w=401wt.eu-S932697AbXFRUqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697AbXFRUqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 16:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764795AbXFRUqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 16:46:07 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:57797 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764809AbXFRUqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 16:46:06 -0400
Date: Mon, 18 Jun 2007 15:46:01 -0500
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] ide dma_timer_expiry, then hard lockup
Message-ID: <20070618204601.GF5836@austin.ibm.com>
References: <20070618175713.GD5836@austin.ibm.com> <20070618212704.394912b8@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618212704.394912b8@the-village.bc.nu>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 09:27:04PM +0100, Alan Cox wrote:
> > ide_dma_timeout_retry() in ide-io.c 
> >   prints the "hdc: DMA Timeout error" then calls
> >   HWIF(drive)->ide_dma_end(drive);
> >     which returns, and then calls 
> >   hwif->INB(IDE_STATUS_REG) which is needed as an argument to ide_error()
> > 
> > But this hangs! -- The INB never returns.
> > Now:  hwif->INB = ide_inb; in ide-iops.c
> 
> Yep and the I/O cycle never completes so the box hangs. This occurs if
> the drive blows up and never switches IORDY to indicate completion. The
> hpt will also do this sometimes if it gets addled by a confused drive,
> while an intel one often won't.

So what do you suggest? (I could buy an alternate ide controller,
and hope that goes away, or just buy a different hard drive. But
that's beside the point).

I can prepare a patch, but only with a lot of guidance. I can test 
& debug, I'm highly motivated just right now ... 

--linas
