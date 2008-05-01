Return-Path: <linux-kernel-owner+w=401wt.eu-S1763276AbYEAQhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763276AbYEAQhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 12:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759806AbYEAQhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 12:37:42 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:32891 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758930AbYEAQhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 12:37:41 -0400
Date: Thu, 1 May 2008 17:29:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Michael Buesch <mb@bu3sch.de>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       John Linville <linville@tuxdriver.com>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       Ingo Molnar <mingo@elte.hu>, bcm43xx-dev@lists.berlios.de,
       linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Add API for weak DMA masks
Message-ID: <20080501172913.08975881@core>
In-Reply-To: <20080501153618.GA470@infradead.org>
References: <200805011638.15910.mb@bu3sch.de>
	<20080501153618.GA470@infradead.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why do we need it?  Is the call to set the 32bit mask when it fails
> a too big burden for the driver author?

We have tons of drivers that go

	try and set 64bit 
	oh failed
	try and set 32 bit
	oh worked

When what most actually want is "set it no more than this wide" - a
request or even a "pci_set_best_mask()" type idea.

Lots less code duplication.
