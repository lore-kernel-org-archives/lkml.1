Return-Path: <linux-kernel-owner+w=401wt.eu-S932211AbYB2OMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211AbYB2OMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 09:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755887AbYB2OMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 09:12:05 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45576 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755827AbYB2OMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 09:12:03 -0500
Date: Fri, 29 Feb 2008 14:01:06 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: devres and requesting resources
Message-ID: <20080229140106.41ccc843@core>
In-Reply-To: <47C7FA8B.7040306@gmail.com>
References: <47C75392.3020606@garzik.org>
	<20080229112651.5b2a7f6f@core>
	<47C7F664.5040102@garzik.org>
	<47C7FA8B.7040306@gmail.com>
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

> controller like ICH AHCIs.  ata_generic or ide generic might attach to a
> controller which is already being driven by ahci under certain
> configurations.

ata_generic will not nor ata_legacy both are much too smart for that. The
legacy old IDE driver might but that probably isn't going to be fixed by
devres and is trivial to fix in that driver (just steal the code from
pata_legacy).

> have different requirements can just open code pci_request_regions() and
> pcim_iomap().  pcim_request_regions() should provide sensible default
> behavior for common cases.

Which is arguably the current behaviour. Changing the behaviour and not
the name is a really bad idea and will cause problems in future so don't
do that.
>
> I think the best solution is to allow duplicate request regions for
> managed devices which is okay as we know we're holding the resource and
> let drivers which need to reserve all regions call pci_request_regions()
> before calling pcim_request_regions().

How about

	pcim_request_all_regions()

for the behaviour Jeff wants, simple, direct, differently named and
obvious what it does.

Alan
