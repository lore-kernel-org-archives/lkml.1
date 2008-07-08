Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbYGHQ0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbYGHQ0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 12:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799AbYGHQ0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 12:26:37 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63908 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753661AbYGHQ0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 12:26:36 -0400
Date: Tue, 8 Jul 2008 17:25:26 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Andreas Herrmann <andreas.herrmann3@amd.com>, Ingo Molnar <mingo@elte.hu>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <lenb@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-next@vger.kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] acpi: Disable IRQ 0 through I/O APIC for some HP
 systems
In-Reply-To: <200807081727.40605.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.55.0807081646270.27931@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0807010055070.30785@cliff.in.clinika.pl>
 <20080708112402.GA2301@alberich.amd.com> <200807081727.40605.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2008, Rafael J. Wysocki wrote:

> > (B) The current approach to setup timer as ExtINT.
[...]
> > (B) ??? who tested this, Rafael
> 
> Yes, I tested this.

 There is some confusion here apparently -- you certainly have not tested
the timer as an ExtINTA interrupt during the course of this discussion,
because the "8259A Virtual Wire" through the local APIC has always worked
for you.  ExtINTA would be the next, fourth and final attempt before a
panic().

 For a reference, here is the list of configurations of the 8254 timer
interrupt in the order they are tried:

1. Native I/O APIC interrupt.

2. "8259A Virtual Wire" through the I/O APIC.

3. "8259A Virtual Wire" through the local APIC of the bootstrap processor.

4. ExtINTA ("Virtual Wire") through the local APIC of the BSP.

The configurations #1 and #2 are only tried if the firmware has supplied
information about how the IRQ0 or 8259A have been wired.  The #4 is only
reached in very rare cases where there is some special glue logic between
the 8259A and the APIC (seen before as a workaround for broken hardware;  
unlock_ExtINT_logic() is needed for that) or a given implementation of the
8259A is not a full one (hypothetical).

  Maciej
