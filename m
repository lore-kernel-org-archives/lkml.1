Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933830Ab0BET60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 14:58:26 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:59683 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236Ab0BET6Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 14:58:25 -0500
Date: Fri, 5 Feb 2010 19:58:17 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: dvomlehn@cisco.com, gregkh@suse.de, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial
	writes" causes gobi_loader to hang
Message-ID: <20100205195817.GA14285@srcf.ucam.org>
References: <20100117025535.GB7045@srcf.ucam.org> <201002031821.39532.oliver@neukum.org> <20100203223737.GA2578@srcf.ucam.org> <201002032358.03552.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <201002032358.03552.oliver@neukum.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is what I get immediately before the hang.

drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 1024 byte(s)
drivers/usb/serial/generic.c: usb_serial_generic_write - port 0, 1024 bytes
drivers/usb/serial/generic.c: usb_serial_generic_write - put 512 bytes into fifo
drivers/usb/serial/usb-serial.c: serial_write - port 0, 512 byte(s)
drivers/usb/serial/generic.c: usb_serial_generic_write - port 0, 512 bytes
drivers/usb/serial/generic.c: usb_serial_generic_write - put 0 bytes into fifo
drivers/usb/serial/generic.c: usb_serial_generic_write - FIFO is full
drivers/usb/serial/generic.c: usb_serial_generic_write_bulk_callback - port 0
drivers/usb/serial/generic.c: usb_serial_generic_write_start - starting IO
qcserial ttyUSB0: usb_serial_generic_write_start - length = 512, data = 28 10 94
 e5 0c 30 84 e2 0c 00 13 e8 02 20 43 e0 40 01 9f e5 02 20 81 e0 13 f7 ff eb 04 0
0 a0 e1 e6 01 00 eb 00 00 50 e3 3c 00 00 1a 00 30 96 e5 04 20 96 e5 04 20 83 e5 
04 10 96 e5 06 00 a0 e1 00 30 81 e5 d0 07 00 eb 08 d0 8d e2 f0 85 bd e8 04 00 a0
 e1 1b fe ff eb f8 00 9f e5 08 10 84 e2 06 00 91 e8 e2 f7 ff eb ec 00 9f e5 08 1
0 84 e2 06 00 91 e8 e7 ff ff ea 47 3f a0 e3 02 30 83 e2 d8 00 9f e5 d8 10 9f e5 
d8 20 9f e5 78 12 00 eb 20 30 94 e5 18 00 13 e3 d4 ff ff 0a 04 00 a0 e1 08 fe ff
 eb b0 00 9f e5 08 10 84 e2 06 00 91 e8 ed f6 ff eb 20 30 94 e5 10 00 13 e3 d6 f
f ff 0a 08 50 84 e2 a0 00 95 e8 07 00 55 e1 d2 ff ff 2a 04 a0 8d e2 0d 80 a0 e1 
03 00 00 ea 01 30 a0 e3 13 52 85 e0 07 00 55 e1 cb ff ff 2a 08 20 a0 e1 05 00 a0
 e1 0a 10 a0 e1 45 05 00 eb 0c 20 a0 e3 00 00 50 e3 04 20 8d 05 05 00 a0 e1 f2 f
f ff 0a 04 10 9d e5 e2 05 00 eb 04 20 9d e5 ee ff ff ea 4b 3f a0 e3 03 30 83 e2 
3c 00 9f e5 30 10 9f e5 30 20 9f e5 4e 12 00 eb bb ff ff ea 46 3f a0 e3 01 30 83
 e2 24 00 9f e5 14 10 9f e5 14 20 9f e5 47 12 00 eb 9f ff ff ea 00 80 01 b0 00 b
