Return-Path: <linux-kernel-owner+w=401wt.eu-S1760291AbXKAKw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760291AbXKAKw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 06:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756346AbXKAKwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 06:52:19 -0400
Received: from [81.2.110.250] ([81.2.110.250]:60771 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753882AbXKAKwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 06:52:18 -0400
Date: Thu, 1 Nov 2007 10:50:36 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, Jens Axboe <jens.axboe@oracle.com>,
       Daniel Drake <dsd@gentoo.org>,
       linux list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: "Fix ATAPI transfer lengths" causes CD writing regression
Message-ID: <20071101105036.3565decf@the-village.bc.nu>
In-Reply-To: <4729209A.50809@gmail.com>
References: <47274A5F.6070409@gentoo.org>
	<20071030153417.59b9182c@the-village.bc.nu>
	<47276DCA.1000808@gentoo.org>
	<20071030190153.373c9347@the-village.bc.nu>
	<47278439.4030801@gentoo.org>
	<20071031114958.210bd7cc@the-village.bc.nu>
	<20071031115754.GK5059@kernel.dk>
	<472872F6.70802@garzik.org>
	<4729209A.50809@gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

O> Hmmm.... reading ide-cd.c::cdrom_pc_intr().  OIC, ide-cd is dealing with
> this problem by draining PIO after BMDMA engine is done.  This is
> possible for BMDMA engines as they simply step out when the SG entries
> are exhausted; then, the interrupt handler kicks in and drains the
> left-over using PIO.  This just isn't possible with more modern DMA engines.

Its not possible with old ones either - its a bug not a feature and is
why there is special casing for stuff like promise where this hangs the
chip.

Alan
