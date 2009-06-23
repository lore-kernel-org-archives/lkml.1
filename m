Return-Path: <linux-kernel-owner+w=401wt.eu-S1758051AbZFWIlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051AbZFWIlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 04:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbZFWIkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 04:40:45 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44321 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752512AbZFWIkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 04:40:43 -0400
Date: Tue, 23 Jun 2009 09:42:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Frans Pop <elendil@planet.nl>
Cc: David Miller <davem@davemloft.net>, bzolnier@gmail.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cs5520: add missing IRQ setup for the second port
Message-ID: <20090623094206.4d1f1b5b@lxorguk.ukuu.org.uk>
In-Reply-To: <200906230158.12805.elendil@planet.nl>
References: <200906221348.02632.bzolnier@gmail.com>
	<200906221348.02632.bzolnier@gmail.com>
	<20090622.163136.246300819.davem@davemloft.net>
	<200906230158.12805.elendil@planet.nl>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 01:58:11 +0200
Frans Pop <elendil@planet.nl> wrote:

> David Miller wrote:
> > ide_pci_setup_ports() would loop over the available ports, one
> > by one, recording IRQ numbers increasingly from the one passed
> > in as "pciirq".
> 
> I looked at the commit and at the code and called functions several times 
> (just out of curiosity), but have been completely unable to find where 
> that increase of pciirq actually happened.
> AFAICT ide_pci_setup_ports() just passed it on to ide_hw_configure() and 
> all that did was 'hw->irq = irq', so AFAICT in the old case both ports 
> would get the *same* IRQ, and not consecutive ones.

The cs5520 isn't a standard IDE controller in the first place and doesn't
have two channels anyway. It's special as it uses non standard bar
registers on the bridge to access the virtual DMA region, PCI registers
on the bridge to set timings (much like say MPIIX) and standard I/O ports
for the ATA accesses.

Alan
