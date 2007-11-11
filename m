Return-Path: <linux-kernel-owner+w=401wt.eu-S1757231AbXKKQhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231AbXKKQhH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 11:37:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbXKKQgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 11:36:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764AbXKKQgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 11:36:54 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071111151835.7917a565@the-village.bc.nu>
References: <20071111151835.7917a565@the-village.bc.nu> <20071110200935.60d375de@the-village.bc.nu> <20071109195303.edbdc631.akpm@linux-foundation.org> <20071109153432.20803.69832.stgit@warthog.procyon.org.uk> <20071109153458.20803.10594.stgit@warthog.procyon.org.uk> <24343.1194697130@redhat.com> <1658.1194792517@redhat.com> 
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-am33-list@redhat.com
Subject: Re: [PATCH 5/6] MN10300: Add the MN10300/AM33 architecture to the kernel [try #5]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Sun, 11 Nov 2007 16:36:44 +0000
Message-ID: <2414.1194799004@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> Ok so these are not addresses but magic registers in the processor ? Then
> I guess volatile makes complete sense.

They are such magic registers, though of various grades.

Some are part of the CPU core and affect things like CPU core itself, CPU
caches, MMU/TLB and exceptions/interrupts.  Others are on-silicon devices such
as the serial ports, the bus controller, the SDRAM controller.

> For PIO (virtual DMA or otherwise) the locking does that. Because
> spin_unlock and spin_lock are compiler barriers the need to use volatile
> shouldn't normally be there. If you are doing it via asm without locks
> then I would expect atomic_t because the sematics of volatile are
> horribly vague on their own ?

Using memory barriers ought to be good enough for the ring buffer.  There
aren't actually any atomic ops available other than bit-set and bit-clear.

David
