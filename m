Return-Path: <linux-kernel-owner+w=401wt.eu-S1758423AbXL3VWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758423AbXL3VWx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 16:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032AbXL3VWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 16:22:46 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39050 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755004AbXL3VWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 16:22:45 -0500
Date: Sun, 30 Dec 2007 21:13:29 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rene Herman <rene.herman@keyaccess.nl>, Ingo Molnar <mingo@elte.hu>,
       dpreed@reed.com, Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
Message-ID: <20071230211329.39ae77c2@the-village.bc.nu>
In-Reply-To: <alpine.LFD.1.00.0712301009220.32517@woody.linux-foundation.org>
References: <477711DC.5030800@keyaccess.nl>
	<alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org>
	<20071230144700.78f4605c@the-village.bc.nu>
	<20071230152835.GX16946@elte.hu>
	<4777BDA5.4050203@keyaccess.nl>
	<alpine.LFD.1.00.0712301009220.32517@woody.linux-foundation.org>
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

> But that does't mean that other ports won't have the same timings. Also, 
> it doesn't mean that we really need to have exactly *those* timings.

For ISA bus you want "at least" those timings. That is an easy case
anyway - ISA bus boxes, old processors and generally no TSC so we can
fall back to 0x80 - we know from 15 years experience the problem only
occurs with recent non ISA systems that have borked firmware.

Lots of ISA hardware does really need the delays and most of it will be
on old processors as well naturally enough.

> I also think that the worries about PCI write posting are unnecessary. IO 
> port accesses (ie a regular "inb()" and "outb()" even _without_ the "_p()" 
> format slowdown) are already synchronous not only by the CPU but by all 

Ok then the SCSI examples should be fine (although as I said I think they
are possibly bogus anyway)

Alan
