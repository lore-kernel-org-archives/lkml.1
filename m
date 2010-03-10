Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab0CJRSt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 12:18:49 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:40173 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756908Ab0CJRSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 12:18:45 -0500
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, "x86\@kernel.org" <x86@kernel.org>,
       "linuxppc-dev\@ozlabs.org" <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH] irq: move some interrupt arch_* functions into struct irq_chip.
References: <1268218524.11737.68547.camel@zakaz.uk.xensource.com>
	<1268218559-26784-2-git-send-email-ijc@hellion.org.uk>
	<1268218832.11737.68575.camel@zakaz.uk.xensource.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 10 Mar 2010 09:18:38 -0800
In-Reply-To: <1268218832.11737.68575.camel@zakaz.uk.xensource.com> (Ian Campbell's message of "Wed\, 10 Mar 2010 11\:00\:32 +0000")
Message-ID: <m1r5nsjdsh.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: Ian.Campbell@citrix.com, linuxppc-dev@ozlabs.org, x86@kernel.org, paulus@samba.org, benh@kernel.crashing.org, jeremy@goop.org, yinghai@kernel.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell <Ian.Campbell@citrix.com> writes:

> On Wed, 2010-03-10 at 10:55 +0000, ijc@hellion.org.uk wrote:
>> 
>> arch_init_chip_data cannot be moved into struct irq_chip at this time
>> because irq_desc->chip is not known at the time the irq_desc is
>> setup. For now rename arch_init_chip_data to arch_init_irq_desc (for
>> PowerPC, the only other user, whose usage better matches the new name)
>> and on x86 convert arch_init_chip_data to ioapic_init_chip_data and
>> call this whenever the IO APIC code allocates a new IRQ.
>
> One idea I had to improve this was to add a struct irq_chip * as a
> parameter to irq_to_desc_alloc_node. The new parameter potentially could
> be NULL for current behaviour. Does that sound like a reasonable
> approach?

I don't follow why we have the restriction that irq_to_desc_alloc_node
must call arch_init_chip_data.  Assuming that requirement to call arch_init_chip_data
is valid, passing something into init_one_irq_desc seems appropriate.

Eric

