Return-Path: <linux-kernel-owner+w=401wt.eu-S1758612AbYAKBbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612AbYAKBbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 20:31:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755038AbYAKBbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 20:31:00 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:51197 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754671AbYAKBa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 20:30:59 -0500
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
	I/O delay override.
From: Zachary Amsden <zach@vmware.com>
To: "David P. Reed" <dpreed@reed.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Christer Weinigel <christer@weinigel.se>,
       Ondrej Zary <linux@rainbow-software.org>,
       Rene Herman <rene.herman@keyaccess.nl>, Bodo Eggert <7eggert@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol <rol@witbe.net>
In-Reply-To: <47854916.4080703@reed.com>
References: <9BdU5-1YW-9@gated-at.bofh.it>
	 <200801081810.58904.linux@rainbow-software.org> <4783B1B2.6070005@reed.com>
	 <200801081838.16241.linux@rainbow-software.org> <4783C4A6.9060402@reed.com>
	 <20080108185120.3ff7ed18@lxorguk.ukuu.org.uk> <4783CBD9.7020709@reed.com>
	 <1199847162.7369.323.camel@bodhitayantram.eng.vmware.com>
	 <47845972.9090803@zytor.com>
	 <1199915614.7369.367.camel@bodhitayantram.eng.vmware.com>
	 <47854916.4080703@reed.com>
Content-Type: text/plain
Date: Thu, 10 Jan 2008 17:36:28 -0800
Message-Id: <1200015388.6192.22.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-09 at 17:22 -0500, David P. Reed wrote:
> Zachary Amsden wrote:
> >
> > According to Phoenix Technologies book "System BIOS for IBM PCs,
> > Compatibles and EISA Computers, 2nd Edition", the I/O port list gives
> >
> > port 0080h   R/W  Extra page register (temporary storage)
> >
> > Despite looking, I've never seen it documented anywhere else, but I
> > believe it works on just about every PC platform.  Except, apparently,
> > my laptop.
> >
> >
> >   
> The port 80 problem was discovered by me, after months of "bisecting" 
> the running code around a problem with hanging when using hwclock in 
> 64-bit mode when ACPI is on.  So it kills my laptop, too, and many 
> currentlaptop motherboards designed by Quanta for HP and Compaq (dv6000, 
> dv9000, tx1000, apparently)

Thanks very much for that - I was debugging this for a while too, and
eventually just shut off hwclock.

> Your laptop isn't an aberration.  It's part of the new generation of 
> evolved machines that take advantage of the capabilities of ACPI and 
> SMBIOS and DMI standards that are becoming core parts of the market.

I beg to differ.  I managed to turn the thing into a brick by upgrading
the BIOS (with the correct image, no less) in an attempt to fix it.  I
just got it back from repair.  I'm not sure that is positive
evolutionary development, but it certainly does make my laptop an
aberration :)

FWIW, I fixed the problem locally by recompiling, changing port 80 to
port 84 in io.h; works great, and doesn't conflict with any occupied
ports.

Zach

