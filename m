Return-Path: <linux-kernel-owner+w=401wt.eu-S1030302AbXCSQEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030302AbXCSQEF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 12:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030299AbXCSQEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 12:04:05 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53761 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030295AbXCSQEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 12:04:01 -0400
Message-ID: <45FEB46A.7040602@garzik.org>
Date: Mon, 19 Mar 2007 12:03:54 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Fabio Comolli <fabio.comolli@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH] libata: don't whine if ->prereset() returns -ENOENT
References: <20070309163148.GA12848@havoc.gtf.org>	<b637ec0b0703091324q7f15fddbpc8c24b4e1131e3f4@mail.gmail.com> <20070309234839.2070a265@lxorguk.ukuu.org.uk> <45F50E28.7010509@gmail.com>
In-Reply-To: <45F50E28.7010509@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> ->prereset() returns -ENOENT to tell libata that the port is empty and
> reset sequencing should be stopped.  This is not an error condition.
> Update ata_eh_reset() such that it sets device classes to ATA_DEV_NONE
> and return success in on -ENOENT.  This makes spurious error message
> go away.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> ---
> 
> This should do it and better fits the intention of the return value.
> Two things to note.
> 
> 1. I think these ports should be made dummy instead of returning
> -ENOENT on prereset().  -ENOENT from prereset() was a hack to keep
> ata_piix's behavior unchanged while converting it to new EH.  If no
> one objcts, I'll convert similar usages to use dummy ports after new
> init model and drop -ENOENT hack in #upstream.
> 
> 2. -ENODEV sounds more appropriate.  Why have I used -ENOENT.  :-)

applied


