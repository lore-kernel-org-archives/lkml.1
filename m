Return-Path: <linux-kernel-owner+w=401wt.eu-S1754957AbYHKQzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbYHKQzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 12:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbYHKQzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 12:55:39 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:42908 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbYHKQzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 12:55:38 -0400
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Aug 2008 12:55:38 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=IqYvTjsKGbQ8SRX7PhmyezmEmk8I+Q+WNfZLXi/7mc/lmTO+BiAugcOElRZ5DcogGI
         GSuGZHNoKQLI3ndNSIlbAlK44HBxKnCglUGTykaaMsn8x+D/klGv4WNbTEIv6Ka06lvk
         8F5yNviL8Ns31ydY4l2j/FgyuC9dM7Xv459ps=
Message-ID: <19f34abd0808110949n5d7d363es66325b87a8fb0fd1@mail.gmail.com>
Date: Mon, 11 Aug 2008 18:49:13 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: latest -git: kernel hangs when pulling the plug on 8139too
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am experiencing a system hang as soon as pull the cable out of eth0.
Kernel version is unmodified latest -git
(v2.6.27-rc2/796aadeb1b2db9b5d463946766c5bbfd7717158c) and my network
driver is 8139too (for both eth0 and eth1).

I am running netconsole on eth0 (the interface which I disconnect).

A bit of serial console (ttyS0) output:

Linux version 2.6.27-rc2-00325-g796aade (vegardno@ben.ifi.uio.no) (gcc
version 4.1.2 20071124 (Red Hat 4.1.2-42)) #2 SMP PREEMPT Mon Aug 11
18:29:29 CEST 2008
...
Kernel command line: ro root=/dev/VolGroup00/LogVol00 rhgb
console=tty0 console=ttyS0,115200 ignore_loglevel debug initcall_debug
nmi_watchdog=1 panic=30 sysrq_always_enabled
netconsole=@192.168.0.172/,@192.168.0.11/ 3
...
calling  rtl8139_init_module+0x0/0x20
8139too Fast Ethernet driver 0.9.28
8139too 0000:02:01.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
eth0: RealTek RTL8139 at 0xf881ac00, 00:10:a7:09:48:52, IRQ 18
eth0:  Identified 8139 chip type 'RTL-8139C'
8139too 0000:02:05.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
eth1: RealTek RTL8139 at 0xf881c000, 00:16:ec:ee:ad:b9, IRQ 21
eth1:  Identified 8139 chip type 'RTL-8100B/8139D'
initcall rtl8139_init_module+0x0/0x20 returned 0 after 37 msecs
...
eth0: link down
[hangs here; num lock + scroll lock flashing]
[reboots automatically, probably due to NMI watchdog?]

There is no detailed crash output on either tty0 or ttyS0. Keyboard
sysrq does not work.

Is it expected that pulling the plug on an interface running
netconsole should hang the machine? Is there anything I can do to help
narrow down the problem? I'd like to avoid a bisect (esp. since I
don't know the latest good version), but it is a possible solution.

Thanks,


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
