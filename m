Return-Path: <linux-kernel-owner+w=401wt.eu-S1755792AbYAAQGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792AbYAAQGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 11:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753923AbYAAQGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 11:06:09 -0500
Received: from rtr.ca ([76.10.145.34]:1132 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753889AbYAAQGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 11:06:07 -0500
Message-ID: <477A64EC.40401@rtr.ca>
Date: Tue, 01 Jan 2008 11:06:04 -0500
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
Cc: Linda Walsh <lkml@tlinx.org>, LKML <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>
Subject: Re: SATA kernel-buffered read VERY slow (not raid, Promise TX300
 card); 2.6.23.1(vanilla)
References: <fa.6TIOCGhBpW0r4XW9rqR+Ad8P+Js@ifi.uio.no> <4777E08C.4000603@shaw.ca> <4779870E.5070507@tlinx.org> <47798A28.2010301@shaw.ca>
In-Reply-To: <47798A28.2010301@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>>> I wanted to use the newer pata support in the SATA lib, but
>>>> got frustrated "real fast" by the lack of disk-parameter support
>>>> in the new pata library (hdparm is mostly broken; and the SCSI
>>>> utils aren't really intended for ATA(or SATA?) disks using the
>>>> SCSI interface.
...

Most hdparm flags work perfectly fine with libata,
unless perhaps you're using Fedora, which for some odd
reason was using a 2+ year old copy of hdparm until
very very recently.

As others noted, the only things not working are things that
libata itself chooses not to allow from userspace because libata
has better low-level drivers that can set those things automatically
in a more reliable fashion than we ever could with drivers/ide:
  DMA, 32-bit I/O, PIO/DMA xfer rates, hotplug stuff.

The rest, including acoustic and power-saving parameters,
work just fine with libata.

Cheers
