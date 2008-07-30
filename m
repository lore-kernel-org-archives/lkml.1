Return-Path: <linux-kernel-owner+w=401wt.eu-S1760056AbYG3LHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760056AbYG3LHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 07:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbYG3LH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 07:07:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56479 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751812AbYG3LHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 07:07:25 -0400
Date: Wed, 30 Jul 2008 11:49:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: gshan <gshan@alcatel-lucent.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: PIIX4: DMA timeout issue
Message-ID: <20080730114934.5a593cf4@lxorguk.ukuu.org.uk>
In-Reply-To: <48902EB5.8070102@alcatel-lucent.com>
References: <488ED837.2060509@alcatel-lucent.com>
	<488F1C6C.9000002@garzik.org>
	<48902EB5.8070102@alcatel-lucent.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Jeff, I tried moving to ATA driver for PIIX4 today and found ATA need to 
> request
> 2 IRQ lines, each one of them belongs to primary and secondary channel. 
> However,
> when I make PIIX4 worked under IDE driver, it also need to request one 
> IRQ for "ide1".
> So it's necessary to disable secondary channel manually?

If the controller is in legacy mode then libata will claim the interrupt
lines for all channels which are enabled even if there are no devices on
them. This is neccessary for device hot or warm plug support as new disks
could appear on empty channels.
> 
> Another question is my PIIX4 chip has device ID + vendor ID of 
> 0x71108086. But it finally
> was mapped to following ID of piix_pci_tbl[] array. Device of 0x7110 and 
> 0x7010 should
> be quit different, right?

Yes - I find tht one very odd - you might need to debug a bit to see what
is occuring if you think this is the case.

Alan
