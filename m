Return-Path: <linux-kernel-owner+w=401wt.eu-S1761485AbYDVILU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761485AbYDVILU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 04:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756892AbYDVILJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 04:11:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:56253 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755883AbYDVILH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 04:11:07 -0400
Subject: Re: [PATCH 05/15] drivers/char: minor irq handler cleanups
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Cc: Jeff Garzik <jeff@garzik.org>, alan@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080419060011.GA29321@bitwizard.nl>
References: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com>
	 <e3b010fa8e3bc3a5e386759f01f69c80918923e7.1208559659.git.jgarzik@redhat.com>
	 <20080419060011.GA29321@bitwizard.nl>
Content-Type: text/plain
Date: Tue, 22 Apr 2008 18:05:40 +1000
Message-Id: <1208851540.9640.95.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-04-19 at 08:00 +0200, Rogier Wolff wrote:
> 
> You added a "XXX Using free_irq in the interrupt is not wise!". When I
> wrote that code, I didn't know about this. These lines triggered when
> the level-triggered PCI interrupt stuck "active" this would mean that
> NO userspace code would get executed anymore: Hard lock up. Difficult
> to debug. This happend a few times during development when the code
> behind the "if (!polled)": "tell the hardware we've seen the
> interrupt" didn't work. On the other hand, some failures in the field
> have triggered this. So I think it's wise to keep it in. Disabling the
> interrupt on the card is not an option, because that's exactly what
> this is supposed to catch: We're unable to make the card stop
> interrupting the CPU.
> 
> Note that it also doesn't work (i.e. hard lock of the machine) if some
> other driver is using the same interupt.

You should let the kernel generic code deal with the runaway interrupt,
it should be capable of doing so nowadays pretty reliably.

free_irq() is definitely not going to be happy when it start messing
with /proc from an interrupt... It will at least give you a WARN_ON.

Ben.


