Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbYFRM3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbYFRM3L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 08:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753673AbYFRM2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 08:28:55 -0400
Received: from userg501.nifty.com ([202.248.238.81]:21107 "EHLO
	userg501.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665AbYFRM2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 08:28:53 -0400
DomainKey-Signature: a=rsa-sha1; s=userg501; d=nifty.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:content-transfer-encoding;
	b=Dp/qGLpMhxfCKEAk2HKHYkqMbgUn5Jy5veQR6IHkpyeWyP8iOuNe9jc1HgYHGM3eQ
	MiaBnaE8qq1q9Ux8McQZg==
X-Nifty-SrcIP: [220.145.30.182]
Date: Wed, 18 Jun 2008 21:23:58 +0900
From: Komuro <komurojun-mbn@nifty.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>, jgarzik@redhat.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pcmcia <linux-pcmcia@lists.infradead.org>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>
Subject: Re: [KERNEL 2.6.26-rc4]  bugreport : pata_pcmcia with Sandisk
 Extreme III 8GB
Message-Id: <20080618212358.c9bbf3fd.komurojun-mbn@nifty.com>
In-Reply-To: <4857C590.6050002@gmail.com>
References: <20080528225049.9a134e0d.Kristoffer.Ericson@Gmail.com>
	<20080528222740.GB20893@isilmar.linta.de>
	<20080530135728.be02d3dc.Kristoffer.Ericson@Gmail.com>
	<20080607223716.7d142072.komurojun-mbn@nifty.com>
	<20080611072029.GB28692@comet.dominikbrodowski.net>
	<20080614120055.ad8fbee0.komurojun-mbn@nifty.com>
	<48537149.4040102@garzik.org>
	<20080614213612.96873c25.komurojun-mbn@nifty.com>
	<4855D8E2.10409@gmail.com>
	<20080616221145.e3b069b9.komurojun-mbn@nifty.com>
	<485669A0.6000404@gmail.com>
	<20080617212345.c452d8c5.komurojun-mbn@nifty.com>
	<4857C590.6050002@gmail.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Here is the log.

My card is single function device.

it is correct that GetNextTuple fails for pcmcia0.1.
since pcmcia0.1 does not exist.

I think the reason of this problem is
memory-leak or something.


pcmcia: registering new device pcmcia0.0
pata_pcmcia 0.0: XXX ENTER
pata_pcmcia 0.0: XXX resource loop, pass=0
pata_pcmcia 0.0: XXX resource loop, pass=0
scsi2 : pata_pcmcia
ata3: PATA max PIO0 cmd 0xd100 ctl 0xd10e irq 4
ata3.00: CFA: , Ver.1.0, max PIO2
ata3.00: 32000 sectors, multi 0: LBA 
ata3.00: configured for PIO0
ata3.00: configured for PIO0
ata3: EH complete
isa bounce pool size: 16 pages
scsi 2:0:0:0: Direct-Access     ATA                       Ver. PQ: 0 ANSI: 5
sd 2:0:0:0: [sdb] 32000 512-byte hardware sectors (16 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdb] 32000 512-byte hardware sectors (16 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1
sd 2:0:0:0: [sdb] Attached SCSI removable disk
sd 2:0:0:0: Attached scsi generic sg2 type 0
pata_pcmcia 0.0: XXX LEAVE 0
pcmcia: registering new device pcmcia0.1
pata_pcmcia 0.1: XXX ENTER
pata_pcmcia 0.1: XXX resource loop, pass=0
pata_pcmcia 0.1: XXX resource loop, pass=0
pata_pcmcia 0.1: XXX IO request failed 2 0:16 0:0
pata_pcmcia 0.1: XXX resource loop, pass=0
pata_pcmcia 0.1: XXX IO request failed 1 1f0:8 3f6:1
pata_pcmcia 0.1: XXX resource loop, pass=0
pata_pcmcia 0.1: XXX IO request failed 1 170:8 376:1
pata_pcmcia 0.1: XXX pass=0, doing GetFirstTuple
pata_pcmcia 0.1: XXX resource loop, pass=1
pata_pcmcia 0.1: XXX pass=1, doing GetNextTuple
pata_pcmcia 0.1: XXX resource loop, pass=1
pata_pcmcia 0.1: XXX IO request failed 2 0:16 376:0
pata_pcmcia 0.1: XXX pass=1, doing GetNextTuple
pata_pcmcia 0.1: XXX resource loop, pass=1
pata_pcmcia 0.1: XXX IO request failed 1 1f0:8 3f6:1
pata_pcmcia 0.1: XXX pass=1, doing GetNextTuple
pata_pcmcia 0.1: XXX resource loop, pass=1
pata_pcmcia 0.1: XXX IO request failed 1 170:8 376:1
pata_pcmcia 0.1: XXX pass=1, doing GetNextTuple
0.1: GetNextTuple: No more items
pata_pcmcia 0.1: XXX LEAVE -12
pata_pcmcia: probe of 0.1 failed with error -12
modprobe used greatest stack depth: 1676 bytes left
pata_pcmcia 0.1: XXX ENTER
pata_pcmcia 0.1: XXX resource loop, pass=0
pata_pcmcia 0.1: XXX resource loop, pass=0
pata_pcmcia 0.1: XXX IO request failed 2 0:16 376:0
pata_pcmcia 0.1: XXX resource loop, pass=0
pata_pcmcia 0.1: XXX IO request failed 1 1f0:8 3f6:1
pata_pcmcia 0.1: XXX resource loop, pass=0
pata_pcmcia 0.1: XXX IO request failed 1 170:8 376:1
pata_pcmcia 0.1: XXX pass=0, doing GetFirstTuple
pata_pcmcia 0.1: XXX resource loop, pass=1
pata_pcmcia 0.1: XXX pass=1, doing GetNextTuple
pata_pcmcia 0.1: XXX resource loop, pass=1
pata_pcmcia 0.1: XXX IO request failed 2 0:16 376:0
pata_pcmcia 0.1: XXX pass=1, doing GetNextTuple
pata_pcmcia 0.1: XXX resource loop, pass=1
pata_pcmcia 0.1: XXX IO request failed 1 1f0:8 3f6:1
pata_pcmcia 0.1: XXX pass=1, doing GetNextTuple
pata_pcmcia 0.1: XXX resource loop, pass=1
pata_pcmcia 0.1: XXX IO request failed 1 170:8 376:1
pata_pcmcia 0.1: XXX pass=1, doing GetNextTuple
0.1: GetNextTuple: No more items
pata_pcmcia 0.1: XXX LEAVE -12
pata_pcmcia: probe of 0.1 failed with error -12
pata_pcmcia 0.1: XXX ENTER
pata_pcmcia 0.1: XXX resource loop, pass=0
pata_pcmcia 0.1: XXX resource loop, pass=0
pata_pcmcia 0.1: XXX IO request failed 2 0:16 376:0
pata_pcmcia 0.1: XXX resource loop, pass=0
pata_pcmcia 0.1: XXX IO request failed 1 1f0:8 3f6:1
pata_pcmcia 0.1: XXX resource loop, pass=0
pata_pcmcia 0.1: XXX IO request failed 1 170:8 376:1
pata_pcmcia 0.1: XXX pass=0, doing GetFirstTuple
pata_pcmcia 0.1: XXX resource loop, pass=1
pata_pcmcia 0.1: XXX pass=1, doing GetNextTuple
pata_pcmcia 0.1: XXX resource loop, pass=1
pata_pcmcia 0.1: XXX IO request failed 2 0:16 376:0
pata_pcmcia 0.1: XXX pass=1, doing GetNextTuple
pata_pcmcia 0.1: XXX resource loop, pass=1
pata_pcmcia 0.1: XXX IO request failed 1 1f0:8 3f6:1
pata_pcmcia 0.1: XXX pass=1, doing GetNextTuple
pata_pcmcia 0.1: XXX resource loop, pass=1
pata_pcmcia 0.1: XXX IO request failed 1 170:8 376:1
pata_pcmcia 0.1: XXX pass=1, doing GetNextTuple
0.1: GetNextTuple: No more items
pata_pcmcia 0.1: XXX LEAVE -12
pata_pcmcia: probe of 0.1 failed with error -12

Best Regards
Komuro

> Okay.  The exit is from CS_CHECK macro on GetNextTuple, missed that
> macro. It means it failed to request IO resource somewhere.  Can you
> please try the attached patch?  It will show us where it failed.
> 
> This part of code hasn't changed at all in pata_pcmcia && I don't really
> understand the tuple business.  We need pcmcia people to pitch in.
> 
> Thanks.
> 
> -- 
> tejun
> 
