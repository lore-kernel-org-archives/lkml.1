Return-Path: <linux-kernel-owner+w=401wt.eu-S1423542AbXEANmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423542AbXEANmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 09:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423540AbXEANmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 09:42:45 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43631 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423503AbXEANmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 09:42:40 -0400
Date: Tue, 1 May 2007 14:46:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: rct@gherkin.frus.com (Bob Tracy)
Cc: James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: BAD_SG_DMA panic in aha1542
Message-ID: <20070501144623.361d37f0@the-village.bc.nu>
In-Reply-To: <20070501021032.61120DBA1@gherkin.frus.com>
References: <20070501021032.61120DBA1@gherkin.frus.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> That's as close as it gets without redoing everything from scratch.
> I'll give Alan's and James' patches a go within the next 13 hours.
> 
> (Alan: what *else* would you name a variable associated with a bounce
> buffer besides Zebedee?  Thanks for the occasion to smile...)

The one I sent has a memory leak but it won't matter for basic testing.
Or you can change the final bit to


        scsi_normalize_sense((char *)sense, sizeof(*sense), &sshdr);
        
        if (zebedee != cgc->buffer) {
                if (cgc->data_direction == DMA_FROM_DEVICE)    
                        memcpy(cgc->buffer, zebedee, cgc->buflen);
                kfree(zebedee); /* Time for bed */        
        }

Alan
--

`I can hear you.` ,said Florence. `It s not true. Noddy and I are just
good friends.`
