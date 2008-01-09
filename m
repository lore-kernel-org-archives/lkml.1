Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbYAISMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbYAISMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 13:12:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbYAISL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 13:11:59 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:49399 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752092AbYAISL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 13:11:58 -0500
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
	I/O delay override.
From: Zachary Amsden <zach@vmware.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Christer Weinigel <christer@weinigel.se>,
       "David P. Reed" <dpreed@reed.com>, Avi Kivity <avi@qumranet.com>,
       Ondrej Zary <linux@rainbow-software.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Bodo Eggert <7eggert@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol <rol@witbe.net>
In-Reply-To: <4784E7E1.4060308@keyaccess.nl>
References: <9BdU5-1YW-9@gated-at.bofh.it>
	 <200801081810.58904.linux@rainbow-software.org>	<4783B1B2.6070005@reed.com>
	 <200801081838.16241.linux@rainbow-software.org>	<4783C4A6.9060402@reed.com>
	 <20080108185120.3ff7ed18@lxorguk.ukuu.org.uk>	<4783CBD9.7020709@reed.com>
	 <1199847162.7369.323.camel@bodhitayantram.eng.vmware.com>
	 <20080109063052.48a5709c@weinigel.se>  <4784E7E1.4060308@keyaccess.nl>
Content-Type: text/plain
Date: Wed, 09 Jan 2008 10:17:24 -0800
Message-Id: <1199902644.7369.355.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-09 at 16:27 +0100, Rene Herman wrote:
> On 09-01-08 06:30, Christer Weinigel wrote:
> I'd not expect very time crtical. The current outb_p use gives a delay 
> somewhere between .5 and 2 microseconds as per earlier survey meaning a 
> udelay(1) or 2 would be enough -- again, at the point that udelay() is sensible.
> 
> New machines don't use the legacy PIC anymore anyway.
> 
> > The floppy controller code uses outb_p.  Even though there might be
> > floppy controllers on modern systems, I'd rather leave the floppy code
> > alone since it's supposed to be very fragile.  If you still use
> > floppies you deserve what you get.
> 
> Floppies forever. In practice, leaving it alone isn't going to matter, but 
> in that same practice changing it to udelay() probably doesn't either. The 
> ones to leave alone are the ones that are clumsy/impossible to test and the 
> ones such as in NIC drivers that were specifically tuned.

I'm speaking specifically in terms of 64-bit platforms here.  Shouldn't
we unconditionally drop outb_p doing extra port I/O on 64-bit
architectures?  Especially considering they don't even have an ISA bus
where the decode timing could even matter?

> If simple outb_p() deprecation is considered enough instead, no need to 
> touch anything in drivers/, only changes to "outb(); udelay()" outside drivers/.
> 
> I'd let Alan decide here.

Agree.

Zach

