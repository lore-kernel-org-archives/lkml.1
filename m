Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbYKJUdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbYKJUdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 15:33:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbYKJUd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 15:33:26 -0500
Received: from colo.lackof.org ([198.49.126.79]:33358 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753231AbYKJUdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 15:33:24 -0500
Date: Mon, 10 Nov 2008 13:33:12 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Grant Grundler <grundler@parisc-linux.org>,
       Nobin Mathew <nobin.mathew@gmail.com>, Jiri Slaby <jirislaby@gmail.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Robert Hancock <hancockr@shaw.ca>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: sharing interrupt between PCI device
Message-ID: <20081110203312.GA18188@colo.lackof.org>
References: <fa.h7+lofM1lpbRM5V4/ti5d7RwXuM@ifi.uio.no> <4910E8AC.7050407@shaw.ca> <8d6898730811042349p19e65556l8e1c851b27758d5@mail.gmail.com> <20081108172716.GA28039@colo.lackof.org> <4915E43E.4010206@gmail.com> <20081108191536.GC28039@colo.lackof.org> <8d6898730811092235u4a41c664vd641d2792dee4c50@mail.gmail.com> <20081110075115.GA13239@colo.lackof.org> <20081110075827.GE2093@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081110075827.GE2093@elte.hu>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2008 at 08:58:27AM +0100, Ingo Molnar wrote:
> 
> * Grant Grundler <grundler@parisc-linux.org> wrote:
> 
> > [+ingo - question for you about disable_irq() below]
> 
> > The same problem exists with disable_irq() : only takes a global
> > IRQ# and no additional identifying information to prevent disabling
> > a shared IRQ. So I'm not sure if this is a bug with ACPI or design
> > flaw in generic IRQ APIs.  Ingo?
> 
> that's how disable_irq() always worked: it disables all handlers on 
> that IRQ#. If the IRQ# is shared, it disables all handlers.

Ingo,
Sorry - my question really was: given the above, should
pcibios_disable_device() be calling pcibios_disable_irq()?

Right now, I think not.

thanks,
grant

> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
