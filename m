Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbXD1S7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbXD1S7U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756106AbXD1S7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:59:20 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756096AbXD1S7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 14:59:18 -0400
Date: Sat, 28 Apr 2007 11:59:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: davidhart@tqmcube.com
Cc: "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 8392] New: Hard Lock Subsequent to Boot
Message-Id: <20070428115906.86e93af6.akpm@linux-foundation.org>
In-Reply-To: <200704281634.l3SGYhJX014704@fire-2.osdl.org>
References: <200704281634.l3SGYhJX014704@fire-2.osdl.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(please reply via email, retaining all cc's)

On Sat, 28 Apr 2007 09:34:43 -0700 bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=8392
> 
>            Summary: Hard Lock Subsequent to Boot
>     Kernel Version: 2.6.21/2,6,21.1
>             Status: NEW
>           Severity: blocking
>              Owner: other_other@kernel-bugs.osdl.org
>          Submitter: davidhart@tqmcube.com
> 
> 
> Most recent kernel where this bug did *NOT* occur:
> 2.6.20.8
> 
> Distribution:
> Fedora Core 6
> 
> Hardware Environment:
> Sony Vaio 2.4gh/512 mb
> 00:00.0 Host bridge: Silicon Integrated Systems [SiS] 645xx (rev 03)
> 00:01.0 PCI bridge: Silicon Integrated Systems [SiS] SG86C202
> 00:02.0 ISA bridge: Silicon Integrated Systems [SiS] SiS963 [MuTIOL Media IO]
> (rev 14)
> 00:02.1 SMBus: Silicon Integrated Systems [SiS] SiS961/2 SMBus Controller
> 00:02.5 IDE interface: Silicon Integrated Systems [SiS] 5513 [IDE]
> 00:02.6 Modem: Silicon Integrated Systems [SiS] AC'97 Modem Controller (rev a0)
> 00:02.7 Multimedia audio controller: Silicon Integrated Systems [SiS] AC'97
> Sound Controller (rev a0)
> 00:03.0 USB Controller: Silicon Integrated Systems [SiS] USB 1.0 Controller (rev 0f)
> 00:03.1 USB Controller: Silicon Integrated Systems [SiS] USB 1.0 Controller (rev 0f)
> 00:03.2 USB Controller: Silicon Integrated Systems [SiS] USB 1.0 Controller (rev 0f)
> 00:03.3 USB Controller: Silicon Integrated Systems [SiS] USB 2.0 Controller
> 00:04.0 Ethernet controller: Silicon Integrated Systems [SiS] SiS900 PCI Fast
> Ethernet (rev 90)
> 00:07.0 Ethernet controller: Atheros Communications, Inc. AR5212 802.11abg NIC
> (rev 01)
> 00:0a.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev aa)
> 00:0a.1 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev aa)
> 00:0a.2 FireWire (IEEE 1394): Ricoh Co Ltd R5C552 IEEE 1394 Controller (rev 02)
> 01:00.0 VGA compatible controller: nVidia Corporation NV17 [GeForce4 420 Go]
> (rev a3)
> Software Environment:
> 
> KDE.
> Kernel compiled with full debugging
> Standard nv driver - NOT nvidia.
> 
> Problem Description:
> 
> Kernel boots. X starts. Hard lock occurs immediately on launching an
> application. Complete freeze  stops logging (no panic or error messages. No
> debug information whatsoever. Neither SysReq nor alt-ctl-del are responsive.
> 
> Steps to reproduce:
> 
> Boot into X. Launch any application (web, mail client, etc).

Lovely regression.

If you have time, there are a couple of things to do here:

1: Watch virtual terminal #1 while starting that appliction.  ie: in an
   xterm (assuming you can open one) do

	sleep 5; mozilla

   then do a quick alt-shift-F1 before the sleep expires.  See if
   anything comes up on the console.

2: get netconsole working: see Documentation/networking/netconsole.txt

3: Performa a git bisection search, find the buggy patch.  This is quite a
   lot of work, and I hate asking people to do it because we don't (afaik)
   have any particularly good documentation on how to perform it.

