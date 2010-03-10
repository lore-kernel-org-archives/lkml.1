Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab0CJMLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 07:11:24 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61478 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab0CJMLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 07:11:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=dTeJJK2ATPY4XYwSNr89txqwd15jw+INDG4YCPH8VLV8anzNEPkEbpFEd+sd9AUBSQ
         DAB2uQGw2sO1YXkyCVr9kHmmsaEmrqC7B8cKiHD1TjnJikbfIukxhysKmqO84IGxbYsU
         RR1pmJ0E+45prm1xN7jAbRuBeMFKx3toYbgZ0=
MIME-Version: 1.0
In-Reply-To: <1268218559-26784-2-git-send-email-ijc@hellion.org.uk>
References: <1268218524.11737.68547.camel@zakaz.uk.xensource.com>
	 <1268218559-26784-2-git-send-email-ijc@hellion.org.uk>
Date: Wed, 10 Mar 2010 04:06:14 -0800
X-Google-Sender-Auth: b01c87ed5d6065b1
Message-ID: <86802c441003100406t70dd854fx491f0ee9a6fce62b@mail.gmail.com>
Subject: Re: [PATCH] irq: move some interrupt arch_* functions into struct 
	irq_chip.
From: Yinghai Lu <yinghai@kernel.org>
To: ijc@hellion.org.uk
Cc: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, x86@kernel.org,
       linuxppc-dev@ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 2:55 AM,  <ijc@hellion.org.uk> wrote:
> From: Ian Campbell <ian.campbell@citrix.com>
>
> Move arch_init_copy_chip_data and arch_free_chip_data into function
> pointers in struct irq_chip since they operate on irq_desc->chip_data.
>
> arch_init_chip_data cannot be moved into struct irq_chip at this time
> because irq_desc->chip is not known at the time the irq_desc is
> setup. For now rename arch_init_chip_data to arch_init_irq_desc (for
> PowerPC, the only other user, whose usage better matches the new name)
> and on x86 convert arch_init_chip_data to ioapic_init_chip_data and
> call this whenever the IO APIC code allocates a new IRQ.
>
> I've retained the chip_data behaviour for uv_irq although it isn't
> clear to me if these interrupt types support migration or how closely
> related to the APIC modes they really are. If it weren't for this the
> ioapic_{init,copy,free}_chip_data functions could be static to
> io_apic.c.
>
> I've tested by booting on a 64 bit system, but it's not clear to me
> what actions I need to take to actually exercise some of these code
> paths.
>

can you just add another pointer field in irq_desc?

some kind of *irq_info etc.

YH
