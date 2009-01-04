Return-Path: <linux-kernel-owner+w=401wt.eu-S1757029AbZADVot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029AbZADVot (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 16:44:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbZADVoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 16:44:37 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59961 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751541AbZADVog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 16:44:36 -0500
Date: Sun, 4 Jan 2009 21:44:38 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, fweisbec@gmail.com, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 0/4] Fastboot revisited: Asynchronous function calls
Message-ID: <20090104214438.196ff4ff@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.0901041009060.3179@localhost.localdomain>
References: <20090104092430.7ffd2c41@infradead.org>
	<alpine.LFD.2.00.0901041009060.3179@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I _think_ it's the irq auto-probing, but that's just a guess. The 8250 
> driver does some historical crud, like
> 
> 	probe_irq_off(probe_irq_on());
> 
> to get rid of any pending irq's, but that should be entirely pointless 
> these days. I bet that line basically goes back to pre-history, before we 
> made the auto-probing much stabler.

For non ISA boxes we shouldn't be - but this old code. The IRQ for the
built in ports is defined by convention, in the BIOS PnP tables or with
ACPI in the ACPI tables. So we shouldn't even be autoprobing the IRQ.

We *do* have to wait one transmission timeout or so to detect buggy uarts
but in theory that could be moved down into the open path.

Alan

