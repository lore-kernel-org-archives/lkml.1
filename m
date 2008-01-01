Return-Path: <linux-kernel-owner+w=401wt.eu-S1756549AbYAARdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbYAARdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 12:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754618AbYAARcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 12:32:42 -0500
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:51032 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155AbYAARcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 12:32:41 -0500
Date: Tue, 1 Jan 2008 18:32:38 +0100
From: Christer Weinigel <christer@weinigel.se>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "David P. Reed" <dpreed@reed.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Rene Herman <rene.herman@gmail.com>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Message-ID: <20080101183238.74307174@weinigel.se>
In-Reply-To: <20080101164338.GA901@elte.hu>
References: <4765D43E.1010800@gmail.com>
	<4765D95C.4010404@zytor.com>
	<4765DCB0.8030901@gmail.com>
	<4765EE7F.80002@zytor.com>
	<47667366.7010405@gmail.com>
	<4766AE88.4080904@zytor.com>
	<4766D175.7040807@reed.com>
	<20071217212509.5edaa372@the-village.bc.nu>
	<477A634C.8040000@reed.com>
	<20080101161557.3ce2d5f8@the-village.bc.nu>
	<20080101164338.GA901@elte.hu>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jan 2008 17:43:38 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> if someone runs a fresh new kernel on an ancient device then timings 
> _will_ change a bit, no matter what we do. Alignments change, the 
> compiler output will change (old compilers get deprecated so a new 
> compiler might have to be picked), cache effects change - and this is 
> inevitable. The important thing is to not eliminate the delays - but
> we sure dont have to keep them cycle accurate (we couldnt even if we
> wanted to). The only way to get the _exact same_ behavior is to not
> change the kernel at all.

What I'm afraid is that udelay will be significantly slower, which
might hit anything that does a lot of gettimeofday calls (poking at the
PIT timer)  on embedded 386/486 systems.  On the other hand, those
systems might not want to upgrade to 2.6 anyway.  

And why do people keep buying HP hardware?  HP seem to be quite
Linux-unfriendly on the desktop [1] and on their laptops.  Apparently
HP doesn't even bother to try Linux on any of their non-server systems.

[1] Try running Linux on a HP DC7700 machine, there seems to be a lot
of magic stuff in those machines that doesn't work well with Linux.
They had some ACPI crap that stopped FC7 from booting without a lot of
magic PCI access options and audio still does not work.  

/Christer
