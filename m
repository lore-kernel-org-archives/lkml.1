Return-Path: <linux-kernel-owner+w=401wt.eu-S1759214AbYC1XKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759214AbYC1XKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 19:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756075AbYC1XKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 19:10:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48915
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755602AbYC1XKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 19:10:18 -0400
Date: Fri, 28 Mar 2008 16:10:11 -0700 (PDT)
Message-Id: <20080328.161011.08762096.davem@davemloft.net>
To: m.kozlowski@tuxland.pl
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, greg@kroah.com,
       sparclinux@vger.kernel.org
Subject: Re: 2.6.25-rc5-mm1 sparc64 boot problems due to generic
 pci_enable_resources()
From: David Miller <davem@davemloft.net>
In-Reply-To: <200803282352.10780.m.kozlowski@tuxland.pl>
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>
	<200803282352.10780.m.kozlowski@tuxland.pl>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Date: Fri, 28 Mar 2008 23:52:10 +0100

> 	The gregkh-pci-pci-sparc64-use-generic-pci_enable_resources.patch which
> replaces arch-specific code with generic pci_enable_resources() makes my sparc64
> box unable to boot (that's what quilt bisection says). At first I see these messages:

Yes, that generic code won't work because of the NULL
r->parent check.

Alpha, ARM, V32, FRV, IA64, MIPS, MN10300, PARISC, PPC,
SH, V850, X86, and Xtensa are all likely to run into
problems because of this change.

The only platform that did the check as a test of r->parent
being NULL is Powerpc.

The rest either didn't check (like sparc64), or tested it by going:

	if (!r->start && r->end)

So the amount of potential breakage from this change is enormous.
