Return-Path: <linux-kernel-owner+w=401wt.eu-S1754329AbZGVTyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbZGVTyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 15:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983AbZGVTyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 15:54:52 -0400
Received: from claw.goop.org ([74.207.240.146]:51135 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201AbZGVTyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 15:54:51 -0400
Message-ID: <4A676E89.9010606@goop.org>
Date: Wed, 22 Jul 2009 12:54:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [tip:x86/apic] x86/ioapic.c: unify ioapic_retrigger_irq()
References: <tip-e25371d60cb06a44d7a32d7966ab9bfbeacb9390@git.kernel.org>
In-Reply-To: <tip-e25371d60cb06a44d7a32d7966ab9bfbeacb9390@git.kernel.org>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/09 05:05, tip-bot for Jeremy Fitzhardinge wrote:
> Commit-ID:  e25371d60cb06a44d7a32d7966ab9bfbeacb9390
> Gitweb:     http://git.kernel.org/tip/e25371d60cb06a44d7a32d7966ab9bfbeacb9390
> Author:     Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> AuthorDate: Mon, 8 Jun 2009 03:49:01 -0700
> Committer:  Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> CommitDate: Tue, 14 Jul 2009 13:32:51 -0700
>
> x86/ioapic.c: unify ioapic_retrigger_irq()
>
> The 32 and 64-bit versions of ioapic_retrigger_irq() are identical
> except the 64-bit one takes vector_lock.  vector_lock is defined and
> used on 32-bit too, so just use a common ioapic_retrigger_irq().
>   

Having another look at this patch, the other difference is that the
32-bit version just does:

    apic->send_IPI_self(irq_cfg(irq)->vector);

whereas the 64-bit does:

    apic->send_IPI_mask(cpumask_of(cpumask_first(cfg->domain)),
    cfg->vector);


Does 32-bit do the whole vector domain thing now?  Are these actually
equivalent?  Sending to self seems like it should be more efficient.

    J
