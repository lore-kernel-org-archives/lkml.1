Return-Path: <linux-kernel-owner+w=401wt.eu-S1754308AbXGIMpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbXGIMpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 08:45:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbXGIMoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 08:44:55 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:42822 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751865AbXGIMoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 08:44:54 -0400
X-YMail-OSG: 7nS.5iAVM1laJUd9hYZkD0r7Cz52.fB4e9jaFqAuhtSfqPPSKkAMUxx2F4Nly1VkF_v3g.6LJw--
Subject: Re: [BUG] IT8212 libata driver *still* hard-freezes system on boot
	on 2.6.22 final.
From: Rodney Gordon II <meff@spherevision.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
In-Reply-To: <20070709131649.5fa63744@the-village.bc.nu>
References: <1183944204.8932.8.camel@ghreen.sphere>
	 <20070709104930.4e26f38f@the-village.bc.nu>
	 <1183979782.4301.4.camel@ghreen.sphere>
	 <20070709131649.5fa63744@the-village.bc.nu>
Content-Type: text/plain
Date: Mon, 09 Jul 2007 07:44:49 -0500
Message-Id: <1183985089.4190.2.camel@ghreen.sphere>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-09 at 13:16 +0100, Alan Cox wrote:
> > > It would be useful to know if a kernel built with no DMA support for the
> > > IT8212 behaved as that might give us a clue about what is choking. If you
> > > look in drivers/ata/pata_it821x.c:it821x_init_one you'll see a pair of
> > > lines that say
> > > 
> > > 	mwdma = 0x1f,
> > > 	udma_mask = 0x7f
> > > 
> > > 
> > > remove, rebuild and report..
> > 
> > Alright.
> > 
> > Attachment [0] is a successful boot with those lines removed. (This a
> > good thing or a bad thing? :)
> 
> Thats an interesting question in itself. It does seem to indicate the
> problem is DMA tuning or DMA related and not IRQ routing - which is good
> as of itself.
> 
> > Attachment [1] is a successful boot with the old ata subsystem using the
> > IT8212.
> 
> For the next trick set mwdma_mask = 0x07 but leave UDMA off and see what
> happens. 

Lock.

> Then try with udma_mask = 0x02 which should force the 50MHz
> clock on not the 66MHz clock just in case its clock related.

Lock. :(

> How much RAM do you have ?

1536MB, using highmem 4GB. Please refer to my dmesg attachments in the
last post for more RAM info :)

> Alan

-r

