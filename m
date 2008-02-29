Return-Path: <linux-kernel-owner+w=401wt.eu-S1760122AbYB2Lh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122AbYB2Lh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 06:37:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbYB2Lht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 06:37:49 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59381 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752657AbYB2Lhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 06:37:48 -0500
Date: Fri, 29 Feb 2008 11:26:51 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: devres and requesting resources
Message-ID: <20080229112651.5b2a7f6f@core>
In-Reply-To: <47C75392.3020606@garzik.org>
References: <47C75392.3020606@garzik.org>
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

> In converting to pcim_iomap_regions(), we no longer reserve /all/ 
> regions, only the ones requested.
> 
> This is actually a bug:  it was intentional to call 
> pci_request_regions(), because that ensures that no other software will 
> use our resources -- even if we are not actively using the resource in 
> question.

That would be a bug. We should only reserve the regions we are using. It
is possible that the other regions can be used correctly by another driver
(consider the CS5520 or the MPIIX where the IDE is only part of one
function of the PCI device).

I believe the current code is in fact correct.

> Or IOW, I wanted to ensure that there would be no device sharing... 
> which this devres conversion accidentally enabled.

Why ?

> The simple fix is obviously to replace pci_request_region() call with 
> pci_request_regions() in lib/devres.c, but I wonder if that will break 
> any existing driver?

It would make devres mostly useless especially outside of libata.

Alan
