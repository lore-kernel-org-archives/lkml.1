Return-Path: <linux-kernel-owner+w=401wt.eu-S1755023AbZEQUGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023AbZEQUGc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 16:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762AbZEQUGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 16:06:20 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48539 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250AbZEQUGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 16:06:19 -0400
Message-ID: <4A106E22.1010705@pobox.com>
Date: Sun, 17 May 2009 16:05:54 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Robert Hancock <hancockrwd@gmail.com>, Tejun Heo <htejun@gmail.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       alan@lxorguk.ukuu.org.uk, flar@allandria.com,
       schmitz@biophys.uni-duesseldorf.de, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, takata@linux-m32r.org, geert@linux-m68k.org,
       linux-m68k@vger.kernel.org, ysato@users.sourceforge.jp
Subject: Re: [PATCH] ata: libata depends on HAS_DMA
References: <20090513043409.GA13577@cynthia.pants.nu> <200905151355.09888.arnd@arndb.de> <4A0FD229.9010401@gmail.com> <200905172138.55145.arnd@arndb.de>
In-Reply-To: <200905172138.55145.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Sunday 17 May 2009, Robert Hancock wrote:
> Please reread my explanations above and your own reply from 
> last thursday. The case is entirely theoretical, as all platforms
> (except microblaze, which is getting fixed) either set HAS_DMA or
> don't allow building ATA drivers anyway. Platforms that don't support
> DMA can just define CONFIG_HAS_DMA and do what you suggested:
> 
> On Thursday 14 May 2009, Robert Hancock wrote:
>> Wouldn't the easiest solution be to just dummy out the DMA API calls on 
>> this platform to always fail? That would fix these compile problems..


That's what needs to happen.  We provide no-op functions for e.g. PCI 
and x86 DMI, for platforms where this support does not exist.

Pretty much all architectures support some form of ATA.  m68k, m32r, 
h8300 and microblaze all have IDE interface, which means that libata 
needs to work on that platform.

The only !ATA arch in the entire kernel is s390, AFAICT.

	Jeff



