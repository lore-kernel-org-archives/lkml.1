Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbXLJVwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbXLJVwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 16:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbXLJVwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 16:52:11 -0500
Received: from hamlet.e18.physik.tu-muenchen.de ([129.187.154.223]:52775 "EHLO
	hamlet.e18.physik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751214AbXLJVwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 16:52:10 -0500
X-Greylist: delayed 1575 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Dec 2007 16:52:09 EST
Message-ID: <53905.88.217.68.129.1197321951.squirrel@www.e18.physik.tu-muenchen.de>
Date: Mon, 10 Dec 2007 22:25:51 +0100 (CET)
Subject: Re: Possibly SATA related freeze killed networking and RAID
From: "Thiemo Nagel" <thiemo.nagel@ph.tum.de>
To: linux-kernel@vger.kernel.org
Cc: noah123@gmail.com
User-Agent: SquirrelMail/1.4.4
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I think, I'm experiencing the same problem:

09:16:34 : NETDEV WATCHDOG: eth0: transmit timed out
09:16:34 : eth0: Got tx_timeout. irq: 00000000
09:16:34 : eth0: Ring at 37e50000
09:16:34 : eth0: Dumping tx registers
09:16:34 :   0: 00000000 000000ff 00000003 025003ca 00000000 00000000
00000000 00000000
09:16:34 :  20: 00000000 00000000 00000000 00000000 00000000 00000000
00000000 00000000

[...]

09:16:54 : ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
09:16:54 : ata6.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
09:16:54 : ata6.00: cmd 25/00:08:1e:97:48/00:00:19:00:00/e0 tag 0 cdb 0x0
data 4096 in
09:16:54 :          res 40/00:00:01:4f:c2/00:00:00:00:00/00 Emask 0x4
(timeout)
09:16:54 : ata5.00: cmd 25/00:70:1e:97:48/00:00:19:00:00/e0 tag 0 cdb 0x0
data 57344 in
09:16:54 :          res 40/00:00:01:4f:c2/00:00:00:00:00/00 Emask 0x4
(timeout)
09:16:54 : ata6: soft resetting port
09:16:54 : ata5: soft resetting port
09:16:54 : ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
09:16:54 : ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
09:16:54 : NETDEV WATCHDOG: eth0: transmit timed out
09:16:54 : eth0: Got tx_timeout. irq: 00000032
09:16:54 : eth0: Ring at 37e50000
09:16:54 : eth0: Dumping tx registers

A more complete log can be found at:
http://www.e18.physik.tu-muenchen.de/~tnagel/misc/kernel-crash.log

The setup is strikingly similar to that of noah (I'm quoting all of this
by heart, if somebody is interested in more detail, just ask.):

Kernel: 2.6.22 (amd64, Debian patches, tainted)
Mainboard: Asus M2N-SLI Deluxe (nForce 570 SLI MCP --> MCP55, same as noah)
CPU: Athlon64 Dual-Core (same as noah)
RAM: 1GB
HD: 22 x Samsung HD501LJ 500GB (same as noah), 1-6 connected to chipset,
7-22 connected to RocketRaid 2340.

I'm using software RAID like noah, (levels 1, 5 and 6), and like with noah
the problem occurred during RAID check, in my case during heavy NFS load
which had been ongoing for ~4 days.  This is the third time, it has
happened, but only this time I could catch the logs via netconsole.  The
two affected drives are connected to the chipset and show no SMART errors.

Unfortunately, the kernel is tainted since I'm using HighPoint's drivers
for the RR2340.  I don't know whether I can change this easily.

Kind regards,

Thiemo Nagel

