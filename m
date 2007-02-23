Return-Path: <linux-kernel-owner+w=401wt.eu-S932386AbXBWOKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386AbXBWOKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 09:10:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932387AbXBWOKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 09:10:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36095 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932386AbXBWOKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 09:10:17 -0500
Date: Fri, 23 Feb 2007 15:04:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] s390: do not use _local_bh_enable()
Message-ID: <20070223140443.GA23754@elte.hu>
References: <20070223061459.GA10106@elte.hu> <20070223093649.GA8084@osiris.boeblingen.de.ibm.com> <1172238097.30132.34.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1172238097.30132.34.camel@localhost>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.1.7
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3650]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> [...] cio_tpi and sclp_sync_wait are used to wait for the interrupt of 
> the console device to make room in the buffer for a printk out of 
> disabled context.

ouch. So you want/need to wait for a specific type of interrupt, in a 
section of code that has all interrupts disabled? Is this the only form 
of communication to the hypervisor, for this particular purpose? It 
seems to me that polling a bit in a buffer shared between the hypervisor 
and the guest OS [combined with cpu_relax()] would fit this scenario 
alot better (and wouldnt cause any such gymnastics to avoid regular 
Linux irq processing) than waiting for an interrupt to be injected by 
the hypervisor. Or is this interrupt-based interface an ABI property and 
the only way to do it?

	Ingo

