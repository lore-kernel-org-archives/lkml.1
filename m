Return-Path: <linux-kernel-owner+w=401wt.eu-S1755063AbYFPNQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063AbYFPNQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 09:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYFPNQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 09:16:42 -0400
Received: from userg500.nifty.com ([202.248.238.80]:64708 "EHLO
	userg500.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbYFPNQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 09:16:41 -0400
DomainKey-Signature: a=rsa-sha1; s=userg500; d=nifty.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:content-transfer-encoding;
	b=UyftToneQ2+lD7NopZWW+mpqY9UBc+MTEqJtVsqBqRjhMvx7DY67HvU1vLMQBR1hP
	wMMLXe/TJjmV4Cecibuqg==
X-Nifty-SrcIP: [220.145.30.232]
Date: Mon, 16 Jun 2008 22:11:45 +0900
From: Komuro <komurojun-mbn@nifty.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>, jgarzik@redhat.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pcmcia <linux-pcmcia@lists.infradead.org>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>
Subject: Re: [KERNEL 2.6.26-rc4]  bugreport : pata_pcmcia with Sandisk
 Extreme III 8GB
Message-Id: <20080616221145.e3b069b9.komurojun-mbn@nifty.com>
In-Reply-To: <4855D8E2.10409@gmail.com>
References: <20080528225049.9a134e0d.Kristoffer.Ericson@Gmail.com>
	<20080528222740.GB20893@isilmar.linta.de>
	<20080530135728.be02d3dc.Kristoffer.Ericson@Gmail.com>
	<20080607223716.7d142072.komurojun-mbn@nifty.com>
	<20080611072029.GB28692@comet.dominikbrodowski.net>
	<20080614120055.ad8fbee0.komurojun-mbn@nifty.com>
	<48537149.4040102@garzik.org>
	<20080614213612.96873c25.komurojun-mbn@nifty.com>
	<4855D8E2.10409@gmail.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the log  (your patch is applied).
Unfortunately, no message that you added appears.

It seems this device is detected as pcmcia0.0 first
but later it is detected as pcmcia0.1.


>pcmcia: registering new device pcmcia0.0
>scsi2 : pata_pcmcia
>ata3: PATA max PIO0 cmd 0xd100 ctl 0xd10e irq 4
>ata3.00: CFA: , Ver.1.0, max PIO2
>ata3.00: 32000 sectors, multi 0: LBA 
>ata3.00: configured for PIO0
>ata3.00: configured for PIO0
>ata3: EH complete
>isa bounce pool size: 16 pages
>scsi 2:0:0:0: Direct-Access     ATA                       Ver. PQ: 0 ANSI: 5
>sd 2:0:0:0: [sdb] 32000 512-byte hardware sectors (16 MB)
>sd 2:0:0:0: [sdb] Write Protect is off
>sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
>sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
>sd 2:0:0:0: [sdb] 32000 512-byte hardware sectors (16 MB)
>sd 2:0:0:0: [sdb] Write Protect is off
>sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
>sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
> sdb: sdb1
>sd 2:0:0:0: [sdb] Attached SCSI removable disk
>sd 2:0:0:0: Attached scsi generic sg2 type 0
>pcmcia: registering new device pcmcia0.1
>pcmcia: registering new device pcmcia0.1
>0.1: GetNextTuple: No more items
>pata_pcmcia: probe of 0.1 failed with error -12
>modprobe used greatest stack depth: 1684 bytes left
>0.1: GetNextTuple: No more items
>pata_pcmcia: probe of 0.1 failed with error -12
>0.1: GetNextTuple: No more items
>pata_pcmcia: probe of 0.1 failed with error -12

Best Regards
Komuro

> Hello,
> 
> Komuro wrote:
> > On Sat, 14 Jun 2008 03:20:41 -0400
> > Jeff Garzik <jeff@garzik.org> wrote:
> > 
> > 
> > After removing the 3-lines below in ata_eh_reset
> > the pata_pcmcia works properly.
> > 
> > 
> > -       spin_lock_irqsave(link->ap->lock, flags);
> > -       link->eh_info.serror = 0;
> > -       spin_unlock_irqrestore(link->ap->lock, flags);
> > 
> > Please fix this problem.
> 
> Thanks for diagnosing the problem but it doesn't make any sense at all.
>  Those three lines just clear cached SError value.  pata_pcmcia being a
> PATA driver, SError is not implemented and always zero.
> 
> Also the init_one error is -ENOMEM.  For the above change to make any
> difference, EH should have been entered which is invoked deep into
> ata_host_register() and once control reaches that point it never returns
> error code.  I have difficult time imagining any way the above diff can
> have anything to do with the reported failure.
> 
> Please apply the attached patch and report the log after probe failure.
> 
> Thanks.
> 
> -- 
> tejun
> 


