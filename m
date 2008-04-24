Return-Path: <linux-kernel-owner+w=401wt.eu-S1758189AbYDXPCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189AbYDXPCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753340AbYDXPCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:02:03 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53328 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752628AbYDXPCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:02:01 -0400
Date: Thu, 24 Apr 2008 15:32:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Michael Buesch <mb@bu3sch.de>
Cc: Andi Kleen <andi@firstfloor.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>, vojtech@suse.cz,
       muli@il.ibm.com, jdmason@kudzu.us, tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH RFC] x86: Fix 64-bit DMA masks on VIA
Message-ID: <20080424153240.33b5300c@the-village.bc.nu>
In-Reply-To: <200804241606.00883.mb@bu3sch.de>
References: <200804232055.13102.mb@bu3sch.de>
	<87mynjgyg9.fsf@basil.nowhere.org>
	<200804241606.00883.mb@bu3sch.de>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2008 16:06:00 +0200
Michael Buesch <mb@bu3sch.de> wrote:

> On Thursday 24 April 2008 15:43:50 Andi Kleen wrote:
> > Michael Buesch <mb@bu3sch.de> writes:
> > 
> > > This untested patch is supposed to fix DMAing on some VIA boards.
> > > Currently the DMA subsystem returns an error, if the driver does
> > > tell that it supports a 64bit DMA mask. So the driver probing
> > > would fail in that case. 
> > 
> > The driver is broken then. It is supposed to retry with a small
> > mask on an error. Please fix the driver.
> 
> I already added a workaround to the driver.
> Why do we need to workaround this in _every_ driver? (Note that _every_
> driver supporting a 64bit mask is affected). Why not fix it in the DMA layer?

Some hardware wants to know it can get a given DMA mask or failure. I
agree however that a "pci_prefer_64bit_dma(pdev)" function would be a
good patch for someone to submit tot he PCI layer code.

Alan
