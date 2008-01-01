Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbYAAQ0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbYAAQ0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 11:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754745AbYAAQ0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 11:26:30 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45326 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753482AbYAAQ03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 11:26:29 -0500
Date: Tue, 1 Jan 2008 16:15:57 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "David P. Reed" <dpreed@reed.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Rene Herman <rene.herman@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Message-ID: <20080101161557.3ce2d5f8@the-village.bc.nu>
In-Reply-To: <477A634C.8040000@reed.com>
References: <4762C551.5070003@zytor.com>
	<20071214210652.GB28793@elf.ucw.cz>
	<4763001A.1070102@zytor.com>
	<20071214232955.545ab809@the-village.bc.nu>
	<20071215080831.404cdb32@tux.DEF.witbe.net>
	<47638C8C.2090604@gmail.com>
	<476438B4.2020600@zytor.com>
	<476462BE.3030701@gmail.com>
	<4764687D.6080609@zytor.com>
	<476524DB.7020806@gmail.com>
	<20071216152250.GA21245@elte.hu>
	<4765D43E.1010800@gmail.com>
	<4765D95C.4010404@zytor.com>
	<4765DCB0.8030901@gmail.com>
	<4765EE7F.80002@zytor.com>
	<47667366.7010405@gmail.com>
	<4766AE88.4080904@zytor.com>
	<4766D175.7040807@reed.com>
	<20071217212509.5edaa372@the-village.bc.nu>
	<477A634C.8040000@reed.com>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 80 makes me suspicious.)   That might mean that the freeze happens only
> when certain values are written, or when they are written closely in
> time to some other action - being used to communicate something to the
> SMM code).   If there is some race in when Linux's port 80 writes happen
> that happen to change the meaning of a request to the hardware or to
> SMM, then we could be rarely stepping on

That does imply some muppet 'extended' the debug interface for power
management on your laptop. Also pretty much proves that for such systems
we do have to move from port 0x80 to another delay approach.

Ingo - the fact that so many ISA bus devices need _p to mean "ISA bus
clocks" says to me we should keep the _p port 0x80 using variant for old
systems/device combinations (eg ISA ethernet cards) which won't show up
in any problem system (we know this from 15 odd years of testing), but
stop using it for PCI and embedded devices on modern systems.

Alan

