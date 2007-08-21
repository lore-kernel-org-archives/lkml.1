Return-Path: <linux-kernel-owner+w=401wt.eu-S1762245AbXHURJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762245AbXHURJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 13:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759457AbXHURJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 13:09:21 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:40115 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757755AbXHURJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 13:09:20 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: sata_via: write errors on PATA drive connected to VT6421
Date: Tue, 21 Aug 2007 19:09:30 +0200
User-Agent: KMail/1.9.7
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200708202242.07290.linux@rainbow-software.org> <20070821132731.6bf10b50@the-village.bc.nu>
In-Reply-To: <20070821132731.6bf10b50@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708211909.30652.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 August 2007 14:27:31 Alan Cox wrote:
> > The transfer mode decreases from UDMA/100 to UDMA/66 and then UDMA/33 but
> > it doesn't help at all. The drive itself is fine, the problems also
> > appear with
>
> Does it settle at UDMA33 or keep going down lower ?

It does not go below UDMA33. 
dd if=/dev/zero of=some.file bs=131072 count=1024 takes 526 seconds (amazing 
transfer rate 255KB/s) with system being unresponsive most of the time.

Commenting out the UDMA support in sata_via.c (.udma_mask and .set_dmamode for 
PATA port) causes the driver to run in PIO4 mode which seems to work without 
errors but slowly (3MB/s with 100% CPU load).

-- 
Ondrej Zary
