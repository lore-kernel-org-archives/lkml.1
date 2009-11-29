Return-Path: <linux-kernel-owner+w=401wt.eu-S1753075AbZK3N4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbZK3N4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 08:56:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752938AbZK3N4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 08:56:32 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46786 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbZK3N4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 08:56:31 -0500
Date: Sun, 29 Nov 2009 16:58:01 +0100
From: Pavel Machek <pavel@ucw.cz>
To: linux-bluetooth@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: bluetooth cf slow (10KB/sec), lots of dmesg spam
Message-ID: <20091129155801.GA1634@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi!

I'm using CF bluetooth card:

toy:~# setserial -av /dev/ttyS0
/dev/ttyS0, Line 0, UART: 16950/954, Port: 0xc48202f8, IRQ: 201
	Baud_base: 921600, close_delay: 50, divisor: 0
	closing_wait: 3000
	Flags: spd_normal skip_test

toy:~# hciconfig
hci0:	Type: UART
	BD Address: 00:10:60:AB:25:9A ACL MTU: 192:8 SCO MTU: 64:8
	UP RUNNING PSCAN ISCAN 
	RX bytes:1612262 acl:5084 sco:0 events:3602 errors:0
	TX bytes:507156 acl:3779 sco:0 commands:28 errors:0


...and it mostly works, but slowly, and with tons of complains. Card
is:

toy:~# lspcmcia -v
Socket 0 Bridge:   	[pxa2xx-pcmcia] 	(bus ID: pxa2xx-pcmcia)
	Configuration:	state: on	ready: yes
			Voltage: 3.3V Vcc: 3.3V Vpp: 0.0V
Socket 0 Device 0:	[serial_cs]		(bus ID: 0.0)
	Configuration:	state: on
	Product Name:   Compact Flash Bluetooth Card 
	Identification:	manf_id: 0x0279	card_id: 0x950b
			function: 2 (serial)
			prod_id(1): "Compact Flash" (0x95521410)
			prod_id(2): "Bluetooth Card" (0x7664fb1d)
			prod_id(3): --- (---)
			prod_id(4): --- (---)

I believe the problem is 115200 bitrate between system and CF serial;
I did setserial baud_base 921600,  but that does not seem to speed it
up. Do I need to do some special magic to enable high speed?

Any ideas?
									Pavel

PM: Adding info for No Bus:hci0
bcsp_recv: Out-of-order packet arrived, got 1 expected 0
PM: Adding info for No Bus:rfcomm1
PM: Adding info for No Bus:hci0:41
PM: Adding info for No Bus:bnep0
bcsp_recv: Short BCSP packet
bcsp_recv: Out-of-order packet arrived, got 5 expected 4
bcsp_recv: Out-of-order packet arrived, got 6 expected 4
SysRq : Changing Loglevel
Loglevel set to 1
bcsp_recv: Short BCSP packet
bcsp_recv: Out-of-order packet arrived, got 1 expected 0
bcsp_recv: Out-of-order packet arrived, got 2 expected 0
bcsp_recv: Out-of-order packet arrived, got 3 expected 0
bcsp_recv: Short BCSP packet
...
bcsp_recv: Out-of-order packet arrived, got 2 expected 7
bcsp_recv: Short BCSP packet
bcsp_recv: Out-of-order packet arrived, got 7 expected 6
bcsp_recv: Out-of-order packet arrived, got 0 expected 6
bcsp_recv: Out-of-order packet arrived, got 1 expected 6
bcsp_recv: Short BCSP packet
bcsp_recv: Error in BCSP hdr checksum
bcsp_recv: Out-of-order packet arrived, got 4 expected 2
bcsp_recv: Out-of-order packet arrived, got 5 expected 2
bcsp_recv: Short BCSP packet
bcsp_recv: Out-of-order packet arrived, got 2 expected 1
bcsp_recv: Out-of-order packet arrived, got 3 expected 1
bcsp_recv: Out-of-order packet arrived, got 4 expected 1
bcsp_unslip_one_byte: Invalid byte 00 after esc byte
bcsp_recv: Out-of-order packet arrived, got 4 expected 3
bcsp_recv: Out-of-order packet arrived, got 5 expected 3
bcsp_recv: Out-of-order packet arrived, got 6 expected 3
bcsp_recv: Short BCSP packet

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
