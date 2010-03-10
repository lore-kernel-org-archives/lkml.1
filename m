Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab0CJMvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 07:51:23 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:52023 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab0CJMvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 07:51:20 -0500
X-IronPort-AV: E=Sophos;i="4.49,614,1262581200"; 
   d="scan'208";a="87468991"
Subject: Re: [PATCH] irq: move some interrupt arch_* functions into struct
 irq_chip.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, "x86@kernel.org" <x86@kernel.org>,
       "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>
In-Reply-To: <86802c441003100406t70dd854fx491f0ee9a6fce62b@mail.gmail.com>
References: <1268218524.11737.68547.camel@zakaz.uk.xensource.com>
	 <1268218559-26784-2-git-send-email-ijc@hellion.org.uk>
	 <86802c441003100406t70dd854fx491f0ee9a6fce62b@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Wed, 10 Mar 2010 12:51:13 +0000
Message-ID: <1268225473.11737.69196.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-10 at 12:06 +0000, Yinghai Lu wrote:
> On Wed, Mar 10, 2010 at 2:55 AM,  <ijc@hellion.org.uk> wrote:
> > From: Ian Campbell <ian.campbell@citrix.com>
> >
> > Move arch_init_copy_chip_data and arch_free_chip_data into function
> > pointers in struct irq_chip since they operate on irq_desc->chip_data.
> >
> > arch_init_chip_data cannot be moved into struct irq_chip at this time
> > because irq_desc->chip is not known at the time the irq_desc is
> > setup. For now rename arch_init_chip_data to arch_init_irq_desc (for
> > PowerPC, the only other user, whose usage better matches the new name)
> > and on x86 convert arch_init_chip_data to ioapic_init_chip_data and
> > call this whenever the IO APIC code allocates a new IRQ.
> >
> > I've retained the chip_data behaviour for uv_irq although it isn't
> > clear to me if these interrupt types support migration or how closely
> > related to the APIC modes they really are. If it weren't for this the
> > ioapic_{init,copy,free}_chip_data functions could be static to
> > io_apic.c.
> >
> > I've tested by booting on a 64 bit system, but it's not clear to me
> > what actions I need to take to actually exercise some of these code
> > paths.
> >
> 
> can you just add another pointer field in irq_desc?
> 
> some kind of *irq_info etc.

I think I don't understand what you are suggesting.

There is already a pointer for irq_chip specific use i.e.
irq_desc->chip_data. This patchset is just about ensuring that the field
really is available to any chip implementation rather than just assuming
it is always used for the acpi chip types (on x86 at least).

Does adding a second pointer with the same (intended?) semantics as the
existing one buy us anything?

Ian.

