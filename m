Return-Path: <linux-kernel-owner+w=401wt.eu-S1753403AbYJUK3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbYJUK3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 06:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbYJUK3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 06:29:33 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:47071 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbYJUK3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 06:29:32 -0400
Subject: Re: [RFC patch] genirq threading (v2) for ehci, ohci and uhci USB
	hosts and ohci1394
From: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jon Masters <jonathan@jonmasters.org>,
       slert-devel <slert-devel@suse.de>, Daniel Walker <dwalker@soe.ucsc.edu>,
       RT Users List <linux-rt-users@vger.kernel.org>
In-Reply-To: <200810210207.m9L275nQ031086@turbo.physics.adelaide.edu.au>
References: <200810210207.m9L275nQ031086@turbo.physics.adelaide.edu.au>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 03:29:26 -0700
Message-Id: <1224584966.20800.19.camel@sven.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-21 at 11:37 +0930, Jonathan Woithe wrote:
> Hi
> 
> > > This patch series implements support for threaded irq handlers for the
> > > generic IRQ layer.
> >
> > Subject: genirq threading for ehci, ohci and uhci USB hosts.
> > 
> > This is a functional POC for partitioning of the USB interrupt handlers into
> > a quickcheck function and a threaded main-handler function.
> > :
> > The ieee1394/ohci1394.c is a bit more problematic, since it does not use
> > struct usb_hcd, and therefore another place for the status cache must be found,
> > in struct ti_ohci presumably. 
> > I will send a separate patch for ieee1394/ohci1394.c after looking at it more.
> 
> Thanks for sending this through; I will endeavour to test it over the coming
> days.  I'll also see if I can test it for the case where USB and ieee1394
> share IRQs.  Even though ieee1394 isn't done yet these changes should
> prevent the USB-related problems we've seen in FFADO when USB shares the
> firewire IRQ.
> 
> Having said that, the forthcoming ohci1394.c patch will also be interesting
> since that is the other area which will greatly benefit FFADO.
> 

Hi, 

I have re-released the patch set with support for ohci1394. 

I have not tested, for lack of hardware :: it compiles.

The location of status_cache is now within the ti_ohci struct.

That organization not entirely consistent with the USB side, predicated
by other variation between the drivers.

The updated patch queue is available here.

http://www.thebigcorporation.com/Sven/genirq-usb/genirq-usb-v2.tar.bz2

Bug fix:
The declaration of status_cache has been made consistent u32. 
The former declaration of unsigned short (copied from uhci-hcd.c) it was
probably too ambiguous for some architectures.

Thanks,

Sven


> Regards
>   jonathan

