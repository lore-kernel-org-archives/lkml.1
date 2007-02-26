Return-Path: <linux-kernel-owner+w=401wt.eu-S1161422AbXBZXu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161422AbXBZXu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 18:50:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161420AbXBZXu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 18:50:57 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:54708 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161422AbXBZXu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 18:50:56 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Simon Arlott <58022e3be4e86309571hlooq00057abw@thunder.lp0.eu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [irq: Remove set_native_irq_info] !CONFIG_SMP regression
References: <45E3663B.4000701@simon.arlott.org.uk>
Date: Mon, 26 Feb 2007 16:50:33 -0700
In-Reply-To: <45E3663B.4000701@simon.arlott.org.uk> (Simon Arlott's message of
	"Mon, 26 Feb 2007 22:59:07 +0000")
Message-ID: <m1bqjgo4vq.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Arlott <simon@arlott.org> writes:

> 9f0a5ba5508143731dc63235de19659be20d26dc is first bad commit
> commit 9f0a5ba5508143731dc63235de19659be20d26dc
> Author: Eric W. Biederman <ebiederm@xmission.com>
> Date:   Fri Feb 23 04:13:55 2007 -0700
>
>     [PATCH] irq: Remove set_native_irq_info
>
>     This patch replaces all instances of "set_native_irq_info(irq, mask)"
>     with "irq_desc[irq].affinity = mask".  The latter form is clearer
>     uses fewer abstractions, and makes access to this field uniform
>     accross different architectures.
>
>
>
> arch/i386/kernel/io_apic.c: In function `setup_IO_APIC_irqs':
> arch/i386/kernel/io_apic.c:1357: error: structure has no member named `affinity'
> arch/i386/kernel/io_apic.c: In function `io_apic_set_pci_routing':
> arch/i386/kernel/io_apic.c:2878: error: structure has no member named `affinity'
>
>
> The original version was an empty function if !CONFIG_SMP, struct irq_desc only
> has 'affinity' on SMP.

Yep.

Give me a bit. I think we can just kill those lines.

Eric
