Return-Path: <linux-kernel-owner+w=401wt.eu-S1759615AbYF3KX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759615AbYF3KX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 06:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755364AbYF3KXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 06:23:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39377 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754920AbYF3KXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 06:23:47 -0400
Date: Mon, 30 Jun 2008 12:23:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matti Linnanvuori <mattilinn@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: add compilation checks to pci_unmap_ macros
Message-ID: <20080630102332.GC31497@elte.hu>
References: <ca0148c30806282322u51cf8ecct700f442466b58ee4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca0148c30806282322u51cf8ecct700f442466b58ee4@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matti Linnanvuori <mattilinn@gmail.com> wrote:

> From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
> 
> Add compilation checks to pci_unmap_ macros.

> -#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)
> -#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)
> -#define pci_unmap_addr(PTR, ADDR_NAME)		(0)
> -#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)	do { } while (0)
> -#define pci_unmap_len(PTR, LEN_NAME)		(0)
> -#define pci_unmap_len_set(PTR, LEN_NAME, VAL)	do { } while (0)
> +#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)	dma_addr_t ADDR_NAME[0];
> +#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)	unsigned LEN_NAME[0];
> +#define pci_unmap_addr(PTR, ADDR_NAME)	sizeof((PTR)->ADDR_NAME)
> +#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL) \
> +	do { break; } while (pci_unmap_addr(PTR, ADDR_NAME))
> +#define pci_unmap_len(PTR, LEN_NAME)		sizeof((PTR)->LEN_NAME)
> +#define pci_unmap_len_set(PTR, LEN_NAME, VAL) \
> +	do { break; } while (pci_unmap_len(PTR, LEN_NAME))

applied to tip/x86/cleanups - thanks Matti.

Would you be interested in doing a small cleanup as well and convert the 
parameter names to non-shouting lower-case letters? (If you do it then 
please do it as a delta patch as i've already applied your current 
patch.)

	Ingo
