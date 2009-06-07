Return-Path: <linux-kernel-owner+w=401wt.eu-S1754316AbZFGPeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbZFGPeG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 11:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbZFGPdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 11:33:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50395 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782AbZFGPdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 11:33:55 -0400
Date: Sun, 7 Jun 2009 17:33:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, stable@kernel.org, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: Detect use of extended APIC ID for AMD
	CPUs
Message-ID: <20090607153327.GA8973@elte.hu>
References: <20090604104016.GT5736@alberich.amd.com> <tip-37f36c1017f0032fa7a1fb85a0cddfc0d526d17f@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-37f36c1017f0032fa7a1fb85a0cddfc0d526d17f@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0013]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> +#ifdef CONFIG_X86_LOCAL_APIC
> +	/* check CPU config space for extended APIC ID */
> +	if (c->x86 >= 0xf) {
> +		unsigned int val;
> +
> +		val = read_pci_config(0, 24, 0, 0x68);
> +		if ((val & ((1 << 17) | (1 << 18))) == ((1 << 17) | (1 << 18)))
> +			set_cpu_cap(c, X86_FEATURE_EXTD_APICID);
> +	}
> +#endif

It's possible to enable local APIC but not CONFIG_PCI - in that case 
this sequence will fail to build.

	Ingo
