Return-Path: <linux-kernel-owner+w=401wt.eu-S1762148AbXIKBu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762148AbXIKBu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 21:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760993AbXIKBus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 21:50:48 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43236 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756628AbXIKBur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 21:50:47 -0400
Message-ID: <46E5F471.3040104@garzik.org>
Date: Mon, 10 Sep 2007 21:50:41 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Laurent Riffard <laurent.riffard@free.fr>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc4-mm1: broke pata_via cable detection
References: <20070831215822.26e1432b.akpm@linux-foundation.org> <46DB088C.6080907@free.fr>
In-Reply-To: <46DB088C.6080907@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Riffard wrote:
> Le 01.09.2007 06:58, Andrew Morton a écrit :
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc4/2.6.23-rc4-mm1/
> [...]
>> +libata-correct-handling-of-srst-reset-sequences.patch
> [...]
> 
> Alan,
> 
> libata-correct-handling-of-srst-reset-sequences.patch broke 80-wire
> cable detection on pata_via driver:
> 
>> $ dmesg | grep ata1
>> ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xb800 irq 14
>> ata1.00: ATA-5: ST340016A, 3.75, max UDMA/100
>> ata1.00: 78165360 sectors, multi 16: LBA 
>> ata1.01: ATA-7: Maxtor 6Y080L0, YAR41BW0, max UDMA/133
>> ata1.01: 160086528 sectors, multi 16: LBA 
>> ata1.00: limited to UDMA/33 due to 40-wire cable
>> ata1.01: limited to UDMA/33 due to 40-wire cable
>> ata1.00: configured for UDMA/33
>> ata1.01: configured for UDMA/33
> 
> 2.6.23-rc3-mm1 and 2.6.23-rc4 work fine (ata1 devices are configured
> for UDMA/100).
> 
> Few weeks ago, I wrote a patch to solve a wrong cable detection
> problem after suspend-to-disk/resume, and it solves this problem
> too. Is it the right way to go ?
> 
> 
> 
> via_do_set_mode overwrites 80-wire cable detection bits. Let's
> preserve them.
> 
> Signed-off-by: Laurent Riffard <laurent.riffard@free.fr>

applied


