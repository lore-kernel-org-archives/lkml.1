Return-Path: <linux-kernel-owner+w=401wt.eu-S1757995AbXL3QGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995AbXL3QGp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 11:06:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756369AbXL3QGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 11:06:39 -0500
Received: from one.firstfloor.org ([213.235.205.2]:41931 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790AbXL3QGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 11:06:38 -0500
Date: Sun, 30 Dec 2007 17:08:17 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       hpa@zytor.com, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
Message-ID: <20071230160817.GB32752@one.firstfloor.org>
References: <477711DC.5030800@keyaccess.nl> <alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org> <20071230124852.GA30836@one.firstfloor.org> <20071230130544.GB16946@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071230130544.GB16946@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 30, 2007 at 02:05:44PM +0100, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > drivers that then are shown to really need it could use their *own* 
> > > ports.
> > 
> > The i8259 driver uses it and it is known to be needed on some old 
> > chipsets. But it doesn't really have any "own" ports to use afaik.
> 
> we'll solve that via an i8259-specific quirk. That is a lot cleaner and 
> maintainable than the current generic, always-enabled "opt out" 
> port-0x80 quirk.

You mean using pci quirks + udelay? Will be probably challenging to collect
PCI-IDs for that. And there might be old systems needing it without PCI.
They likely won't have DMI either.

In theory you could make it a DMI year cut off of course (and assume old
if no DMI, although that happens occasionally with new systems too); but
that is generally considered ugly.

I don't think it's a big problem to keep delays of some form by default in 8259 --
people who care about performance should be definitely using APIC mode instead.

-Andi
