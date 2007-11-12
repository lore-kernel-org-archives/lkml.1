Return-Path: <linux-kernel-owner+w=401wt.eu-S1758654AbXKLMT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654AbXKLMT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 07:19:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbXKLMTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 07:19:18 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbXKLMTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 07:19:17 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071111164244.52a17203@the-village.bc.nu>
References: <20071111164244.52a17203@the-village.bc.nu> <20071111151835.7917a565@the-village.bc.nu> <20071110200935.60d375de@the-village.bc.nu> <20071109195303.edbdc631.akpm@linux-foundation.org> <20071109153432.20803.69832.stgit@warthog.procyon.org.uk> <20071109153458.20803.10594.stgit@warthog.procyon.org.uk> <24343.1194697130@redhat.com> <1658.1194792517@redhat.com> <2414.1194799004@redhat.com> 
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-am33-list@redhat.com
Subject: Re: [PATCH 5/6] MN10300: Add the MN10300/AM33 architecture to the kernel [try #5]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Mon, 12 Nov 2007 12:19:04 +0000
Message-ID: <4094.1194869944@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Some are part of the CPU core and affect things like CPU core itself, CPU
> > caches, MMU/TLB and exceptions/interrupts.  Others are on-silicon devices
> > such as the serial ports, the bus controller, the SDRAM controller.
> 
> How are they addressed - as CPU registers or as memory/IO space ?

Well, they're all accessed as memory locations within a special range of
addresses (all of 0xCxxxxxxx and 0xDxxxxxxx).  This includes the magic CPU
registers.  This is hard coded by the CPU before the MMU gets its hands on the
addresses, AFAIK.

I also wondered what about the boot wrapper (the kernel decompressor):  Is that
permitted to use readb() and co?

David
