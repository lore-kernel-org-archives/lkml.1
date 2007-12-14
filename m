Return-Path: <linux-kernel-owner+w=401wt.eu-S1754495AbXLNSnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbXLNSnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 13:43:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbXLNSnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 13:43:43 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49751 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752059AbXLNSnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 13:43:42 -0500
Date: Fri, 14 Dec 2007 18:36:26 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rene Herman <rene.herman@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Rene Herman <rene.herman@gmail.com>,
       "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80 on
 some AMD64x2 laptops, etc.
Message-ID: <20071214183626.4a16e2af@the-village.bc.nu>
In-Reply-To: <476299B7.8030908@keyaccess.nl>
References: <1184216528.12353.203.camel@chaos>
	<1184218962.12353.209.camel@chaos>
	<46964352.7040301@reed.com>
	<1184253339.12353.223.camel@chaos>
	<469697C6.50903@reed.com>
	<1184274754.12353.254.camel@chaos>
	<4761F193.7090400@reed.com>
	<476250D5.8000409@gmail.com>
	<20071214142355.GA10130@elte.hu>
	<476294D3.4060609@keyaccess.nl>
	<20071214144628.GA16074@elte.hu>
	<476299B7.8030908@keyaccess.nl>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > i dont think this should matter: old systems that truly _need_ the ISA 
> > delay will be slow enough to not trip up. (nor are they really affected 
> > by these early delays - the delays were more for crappy ISA devices that 
> > get initialized later down, when the delay loop is already calibrated)
> 
> 8253 (DMAC) and 8254 (PIT) have been reported in earlier versions of the 
> thread. By Alan, I believe.

They've been seen to be problems up to PII era machines. I'm not aware of
any newer than that with this problem. We also don't need to touch the
DMAC that early anyway that I can see - just the PIT.

In fact if we have a fast processor we have a TSC and APIC so we don't
need the PIT ?

Alan
