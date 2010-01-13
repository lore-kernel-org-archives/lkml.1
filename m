Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930Ab0AMAIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab0AMAIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 19:08:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475Ab0AMAIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 19:08:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46564 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750757Ab0AMAIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 19:08:30 -0500
Date: Tue, 12 Jan 2010 16:07:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dimitrios Apostolou <jimis@gmx.net>
Cc: Arjan van de Ven <arjan@infradead.org>, Alex Chiang <achiang@hp.com>,
       Len Brown <lenb@kernel.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: High cpu temperature with 2.6.32, bisection shows commit 69d258
 (fwd)
Message-Id: <20100112160734.89ee6b11.akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.00.1001100251210.1334@localhost.localdomain>
References: <alpine.LNX.2.00.1001071941470.1363@localhost.localdomain>
	<20100108171513.GB22713@ldl.fc.hp.com>
	<20100109134352.3dedd4ea@infradead.org>
	<alpine.LNX.2.00.1001100155370.1325@localhost.localdomain>
	<20100109160836.26a344a9@infradead.org>
	<alpine.LNX.2.00.1001100226570.1325@localhost.localdomain>
	<20100109164240.43b21247@infradead.org>
	<alpine.LNX.2.00.1001100251210.1334@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jan 2010 03:05:38 +0200 (EET)
Dimitrios Apostolou <jimis@gmx.net> wrote:

> On Sat, 9 Jan 2010, Arjan van de Ven wrote:
> 
> > On Sun, 10 Jan 2010 02:32:11 +0200 (EET)
> > Dimitrios Apostolou <jimis@gmx.net> wrote:
> >
> >> On Sat, 9 Jan 2010, Arjan van de Ven wrote:
> >>
> >>> On Sun, 10 Jan 2010 01:55:42 +0200 (EET)
> >>> Dimitrios Apostolou <jimis@gmx.net> wrote:
> >>>
> >>>> L8400B series Notebook PC
> >>>
> >>> can you try this patch?
> >>>
> >>
> >> OK I'm compiling a new kernel right now but that will take a while, I
> >> only have access to old hardware at the moment... What exactly this
> >> patch does?
> >>
> >
> > basically it appears that your machine, when the kernel asks for C2,
> > exits C2 immediately again.
> >
> > The old algorithm somehow caught this and stopped asking for C2 most of
> > the time; the new algorithm doesn't see any activity and asks for C2
> > again.
> >
> > What the patch does is tell the kernel to just not use C2 at all...
> 
> Indeed, in the past powertop always showed my processor idling in C1 
> state, and I wondered why it never entered C2. :-)
> 
> So thanks for the patch, I guess it works, and my bet is that this 
> case applies to L8400* (not only B models), except if it is fixed by some 
> old BIOS upgrade that I must have missed.
> 
> While testing your patch, indeed the temperature was not rising and 
> everything was normal, but the tsc was not marked as unstable so it didn't 
> switch to acpi_pm clocksource, so that was probably the reason.
> 

Arjan, can you please prepare a formal version of the fix?  I guess the
cc:stable will be needed as well.

I assume that the effects which Dimitrios described above were the
intended ones?

