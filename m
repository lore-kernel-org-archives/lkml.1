Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbXLJL2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbXLJL2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 06:28:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbXLJL2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 06:28:45 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38616 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751337AbXLJL2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 06:28:44 -0500
Date: Mon, 10 Dec 2007 11:20:50 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: benh@kernel.crashing.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: Please revert: PCI: fix IDE legacy mode resources
Message-ID: <20071210112050.0bd6ac28@the-village.bc.nu>
In-Reply-To: <1197260962.6563.46.camel@pasglop>
References: <200710122305.l9CN5tFI008240@hera.kernel.org>
	<1196899818.7033.11.camel@pasglop>
	<200712060434.lB64YUtc023934@po-mbox305.hop.2iij.net>
	<1196917447.7033.17.camel@pasglop>
	<200712060558.lB65wAFu016256@po-mbox304.hop.2iij.net>
	<1196922262.7033.33.camel@pasglop>
	<20071209021231.GA13729@linux-mips.org>
	<1197185091.6572.38.camel@pasglop>
	<1197193794.6572.52.camel@pasglop>
	<20071209133812.2d305a02@the-village.bc.nu>
	<1197230609.6563.6.camel@pasglop>
	<20071209222335.70e52be3@the-village.bc.nu>
	<1197260962.6563.46.camel@pasglop>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Dec 2007 15:29:22 +1100
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> powerpc: Fix IDE legacy vs. native fixups
> 
> PowerMac and CHRP/BriQ platforms have quirks to switch some IDE
> controllers from legacy mode to fully native mode. Those quirks
> however will not work properly anymore due to a change to the
> generic code to better handle legacy IDE resources.
> 
> This fixes it by moving those quirk to "early" quirks (so they
> run before resources are probed for the devices) and clearing
> all BARs after the conversion to force a reallocation of sane
> values.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Acked-by: Alan Cox <alan@redhat.com>

> To be totally correct, we still need to also revert
> commit fd6e732186ab522c812ab19c2c5e5befb8ec8115 which
> is bogus.

Agreed but that would cause an revert on an obscure MIPS platform which
is apparently now a thoughtcrime ;)

> Linus, can you still apply this to 2.6.24 ? I would also like the
> above (fd6e...) reverted as so far, nobody have come up with a demonstration
> that it's not bogus.

Ack the revert too.

The MIPS needs sorting out differently.
