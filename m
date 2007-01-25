Return-Path: <linux-kernel-owner+w=401wt.eu-S1030255AbXAYQRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030255AbXAYQRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 11:17:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030272AbXAYQRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 11:17:32 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:37958 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030255AbXAYQRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 11:17:31 -0500
Message-ID: <45B8D810.3030501@pobox.com>
Date: Thu, 25 Jan 2007 11:17:20 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Alan <alan@lxorguk.ukuu.org.uk>, torvalds@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata-sff: Don't call bmdma_stop on non DMA capable
 controllers
References: <20070125150905.652f9ce2@localhost.localdomain> <1169741658.3593.98.camel@shinybook.infradead.org>
In-Reply-To: <1169741658.3593.98.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> On Thu, 2007-01-25 at 15:09 +0000, Alan wrote:
>> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-rc4-mm1/drivers/ata/libata-sff.c linux-2.6.20-rc4-mm1/drivers/ata/libata-sff.c
>> --- linux.vanilla-2.6.20-rc4-mm1/drivers/ata/libata-sff.c       2007-01-22 16:26:50.000000000 +0000
>> +++ linux-2.6.20-rc4-mm1/drivers/ata/libata-sff.c       2007-01-24 17:31:40.000000000 +0000
>> @@ -827,7 +827,8 @@
>>   */
>>  void ata_bmdma_post_internal_cmd(struct ata_queued_cmd *qc)
>>  {
>> -       ata_bmdma_stop(qc);
>> +       if (qc->ap->ioaddr.bmdma_addr)
>> +               ata_bmdma_stop(qc);
>>  }
> 
> But what if the bmdma_addr _is_ zero? Please, let's not allow the "zero
> is not a valid number" braindamage to spread any further than the IRQ
> setup it's already broken.

Read the code...  This test is already widely in use in libata.

	Jeff



