Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168Ab0CJLAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 06:00:38 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:5268 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755675Ab0CJLAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 06:00:36 -0500
X-IronPort-AV: E=Sophos;i="4.49,613,1262581200"; 
   d="scan'208";a="87457072"
Subject: Re: [PATCH] irq: move some interrupt arch_* functions into struct
 irq_chip.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Yinghai Lu <yinghai@kernel.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, "x86@kernel.org" <x86@kernel.org>,
       "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>
In-Reply-To: <1268218559-26784-2-git-send-email-ijc@hellion.org.uk>
References: <1268218524.11737.68547.camel@zakaz.uk.xensource.com>
	 <1268218559-26784-2-git-send-email-ijc@hellion.org.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Wed, 10 Mar 2010 11:00:32 +0000
Message-ID: <1268218832.11737.68575.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-10 at 10:55 +0000, ijc@hellion.org.uk wrote:
> 
> arch_init_chip_data cannot be moved into struct irq_chip at this time
> because irq_desc->chip is not known at the time the irq_desc is
> setup. For now rename arch_init_chip_data to arch_init_irq_desc (for
> PowerPC, the only other user, whose usage better matches the new name)
> and on x86 convert arch_init_chip_data to ioapic_init_chip_data and
> call this whenever the IO APIC code allocates a new IRQ.

One idea I had to improve this was to add a struct irq_chip * as a
parameter to irq_to_desc_alloc_node. The new parameter potentially could
be NULL for current behaviour. Does that sound like a reasonable
approach?

Ian.

