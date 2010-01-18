Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886Ab0ARUO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab0ARUO1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 15:14:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697Ab0ARUOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 15:14:25 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:46980 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab0ARUOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 15:14:23 -0500
Date: Mon, 18 Jan 2010 20:14:16 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: dvomlehn@cisco.com, gregkh@suse.de, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial
	writes" causes gobi_loader to hang
Message-ID: <20100118201416.GA26511@srcf.ucam.org>
References: <20100117025535.GB7045@srcf.ucam.org> <201001171014.44403.oliver@neukum.org> <20100118015844.GA4300@srcf.ucam.org> <201001181825.39823.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001181825.39823.oliver@neukum.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 06:25:39PM +0100, Oliver Neukum wrote:

> it is not conclusive. Can you apply the attached patch and try again?

qcserial ttyUSB0: usb_serial_generic_write_start - length = 512, data = 
drivers/usb/serial/generic.c: usb_serial_generic_write - put 1024 bytes 
into fifo
drivers/usb/serial/usb-serial.c: serial_write - port 0, 29 byte(s)
drivers/usb/serial/generic.c: usb_serial_generic_write - port 0, 29 
bytes
drivers/usb/serial/generic.c: usb_serial_generic_write - put 0 bytes 
into fifo
e1 0e 20 83 e0 40 10 92 e5 01 00 80 e2 0c 30 83 e0 02 00 50 e3 e8 10 83 
e5 f7 ff ff da 0c 30 9e e5 f4 30 8c e5 24 10 9c e5 1c
 20 9e e5 20 00 9c e5 00 30 a0 e3 14 30 8c e5 f8 20 8c e5 08 11 8c e5 0c 
01 8c e5 04 f0 9d e4 04 d0 4d e2 01 60 a0 e1 02 70 a
0 e1 03 40 a0 e1 00 50 a0 e1 04 80 9d e5 e1 ff ff eb 78 31 9f e5 0c 20 
95 e5 00 10 93 e5 01 00 52 e1 40 00 00 0a 00 00 54 e3 
1f 30 e0 13 1b 30 e0 03 01 00 54 e3 00 20 a0 13 01 20 a0 03 82 30 83 e1 
03 00 54 e3 03 20 a0 11 01 20 83 03 02 00 54 e3 06 20
 82 03 02 30 a0 e3 00 30 8d e5 b2 20 cd e1 00 30 9d e5 08 c0 95 e5 03 39 
