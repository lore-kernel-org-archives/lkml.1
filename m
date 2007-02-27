Return-Path: <linux-kernel-owner+w=401wt.eu-S1751388AbXB0Gsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388AbXB0Gsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 01:48:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbXB0Gsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 01:48:46 -0500
Received: from gate.crashing.org ([63.228.1.57]:49840 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbXB0Gsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 01:48:45 -0500
Subject: Re: Make sure we populate the initroot filesystem late enough
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linuxppc-dev@ozlabs.org,
       LKML <linux-kernel@vger.kernel.org>, Milton Miller <miltonm@bga.com>
In-Reply-To: <Pine.LNX.4.64.0702261315080.12485@woody.linux-foundation.org>
References: <1172462466.3971.46.camel@shinybook.infradead.org>
	 <35684e789e5c2447eab393c8946efcb9@bga.com>
	 <1172523468.3560.2.camel@shinybook.infradead.org>
	 <Pine.LNX.4.64.0702261315080.12485@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 27 Feb 2007 07:46:39 +0100
Message-Id: <1172558799.11949.41.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> USB controller issues? We used to have these really hard-to-debug problems 
> with the USB controller being active and having had the BIOS set up the 
> command queues etc. Really subtle. It's why we now have PCI quirks for 
> shutting up (most) USB controllers very early.

On powermacs or powerbooks, the USB controller is shut down by the
firmware when we call the "quiesce" OF call from prom_init.c, which
happens before the kernel relocates itself to 0 and takes over memory.
Unless we fucked up something in there, I wouldn't expect that to be the
cause.
 
> If there is some USB controller that we miss, or that sets up its command 
> chain to some unexpected area (so that USB is active and corrupting memory 
> even very early on), that could explain it.

Did we setup the OHCI controller when the crash happen ? Maybe we broke
something subtle in the USB stack ?

Ben.


