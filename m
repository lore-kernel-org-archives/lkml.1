Return-Path: <linux-kernel-owner+w=401wt.eu-S1762335AbXGJH2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762335AbXGJH2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 03:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbXGJH2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 03:28:43 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57216 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751971AbXGJH2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 03:28:42 -0400
Date: Tue, 10 Jul 2007 00:28:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Graham Murray <gmurray@webwayone.co.uk>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Specialix SX cards not detected in kernels >=2.6.20
Message-Id: <20070710002807.e6f4bb19.akpm@linux-foundation.org>
In-Reply-To: <7wlkdp8yoe.fsf@gmdev.webwayone.co.uk>
References: <7wlkdp8yoe.fsf@gmdev.webwayone.co.uk>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Jul 2007 15:00:17 +0100 Graham Murray <gmurray@webwayone.co.uk> wrote:

> There were multiple changes to the char/sx.c driver in kernel 2.6.20.

Let's cc Jiri.

> In
> kernels 2.6.19 and earlier, the SX multiport serial card works OK, but
> in 2.6.20 and later the driver does not seemt to detect the presence of
> the card. 
> 
> I have enabled sx_debug=-1 and added some printk statements to try and
> detect why the card is not detected. These show that sx_init is entered
> and within that function the call to pci_register_driver returns 0. I do
> not see any other routines in the driver being entered either at startup
> (when the module is loaded, which indicates that the system recognises
> the PCI ID) or when running 'modprobe sx'. In particular, sx_pci_probe()
> is never entered.
> 
> lspci -vv for the card
> 
>  10:01.0 Communication controller: Specialix Research Ltd. PCI_9050
> 	Subsystem: Specialix Research Ltd. Unknown device 0300
> 	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Interrupt: pin A routed to IRQ 11
> 	Region 0: Memory at df2ffc00 (32-bit, non-prefetchable) [size=128]
> 	Region 1: I/O ports at 9c80 [size=128]
> 	Region 2: Memory at df200000 (32-bit, non-prefetchable) [size=512K]
> 	Region 3: Memory at df280000 (32-bit, non-prefetchable) [size=256K]
> 
> I have enabled CONFIG_PCI_DEBUG and see the following:-
> 
> PCI: Probing PCI hardware (bus 00)
> ...
> PCI: Scanning bus 0000:10
> PCI: Found 0000:10:01.0 [11cb/2000] 000780 00
> PCI: Calling quirk c0362041 for 0000:10:01.0
> ...
> PCI: Calling quirk c027a199 for 0000:10:01.0
> PCI: Calling quirk c033cb9e for 0000:10:01.0
> 
> 
> Where should I look for and how should I obtain further debug to
> determine where the problem lies?
> 

A git-bisect should find this fairly quickly.
