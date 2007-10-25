Return-Path: <linux-kernel-owner+w=401wt.eu-S1758254AbXJYM1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254AbXJYM1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 08:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbXJYM1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 08:27:43 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55562 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752738AbXJYM1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 08:27:42 -0400
Date: Thu, 25 Oct 2007 13:29:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Jeff Garzik <jeff@garzik.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
Subject: Re: [patch 2.6.24-rc1] resource_len() utility function
Message-ID: <20071025132939.3fd010f9@the-village.bc.nu>
In-Reply-To: <200710242138.23252.david-b@pacbell.net>
References: <200710241820.52376.david-b@pacbell.net>
	<200710241947.15129.david-b@pacbell.net>
	<4720118F.5050906@garzik.org>
	<200710242138.23252.david-b@pacbell.net>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> So you'd suggest having search utilities (as with platform_bus)
> returning resource indices not resources?

That seems a bad idea to me

> Thing is, BARs are usually well defined, but when folk glue
> resources together they use whatever order is convenient on
> that particular platform.  And different platforms can have
> different numbers and types of resources, etc.

Far better I think that pci_ functions that take BAR values end up as
wrappers of the form

	pci_iomap(pdev, bar)
		return dev_iomap_resource(&pdev->resource[bar]);