0 01 b0 64 c9 00 b0 f4 c7 00 b0 d8 c7 00 b0 54 c6 00 b0 8c c9 00 b0 00 00 90 e5 
45 11 a0 e3 7b 15 81 e2 71 1a 81 e2 00 20 a0 e1 08 30 92 e5 01 00 53 e1 05 00 00
 1a 00 20 92 e5 00 30 92 e5 00 00 53 e1 f8 ff ff 1a 01 00 a0 e3 1e ff 2f e1 00 00 a0 e3 1e ff 2f e1 30 40 2d e9 01 30 a0 e3 01 40 a0 e1 02 50 a0 e1 00 10 a0 e1 00 20 a0 e3 28 00 9f e5 70 02 00 eb 00 30 50 e2 30 80 bd 08 08 20 93 e5 00 20 84 e5 0c 20 83 e2 0c 00 12 e8 02 30 43 e0 01 30 83 e2 00 30 85 e5 30 80 bd e8 7c bc 01 b0 
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 512 byte(s)
drivers/usb/serial/generic.c: usb_serial_generic_write - port 0, 512 bytes
drivers/usb/serial/generic.c: usb_serial_generic_write - put 512 bytes into fifo
drivers/usb/serial/usb-serial.c: serial_write - port 0, 2048 byte(s)
drivers/usb/serial/generic.c: usb_serial_generic_write - port 0, 2048 bytes
drivers/usb/serial/generic.c: usb_serial_generic_write - put 0 bytes into fifo
drivers/usb/serial/generic.c: usb_serial_generic_write - FIFO is full
drivers/usb/serial/generic.c: usb_serial_generic_write_bulk_callback - port 0
drivers/usb/serial/generic.c: usb_serial_generic_write_start - starting IO
qcserial ttyUSB0: usb_serial_generic_write_start - length = 512, data = 01 00 a0 e1 60 07 00 ea 00 00 9f e5 37 07 00 ea 54 60 01 b0 04 e0 2d e5 20 30 9f e5 04 d0 4d e2 00 10 a0 e1 0d 20 a0 e1 00 00 93 e5 01 1b 00 eb 00 00 50 e3 00 00 e0 13 04 d0 8d e2 00 80 bd e8 3c 70 01 b0 01 00 12 e3 70 40 2d e9 02 40 a0 e1 00 50 a0 e1 01 60 a0 e1 25 00 00 0a 20 40 85 e5 fc 00 9f e5 06 10 a0 e1 1b f7 ff eb 01 00 70 e3 08 00 85 e5 70 80 bd 08 06 30 80 e0 01 20 43 e2 10 40 14 e2 0c 20 85 e5 13 00 00 1a 00 10 a0 e1 d0 00 9f e5 7a f7 ff eb 00 00 50 e3 2a 00 00 0a ff 34 a0 e3 f0 2f 93 e5 05 10 a0 e1 00 00 92 e5 07 20 a0 e3 81 fe ff eb 00 00 50 e3 1c 00 00 1a 0c 30 85 e2 0c 00 13 e8 02 20 43 e0 04 10 a0 e1 01 20 82 e2 08 00 95 e5 78 12 00 eb 05 00 a0 e1 cb ff ff eb 00 40 50 e2 07 00 00 1a 04 00 a0 e1 70 80 bd e8 70 00 9f e5 70 10 9f e5 70 20 9f e5 9d 30 a0 e3 da 11 00 eb d3 ff ff ea 08 10 85 e2 06 00 91 e8 48 00 9f e5 53 f6 ff eb 0c 20 95 e5 40 00 9f e5 08 10 95 e5 31 f7 ff eb 04 00 a0 e1 70 80 bd e8 3c 00 9f e5 30 10 9f e5 30 20 9f e5 af 30 a0 e3 ca 11 00 eb dc ff ff ea 10 00 9f e5 08 10 85 e2 06 00 91 e8 43 f6 ff eb 00 00 e0 e3 70 80 bd e8 00 b0 01 b0 00 80 01 b0 10 ca 00 b0 24 ca 00 b0 94 c9 00 b0 54 c6 00 b0 02 00 13 e3 f0 41 2d e9 03 70 a0 e1 00 60 a0 e1 01 40 a0 e1 02 50 a0 e1 15 00 00 0a 04 30 85 e0 01 40 43 e2 20 70 86 e5 08 50 86 e5 0c 40 86 e5 06 00 a0 e1 97 ff ff eb 00 80 50 e2 08 00 a0 11 f0 81 bd 18 04 20 a0 e1 c4 00 9f e5 05 10 a0 e1 54 f7 ff eb 04 20 a0 e1 05 10 a0 e1 b4 00 9f e5 50 f7 ff eb 10 40 17 e2 07 00 00 0a 08 00 a0 e1 f0 81 bd e8 a0 00 9f e5 a0 10 9f e5 a0 20 9f e5 c3 30 a0 e3 
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 2048 byte(s)
drivers/usb/serial/generic.c: usb_serial_generic_write - port 0, 2048 bytes
drivers/usb/serial/generic.c: usb_serial_generic_write - put 512 bytes into fifo
drivers/usb/serial/usb-serial.c: serial_write - port 0, 1536 byte(s)
drivers/usb/serial/generic.c: usb_serial_generic_write - port 0, 1536 bytes
drivers/usb/serial/generic.c: usb_serial_generic_write - put 0 bytes into fifo
drivers/usb/serial/generic.c: usb_serial_generic_write - FIFO is full



-- 
Matthew Garrett | mjg59@srcf.ucam.org
