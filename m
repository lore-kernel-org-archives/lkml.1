Return-Path: <linux-kernel-owner+w=401wt.eu-S1752578AbYJTJOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbYJTJOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 05:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbYJTJO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 05:14:28 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:38329 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbYJTJO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 05:14:27 -0400
X-IronPort-AV: E=Sophos;i="4.33,450,1220241600"; 
   d="scan'208";a="24589616"
Subject: Re: [Lguest] lguest: unhandled trap
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>, maluta_tiago@yahoo.com.br,
       lguest@ozlabs.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20081020075333.GC798@elte.hu>
References: <713731.28571.qm@web50701.mail.re2.yahoo.com>
	 <200810201452.04932.rusty@rustcorp.com.au> <20081020072236.GD12131@elte.hu>
	 <48FC36B9.6000704@goop.org>  <20081020075333.GC798@elte.hu>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Mon, 20 Oct 2008 10:14:15 +0100
Message-Id: <1224494055.9053.192.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Oct 2008 09:14:23.0734 (UTC) FILETIME=[3E3A8160:01C93294]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-20 at 09:53 +0200, Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > Ingo Molnar wrote:
> >> i think Xen can withstand DMI scanning just fine.
> >>
> >> without having seen any background, my general feeling is that lguest 
> >> should either do what Xen does and reserve the classic BIOS ranges 
> >> that we probe - or we should make DMI scanning more robust by making 
> >> sure real RAM ranges are never probed. (only ranges that the BIOS 
> >> itself marks as reserved in the e820 map)
> >
> > We considered doing that, but decided that there was so many other 
> > pieces of code around the place that assume that the ISA area is 
> > special, that just reserving it was the best course of action.
> 
> yeah - for _any_ virtual machine environment it's beneficial to look as 
> much like a normal PC as possible, because normal PCs is where the code 
> gets tested most.
> 
> Nevertheless if this is the only current roadblock for lguest then i 
> wouldnt find it objectionable to make DMI scanning more robust that way 
> - the two are complimentary. [ With an initial transitionary period of 
> generating printks and WARN()s when we try to scan general RAM areas. ]

Wasn't there some concern about BIOSes which don't correctly reserve
their DMI tables? Or don't even have e820 maps? H. Peter once said:

> It's pretty standard for 0xf0000...0x100000 to be marked RESERVED in
> E820 on real hardware (including the system I'm typing on right now.)
> It is so marked to indicate that hardware cannot be mapped into that
> space.  However, you can't rely on this fact -- heck, you can't rely on
> E820 even existing on a real machine.  I have specimens of real-life
> machines that go both ways.

Ian.


