Return-Path: <linux-kernel-owner+w=401wt.eu-S1752560AbXBKBmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbXBKBmu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 20:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbXBKBmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 20:42:49 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48079 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752577AbXBKBmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 20:42:49 -0500
Date: Sun, 11 Feb 2007 01:56:19 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Komuro <komurojun-mbn@nifty.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG]  PATA_PCMCIA does not work
Message-ID: <20070211015619.39d3e29a@localhost.localdomain>
In-Reply-To: <20070211101537.e40fa309.komurojun-mbn@nifty.com>
References: <20061217212752.d93816b4.komurojun-mbn@nifty.com>
	<20061217040222.GD17561@ftp.linux.org.uk>
	<20070211101537.e40fa309.komurojun-mbn@nifty.com>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The PATA_PCMCIA driver does not work.
> The kernel version is 2.6.20.
> Does anyone test this driver?

Yes it gets regularly tested and works reliably on my test harware. I am
however using standards compliant hardware.

> [pata_pcmcia dmesg]
> ata1.00: CFA, max PIO0, 20480 sectors: LBA 
> ata1.00: ata1: dev 0 multi count 0
> ata1.01: CFA, max PIO0, 20480 sectors: LBA 
> ata1.01: ata1: dev 1 multi count 0

Do you have two cards here ?

> ata1.00: failed to set xfermode (err_mask=0x1)

This looks like you have both a CF adapter which does not properly handle
drive select, and a CFA card which incorrectly only allows a set
features/xfer mode to be done once.

The old IDE layer has a workaround to try and detect the former bug
(which sadly looks like it will be needed in libata), and through sheer
ignorance happens not to break in the second case.

Your card should work with the current -mm driver although not entirely
for the right reasons. Given you have such a marvellously buggy set of
hardware can I send you some test patches to try ?

Alan
