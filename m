Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbYKJUfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbYKJUfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 15:35:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbYKJUfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 15:35:08 -0500
Received: from colo.lackof.org ([198.49.126.79]:33384 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbYKJUfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 15:35:06 -0500
Date: Mon, 10 Nov 2008 13:34:54 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Nobin Mathew <nobin.mathew@gmail.com>
Cc: Grant Grundler <grundler@parisc-linux.org>,
       Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Robert Hancock <hancockr@shaw.ca>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: sharing interrupt between PCI device
Message-ID: <20081110203454.GB18188@colo.lackof.org>
References: <4910E8AC.7050407@shaw.ca> <8d6898730811042349p19e65556l8e1c851b27758d5@mail.gmail.com> <20081108172716.GA28039@colo.lackof.org> <4915E43E.4010206@gmail.com> <20081108191536.GC28039@colo.lackof.org> <8d6898730811092235u4a41c664vd641d2792dee4c50@mail.gmail.com> <20081110075115.GA13239@colo.lackof.org> <20081110075827.GE2093@elte.hu> <8d6898730811100231j2ca5e8ceub0d5137c1ef1f9d0@mail.gmail.com> <8d6898730811100742g31711b9ck9e046d77273d0113@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d6898730811100742g31711b9ck9e046d77273d0113@mail.gmail.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2008 at 09:12:05PM +0530, Nobin Mathew wrote:
> I could not find the definition of acpi_unregister_gsi in i386/x86_64
> code, it is defined only for ia64.

Sorry - I was looking at the ia64 branch by mistake.

> 
> Since it is defined as a weak symbol, I feel it is not getting called
> (correct if I am wrong, I searched in google for this).

You are right.

sorry,
grant

> /* FIXME: implement x86/x86_64 version */
> void __attribute__ ((weak)) acpi_unregister_gsi(u32 i)
> {
> }
> 
> How this weak symbols work, is it something like
> acpi_pci_irq_disable() will not call acpi_unregister_gsi() in some
> platforms.
> 
> Thanks
> Nobin Mathew.
> 
> On Mon, Nov 10, 2008 at 4:01 PM, Nobin Mathew <nobin.mathew@gmail.com> wrote:
> > Yes USB Virtual Controller has input devices like keyboard and mouse
> > (routed through hpilo card (remote console)), so those things stops
> > working when we remove hpilo driver.
> >
> > Thanks
> > Nobin Mathew
> >
> > On Mon, Nov 10, 2008 at 1:28 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >>
> >> * Grant Grundler <grundler@parisc-linux.org> wrote:
> >>
> >>> [+ingo - question for you about disable_irq() below]
> >>
> >>> The same problem exists with disable_irq() : only takes a global
> >>> IRQ# and no additional identifying information to prevent disabling
> >>> a shared IRQ. So I'm not sure if this is a bug with ACPI or design
> >>> flaw in generic IRQ APIs.  Ingo?
> >>
> >> that's how disable_irq() always worked: it disables all handlers on
> >> that IRQ#. If the IRQ# is shared, it disables all handlers.
> >>
> >>        Ingo
> >>
> >
