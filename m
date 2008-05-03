Return-Path: <linux-kernel-owner+w=401wt.eu-S1759872AbYECCnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759872AbYECCnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 22:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756256AbYECCnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 22:43:24 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:24591 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234AbYECCnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 22:43:23 -0400
Date: Fri, 02 May 2008 20:42:53 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: 2.6.23.17 & 2.6.24.5 and maybe earlier: pata_marvell: need to
 disable DMA to get rid of '(ATA bus error)', 'ata7.00: status: { DRDY ERR }',
 'ata7.00: error: { ICRC ABRT }'
In-reply-to: <fa.qfeYSQtlsXzGvFvBQEdF9TFFpNg@ifi.uio.no>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jan Engelhardt <jengelh@medozas.de>,
       =?windows-1252?Q?Martin_MOKREJ?= =?windows-1252?Q?=8A?= 
	<mmokrejs@ribosome.natur.cuni.cz>,
       LKML <linux-kernel@vger.kernel.org>
Message-id: <481BD12D.1030406@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
References: <fa.+9Q+WQnyiYTlpbXVIzn6aT2/gS0@ifi.uio.no>
 <fa.fKUfeQYS9BFD60fOMormQ25ard4@ifi.uio.no>
 <fa.QYXSW2xjSxf6xnmd0rQGJhHLnrc@ifi.uio.no>
 <fa.qfeYSQtlsXzGvFvBQEdF9TFFpNg@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>> libata.dma=3 will stop DMA being used for CF devices (except those that
>>> decide to pretend to be ATA classes). This one comes up a lot as many CF
>>> adapters are simply not adequate for UDMA.
>> Perhaps the kernel could do this automatically once it sees the
>> status code?
> 
> We then hurt all the people with perfectly good working UDMA CF devices.
> The kernel will eventually fall back from UDMA to PIO but it favours
> working hardware by default.

I suspect they meant fall back on seeing the ABRT/ICRC error combination 
- which it does, eventually. Falling back on one occurrence would be too 
aggressive, though, as they can happen once in a blue moon, so there's 
little reason to slow down a working setup forever because of it..