83 e3 00 30 8d e5 40 30 8c e5 44 60 8c e5 48 70 8c e5 1c 00 95 e5 a0 32 
a0 e1 7f 3f c3 e3 ff 33 c3 e3 0f 35 c3 e3 0e e2 83 e2 08 10 9e e5 00 00 
51 e3 14 00 00 0a 0a 30 d1 e5 60 31 8e e5 0b 20 d1 e5 64 21 8e e5 0a 30 
dc e5 0a 30 c1 e5 08 20 95 e5 0b 30 d2 e5 0b 30 c1 e5 7c 30 95 e5 38 20 
8e e2 80 00 13 e3 44 30 92 15 80 30 83 13 44 30 82 15 7c 30 95 15 40 00 
13 e3 44 30 92 15 40 30 83 13 44 30 82 15 1c 00 95 e5 0f 22 a0 e3 04 10 
92 e5 2c 30 91 e5 8c 20 9f e5 01 30 83 e3 2c 30 81 e5 80 20 85 e5 50 81 
85 e5 7c 30 9f e5 00 10 a0 e1 78 e0 9f e5 03 f0 a0 e1 fe ff ff ea 1c 30 
95 e5 00 00 53 e3 bb ff ff 1a 01 00 54 e3 60 10 9f 05 0a 00 00 0a 00 00 
54 e3 58 10 9f 05 07 00 00 0a 03 00 54 e3 50 10 9f 05 04 00 00 0a 4c 20 
9f e5 4c 30 9f e5 02 00 54 e3 02 10 a0 11 03 10 a0 01 06 20 a0 e1 07 30 
a0 e1 38 00 9f e5 b4 3e 00 eb 34 00 9f e5 dd 05 00 eb fe df 8d e3 08 f0 
a0 e1 fe ff ff ea f0 c1 01 f0 f4 7f 00 f0 8c 89 00 f0 10 b6 00 f0 e0 0a 
01 f0 e8 0a 01 f0 f0 0a 01 
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 29 byte(s)
drivers/usb/serial/generic.c: usb_serial_generic_write - port 0, 29 
bytes
drivers/usb/serial/generic.c: usb_serial_generic_write - put 0 bytes 
into fifo
drivers/usb/serial/generic.c: usb_serial_generic_write_bulk_callback - 
port 0
drivers/usb/serial/generic.c: usb_serial_generic_write_start - starting 
IO
qcserial ttyUSB0: usb_serial_generic_write_start - length = 512, data = 
f0 f8 0a 01 f0 00 0b 01 f0 0c 10 01 f0 38 10 01 f0 0f 22 a0 e3 04 40 92 
e5 1c 30 94 e5 a3 32 a0 e1 7f 3f c3 e3 ff 33 c3 e3 0f 35 c3 e3 0e 12 83 
e2 08 00 91 e5 00 00 50 e3 0a 00 00 0a 0a 20 d0 e5 02 00 52 e3 0d 00 00 
0a 60 31 91 e5 0a 30 c0 e5 64 21 91 e5 0b 20 c0 e5 38 10 81 e2 44 30 91 
e5 c0 30 c3 e3 44 30 81 e5 04 00 a0 e1 96 fc ff eb 50 31 94 e5 fe df 8d 
e3 03 f0 a0 e1 fe ff ff ea 08 30 94 e5 0a 20 c3 e5 38 20 84 e2 44 30 92 
e5 80 30 83 e3 44 30 82 e5 ea ff ff ea 02 60 a0 e1 01 50 a0 e1 04 d0 4d 
e2 00 70 a0 e1 03 80 a0 e1 4d ff ff eb a5 2f a0 e1 86 30 82 e1 00 00 a0 
e3 2f 20 e0 e3 00 00 8d e5 b2 20 cd e1 00 10 9d e5 03 19 81 e3 00 10 8d 
e5 a6 4f a0 e1 a3 20 a0 e1 84 3f 82 e1 08 20 97 e5 48 30 82 e5 0f 32 a0 
e3 40 10 82 e5 0c 00 82 e5 44 50 82 e5 04 10 93 e5 2c 30 91 e5 e4 00 97 
e5 20 20 9f e5 01 30 83 e3 2c 30 81 e5 80 20 87 e5 50 81 87 e5 10 30 9f 
e5 00 10 a0 e1 0c e0 9f e5 03 f0 a0 e1 fe ff ff ea 20 81 00 f0 8c 89 00 
f0 10 b6 00 f0 0f 32 a0 e3 04 40 93 e5 08 20 94 e5 40 30 92 e5 04 d0 4d 
e2 00 30 8d e5 04 00 a0 e1 5b fc ff eb d1 30 dd e1 00 00 53 e3 03 00 00 
ba 50 31 94 e5 fe df 8d e3 03 f0 a0 e1 fe ff ff ea 04 00 9f e5 73 05 00 
eb f8 ff ff ea 4c 10 01 f0 0f c2 a0 e3 18 40 dc e5 18 d0 4d e2 00 00 54 
e3 0e 60 a0 e1 14 00 8d e5 01 a0 a0 e1 10 20 8d e5 03 90 a0 e1 20 b0 9d 
e5 51 01 00 1a 0f 32 a0 e3 04 80 93 e5 50 26 9f e5 0c 30 98 e5 00 10 92 
e5 01 00 53 e1 00 00 a0 13 01 00 a0 03 00 00 50 e3 41 01 00 0a 14 50 9d 
e5 01 20 75 e2 00 20 a0 33 00 00 52 e3 0d 00 00 1a b4 31 dd e1 3f 00 13 
e3 02 30 a0 e1 03 00 00 
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 29 byte(s)
drivers/usb/serial/generic.c: usb_serial_generic_write - port 0, 29 
bytes
drivers/usb/serial/generic.c: usb_serial_generic_write - put 29 bytes 
into fifo
drivers/usb/serial/usb-serial.c: serial_write - port 0, 2048 byte(s)
drivers/usb/serial/generic.c: usb_serial_generic_write - port 0, 2048 
bytes
drivers/usb/serial/generic.c: usb_serial_generic_write - put 483 bytes 
into fifo
drivers/usb/serial/usb-serial.c: serial_write - port 0, 1565 byte(s)
drivers/usb/serial/generic.c: usb_serial_generic_write - port 0, 1565 
bytes
drivers/usb/serial/generic.c: usb_serial_generic_write - put 0 bytes 
into fifo
drivers/usb/serial/generic.c: usb_serial_generic_read_bulk_callback - 
port 0

-- 
Matthew Garrett | mjg59@srcf.ucam.org
