Return-Path: <linux-kernel-owner+w=401wt.eu-S1757346AbYAICrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbYAICrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 21:47:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756326AbYAICrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 21:47:19 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:59828 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756226AbYAICrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 21:47:18 -0500
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
	I/O delay override.
From: Zachary Amsden <zach@vmware.com>
To: "David P. Reed" <dpreed@reed.com>, Avi Kivity <avi@quramnet.com>
Cc: Christer Weinigel <christer@weinigel.se>,
       Ondrej Zary <linux@rainbow-software.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Rene Herman <rene.herman@keyaccess.nl>, Bodo Eggert <7eggert@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol <rol@witbe.net>
In-Reply-To: <4783CBD9.7020709@reed.com>
References: <9BdU5-1YW-9@gated-at.bofh.it>
	 <200801081810.58904.linux@rainbow-software.org>	<4783B1B2.6070005@reed.com>
	 <200801081838.16241.linux@rainbow-software.org>	<4783C4A6.9060402@reed.com>
	 <20080108185120.3ff7ed18@lxorguk.ukuu.org.uk>  <4783CBD9.7020709@reed.com>
Content-Type: text/plain
Date: Tue, 08 Jan 2008 18:52:42 -0800
Message-Id: <1199847162.7369.323.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-01-08 at 14:15 -0500, David P. Reed wrote:
> Alan Cox wrote:
> > The natsemi docs here say otherwise. I trust them not you.
> >   
> As well you should. I am honestly curious (for my own satisfaction) as 
> to what the natsemi docs say the delay code should do  (can't imagine 
> they say "use io port 80 because it is unused").  I don't have any 

What is the outcome of this thread?  Are we going to use timing based
port delays, or can we finally drop these things entirely on 64-bit
architectures?

I a have a doubly vested interest in this, both as the owner of an
affected HP dv9210us laptop and as a maintainer of paravirt code - and
would like 64-bit Linux code to stop using I/O to port 0x80 in both
cases (as I suspect would every other person involved with
virtualization).

BTW, it isn't ever safe to pass port 0x80 through to hardware from a
virtual machine; some OSes use port 0x80 as a hardware available scratch
register (I believe Darwin/x86 did/does this during boot).  This means
simultaneous execution of two virtual machines can interleave port 0x80
values or share data with a hardware provided covert channel.  This
means KVM should be trapping port 0x80 access, which is really
expensive, or alternatively, Linux should not be using port 0x80 for
timing bus access on modern (64-bit) hardware.

I've tried to follow this thread, but with all the jabs, 1-ups, and
obscure legacy hardware pageantry going on, it isn't clear what we're
really doing.

Thanks,

Zach

