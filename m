Return-Path: <linux-kernel-owner+w=401wt.eu-S932895AbXGXU5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895AbXGXU5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 16:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760312AbXGXU5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 16:57:39 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:55631 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758746AbXGXU5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 16:57:38 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to platform devices - broke my serial console
Date: Tue, 24 Jul 2007 14:56:35 -0600
User-Agent: KMail/1.9.6
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       =?iso-8859-1?q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr> <200707241434.32374.bjorn.helgaas@hp.com> <46A663CA.3050000@garzik.org>
In-Reply-To: <46A663CA.3050000@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707241456.35769.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 July 2007 02:40:42 pm Jeff Garzik wrote:
> Please go back and fix the original issue!
> 
> If you are having problems caused by double-probing, the fix is NOT to 
> remove one the probes.  The fix is to ensure use of proper resource 
> reservation, and in some cases, add co-driver-awareness.

Keith Owens did report an issue with the double probe, but I confess
I don't fully understand it.

The real problem was that the serial driver claimed a non-serial
device.  On many laptops, there's an IR device at 0x3e8, IRQ 3.
The serial driver claimed this as ttyS2, using IRQ 4.  So if you
wanted to use the IR device, you had to either:

  - use setserial to make the serial driver forget about ttyS2
    so an IR driver could claim it, or

  - use setserial to change the IRQ to 3 and just use the device
    in SIR mode, which is 16550-compatible so you can use the
    serial driver

I didn't express that very clearly in the changelog.

