Return-Path: <linux-kernel-owner+w=401wt.eu-S1761375AbXGUQqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761375AbXGUQqg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 12:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750933AbXGUQq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 12:46:26 -0400
Received: from homer.mvista.com ([63.81.120.158]:45448 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbXGUQq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 12:46:26 -0400
Subject: Re: PROBLEM: Dell Inspiron 1501 fails to boot in 2.6.21+
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mark Tiefenbruck <mark@fluxbox.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070721115948.GA29178@elte.hu>
References: <c96265a60707201937t39f9b69ep48e76ed61ce1044e@mail.gmail.com>
	 <20070721115948.GA29178@elte.hu>
Content-Type: text/plain
Date: Sat, 21 Jul 2007 08:58:33 -0700
Message-Id: <1185033513.2567.5.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-21 at 13:59 +0200, Ingo Molnar wrote:
> * Mark Tiefenbruck <mark@fluxbox.org> wrote:
> 
> >  IO window: disabled.
> >  MEM window: c0200000-c02fffff
> >  PREFETCH window: disabled.
> > PCI: Bridge: 0000:00:14.4
> >  IO window: disabled.
> >  MEM window: c0300000-c03fffff
> >  PREFETCH window: disabled.
> > PCI: Setting latency timer of device 0000:00:05.0 to 64
> > PCI: Setting latency timer of device 0000:00:06.0 to 64
> > NET: Registered protocol family 2
> > 
> > The next few lines are usually as follows, but recent kernels never 
> > get to them:
> 
> thanks for the detailed report and bisection test! The above hang 
> strongly implicates some sort of high-res timers, dynticks or 
> clocksource problem. Most likely timer interrupts do not come as 
> expected, and the above place is one of the first spots where the kernel 
> waits for a (short) timeout - so you see it hang indefinitely.
> 
> Besides the options Thomas suggested, you could also try 
> clocksource=pm_timer?

Do you mean "clocksource=acpi_pm" ?

Daniel

