Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbYJUCp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbYJUCp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 22:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbYJUCpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 22:45:16 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:57144 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751839AbYJUCpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 22:45:14 -0400
X-Greylist: delayed 2159 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Oct 2008 22:45:12 EDT
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200810210207.m9L275nQ031086@turbo.physics.adelaide.edu.au>
Subject: Re: [RFC patch] genirq threading for ehci, ohci and uhci USB hosts
To: sven@thebigcorporation.com (Sven-Thorsten Dietrich)
Date: Tue, 21 Oct 2008 11:37:05 +0930 (CST)
Cc: tglx@linutronix.de (Thomas Gleixner),
       jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       linux-kernel@vger.kernel.org (LKML), torvalds@osdl.org (Linus Torvalds),
       akpm@linux-foundation.org (Andrew Morton), mingo@elte.hu (Ingo Molnar),
       arjan@infradead.org (Arjan van de Veen),
       benh@kernel.crashing.org (Benjamin Herrenschmidt),
       rostedt@goodmis.org (Steven Rostedt),
       jonathan@jonmasters.org (Jon Masters),
       slert-devel@suse.de (slert-devel), dwalker@soe.ucsc.edu (Daniel Walker),
       linux-rt-users@vger.kernel.org (RT Users List)
In-Reply-To: <1224552779.8278.24.camel@dd> from "Sven-Thorsten Dietrich" at Oct 20, 2008 06:32:59 PM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > This patch series implements support for threaded irq handlers for the
> > generic IRQ layer.
>
> Subject: genirq threading for ehci, ohci and uhci USB hosts.
> 
> This is a functional POC for partitioning of the USB interrupt handlers into
> a quickcheck function and a threaded main-handler function.
> :
> The ieee1394/ohci1394.c is a bit more problematic, since it does not use
> struct usb_hcd, and therefore another place for the status cache must be found,
> in struct ti_ohci presumably. 
> I will send a separate patch for ieee1394/ohci1394.c after looking at it more.

Thanks for sending this through; I will endeavour to test it over the coming
days.  I'll also see if I can test it for the case where USB and ieee1394
share IRQs.  Even though ieee1394 isn't done yet these changes should
prevent the USB-related problems we've seen in FFADO when USB shares the
firewire IRQ.

Having said that, the forthcoming ohci1394.c patch will also be interesting
since that is the other area which will greatly benefit FFADO.

Regards
  jonathan
