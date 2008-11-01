Return-Path: <linux-kernel-owner+w=401wt.eu-S1752933AbYKAWpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbYKAWpZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 18:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbYKAWpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 18:45:13 -0400
Received: from vena.lwn.net ([206.168.112.25]:52335 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbYKAWpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 18:45:11 -0400
Date: Sat, 1 Nov 2008 16:45:09 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: "Yinghai Lu" <yinghai@kernel.org>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Robert Hancock" <hancockr@shaw.ca>,
       e1000-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
       "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: 2.6.28-rc2 hates my e1000e
Message-ID: <20081101164509.5e53762c@bike.lwn.net>
In-Reply-To: <86802c440811011250g662b8c4di31f2e391c910954e@mail.gmail.com>
References: <fa.P5jmIAOhSJ192sfWD+qlec07fe8@ifi.uio.no>
	<86802c440810302108h48046c08x3bbdcd0e35fd31b7@mail.gmail.com>
	<alpine.LFD.2.00.0810310800120.21084@nehalem.linux-foundation.org>
	<alpine.LFD.2.00.0810310839380.21084@nehalem.linux-foundation.org>
	<20081031100040.1f0cf34f@bike.lwn.net>
	<alpine.LFD.2.00.0810310916050.21084@nehalem.linux-foundation.org>
	<20081031105105.092ebad3@bike.lwn.net>
	<alpine.LFD.2.00.0810310953550.21084@nehalem.linux-foundation.org>
	<20081101090154.3d014f57@bike.lwn.net>
	<alpine.LFD.2.00.0811010958230.6226@nehalem.linux-foundation.org>
	<86802c440811011250g662b8c4di31f2e391c910954e@mail.gmail.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Nov 2008 12:50:20 -0700
"Yinghai Lu" <yinghai@kernel.org> wrote:

> Jonathan, can you try patch i sent?
> 
> http://lkml.org/lkml/2008/10/31/274
> [PATCH] x86: remove PCI bar range from e820 reserved entries

OK, I tried it.  No joy.  

Nov  1 16:39:14 bike kernel: [    9.106529] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
Nov  1 16:39:14 bike kernel: [    9.106533] e1000e: Copyright (c) 1999-2008 Intel Corporation.
Nov  1 16:39:14 bike kernel: [    9.106580] e1000e 0000:00:19.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
Nov  1 16:39:14 bike kernel: [    9.106588] e1000e 0000:00:19.0: BAR 0: can't reserve mem region [0xfe9e0000-0xfe9fffff]
Nov  1 16:39:14 bike kernel: [    9.106593] e1000e 0000:00:19.0: PCI INT A disabled
Nov  1 16:39:14 bike kernel: [    9.106599] e1000e: probe of 0000:00:19.0 failed with error -16

With this patch in, iomem looks like:

00000000-0009fbff : System RAM
000f0000-000fffff : reserved
00100000-be4ff7ff : System RAM
  00200000-004a6e45 : Kernel code
  004a6e46-0064ab77 : Kernel data
  006c4000-007585ff : Kernel bss
be4ff800-be553bff : ACPI Non-volatile Storage
be553c00-be555bff : ACPI Tables
be555c00-beffffff : reserved
c0000000-cfffffff : 0000:00:02.0
d0000000-d3ffffff : PCI Bus 0000:02
  d0000000-d3ffffff : 0000:02:00.0
    d0000000-d07fffff : ivtv encoder
    d2000000-d200ffff : ivtv registers
d4000000-d4000fff : Intel Flush Page
e0000000-fe7fffff : reserved
fe800000-fe8fffff : PCI Bus 0000:01
  fe800000-fe8fffff : reserved
fe900000-fe9d9aff : reserved
fe9d9b00-fe9d9bff : 0000:00:1f.3
  fe9d9b00-fe9d9bff : reserved
fe9d9c00-fe9d9fff : 0000:00:1a.7
  fe9d9c00-fe9d9fff : reserved
fe9da000-fe9dafff : 0000:00:03.3
  fe9da000-fe9dafff : reserved
fe9db000-fe9dbfff : 0000:00:19.0
  fe9db000-fe9dbfff : reserved
fe9dc000-fe9dffff : 0000:00:1b.0
  fe9dc000-fe9dffff : reserved
fe9e0000-fe9fffff : 0000:00:19.0
  fe9e0000-fe9fffff : reserved
fea00000-fea7ffff : 0000:00:02.0
  fea00000-fea59aff : reserved
fea80000-feafffff : 0000:00:02.1
feb00000-febfffff : 0000:00:02.0
fec00000-fec00fff : IOAPIC 0
fed00000-fed003ff : HPET 0
fed20000-fed9ffff : reserved
fedad000-fedad00f : 0000:00:03.0
fee00000-feefffff : reserved
  fee00000-fee00fff : Local APIC
ff980800-ff980bff : 0000:00:1d.7
  ff980800-ff980bff : ehci_hcd
ffb00000-ffffffff : reserved

Looks to me like Linus's patch is the way to go, at least for now...

jon
