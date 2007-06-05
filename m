Return-Path: <linux-kernel-owner+w=401wt.eu-S1765291AbXFEQDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765291AbXFEQDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 12:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755603AbXFEQDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 12:03:08 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45023 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750837AbXFEQDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 12:03:07 -0400
Date: Tue, 5 Jun 2007 17:07:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bzolnier@gmail.com, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 3/6] lguest suppress IDE probing
Message-ID: <20070605170747.256f6631@the-village.bc.nu>
In-Reply-To: <1181055483.14054.40.camel@localhost.localdomain>
References: <1181055308.14054.36.camel@localhost.localdomain>
	<1181055396.14054.38.camel@localhost.localdomain>
	<1181055483.14054.40.camel@localhost.localdomain>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jun 2007 00:58:03 +1000
Rusty Russell <rusty@rustcorp.com.au> wrote:

> The IDE probe is the slowest part of boot: by suppressing it we cut
> boot from from 3 seconds to half a second.

NAK NAK NAK NAK NAK

> AFAICT, the commandline is the easiest way to suppress the probing.

Gaa ... Rusty surely you have more taste than that.

See include/asm-foo/ide.h

Add an lguest check to go with the pci check and for the lguest case just
say "no controllers"

Better yet just don't compile in the old IDE stuff, lguest doesn't have a
PCI or ISA bus anyway.

Alternatively make the IDE I/O space return 0xFF and it'll skip them
anyway.

Alan
