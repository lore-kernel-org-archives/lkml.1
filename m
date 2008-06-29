Return-Path: <linux-kernel-owner+w=401wt.eu-S1759747AbYF2Mws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759747AbYF2Mws (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 08:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbYF2Mwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 08:52:38 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:34711 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112AbYF2Mwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 08:52:38 -0400
Date: Sun, 29 Jun 2008 14:52:36 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Matti Linnanvuori <mattilinn@gmail.com>
cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: add compilation checks to pci_unmap_ macros
In-Reply-To: <ca0148c30806282322u51cf8ecct700f442466b58ee4@mail.gmail.com>
Message-ID: <alpine.LNX.1.10.0806291450170.6280@fbirervta.pbzchgretzou.qr>
References: <ca0148c30806282322u51cf8ecct700f442466b58ee4@mail.gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 2008-06-29 08:22, Matti Linnanvuori wrote:
>+#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)	dma_addr_t ADDR_NAME[0];
>+#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)	unsigned LEN_NAME[0];
>+#define pci_unmap_addr(PTR, ADDR_NAME)	sizeof((PTR)->ADDR_NAME)
>+#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL) \
>+	do { break; } while (pci_unmap_addr(PTR, ADDR_NAME))

Mh. If addr_name happens to be non-0 for some reason (like, a typo),
then this just introduces a lockup.
(Better to have a no-op with a typo than a sudden lockup. Given
that these are no-ops means they are deprecated, is not it the case?)
