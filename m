Return-Path: <linux-kernel-owner+w=401wt.eu-S1758302AbXGCStJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302AbXGCStJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 14:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756382AbXGCSs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 14:48:57 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:54494 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756290AbXGCSs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 14:48:56 -0400
Date: Tue, 3 Jul 2007 20:48:53 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: "Midhun Agnihotram" <agnimidhun@gmail.com>
Cc: "=?UTF-8?B?SGFucy1Kw7xyZ2Vu?= Koch" <hjk@linutronix.de>, jdi@l4x.org,
       linux-kernel@vger.kernel.org
Subject: Re: Fwd: Mounting MMC card
Message-ID: <20070703204853.57ecea17@poseidon.drzeus.cx>
In-Reply-To: <4dde4acb0707030209n7b3b9236q2619a67f5c4dad5e@mail.gmail.com>
References: <4dde4acb0706261146s5906d8f3vb787d5aecb429116@mail.gmail.com>
	<4684CDCC.9030202@drzeus.cx>
	<4dde4acb0706290230g6a38f0cds47b0d76216f861e6@mail.gmail.com>
	<4684D358.9090402@drzeus.cx>
	<4dde4acb0706290245t5810b9ebrbb682ecb72f21830@mail.gmail.com>
	<4684DEF3.5060103@drzeus.cx>
	<4dde4acb0706290357x54d3ea32vaf75d5cfe638cb25@mail.gmail.com>
	<4684E65F.2070202@drzeus.cx>
	<4dde4acb0706290406v204fb87eif0e5fbae17636593@mail.gmail.com>
	<4684E8C2.7050109@drzeus.cx>
	<4dde4acb0707030209n7b3b9236q2619a67f5c4dad5e@mail.gmail.com>
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.11.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2007 14:39:40 +0530
"Midhun Agnihotram" <agnimidhun@gmail.com> wrote:

> Hi All,
> 
>    This is referring to my problem - not able to mount MMC card. I
> have some output from dmesg when I remove and put the card back (I
> have changes the kernel config to include i.MX SPI and disabled the
> generic SPI). DOes this give any clue as to why the MMC card is not
> appaering in /proc/partions and /sysfs/block ??  Any help will of
> great use. The output of dmesg is as follows. I have removed and
> inserted the card twice.
> 
> 
> <7>MMC: starting cmd 00 arg 00000000 flags 00000040
> <7>MMC: req done (00): 1: 00000000 00000000 00000000 00000000

These two and the ones like them were the ones I expected to see in
your dumps. So since you've discovered a way to get them functioning,
we can proceed with the debugging.

> <7>MMC: starting cmd 01 arg 00000000 flags 00000061
> <7>imx-mmc imx-mmc.0: CMD01 (0x01) mask set to 0x003b
> <7>imx-mmc imx-mmc.0: RESP 0x00000000, 0x00000000, 0x00000000,
> 0x00000000, error 0
> <7>MMC: req done (01): 0: 00000000 00000000 00000000 00000000

Here's your problem. CMD01 is a command that queries the cards for
their voltages. And the response is "no voltages". So either your host
driver is buggy, or your card is.

Have you tested with some other cards?

Also, the i.MX host driver is known to be a bit buggy. I would suggest
sending some questions out on the arm linux kernel mailing list as that
is where it's usually discussed.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
