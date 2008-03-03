Return-Path: <linux-kernel-owner+w=401wt.eu-S1760203AbYCCVlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760203AbYCCVlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755681AbYCCVlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:41:44 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56649 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754296AbYCCVln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:41:43 -0500
Date: Mon, 3 Mar 2008 21:29:55 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: benh@kernel.crashing.org
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: Weirdness in pci_read_bases()
Message-ID: <20080303212955.1c0f29c7@core>
In-Reply-To: <1204576954.21545.10.camel@pasglop>
References: <1204252667.15052.402.camel@pasglop>
	<200803031112.27658.jbarnes@virtuousgeek.org>
	<1204576954.21545.10.camel@pasglop>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The main question regarding 0 in a BAR is do we know of devices that
> consider it as "disabled" and don't operate/decode 0 ? (That would be
> gross and out of spec but who knows...)

In the PC world it never gets tested so it might be wise to be cautious.

> But that can be solved, using something akin to IORESOURCE_UNSET, like
> we do on powerpc, generalizing it, and having an x86-specific quirk set
> it on anything that comes up with resource->start == 0.

And add pci_resource_unassigned() to wrap it nicely. That would
definitely be a good thing as we have confusion right now and it has
turned up in the real world.

Alan
