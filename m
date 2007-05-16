Return-Path: <linux-kernel-owner+w=401wt.eu-S1759794AbXEPQG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759794AbXEPQG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 12:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756439AbXEPQGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 12:06:22 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:51189 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756413AbXEPQGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 12:06:21 -0400
Date: Wed, 16 May 2007 18:04:45 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: ark3116_driver@auctionant.de
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-serial@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: ark3116: receive returns negative
Message-ID: <Pine.LNX.4.61.0705161743250.9570@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,


I seem to have problems with the ark3116 driver from 2.6.18.8. This is a 
USB-RS232 cable. Just opening the /dev/ttyUSB0 device 
gives (this is the 
debug output enabled by `modprobe ark3116 debug=1`).

The lines that look suspicious are
/serial/ark3116.c: 124 < 1 bytes [0xFFFFFFB0]
and
/serial/ark3116.c: ark3116_ioctl cmd 0x5401 not supported

I have also seen things like "id here < -62 [0x10]", which would 
indicate that usb_control_msg() returned something very negative 
(-ETIME!?).

Issuing a write() on an open fd to ttyUSB does not generate any further 
debug output. Is the driver even complete/functional?
I do not know where to go from here, please advise.


Full output:
/serial/ark3116.c: ark3116_open - port 0
/serial/ark3116.c: 111 < 1 bytes [0x03]
/serial/ark3116.c: 112 > ok
/serial/ark3116.c: 113 > ok
/serial/ark3116.c: 114 > ok
/serial/ark3116.c: 115 > ok
/serial/ark3116.c: 116 < 1 bytes [0x03]
/serial/ark3116.c: 117 > ok
/serial/ark3116.c: 118 < 1 bytes [0x02]
/serial/ark3116.c: 119 > ok
/serial/ark3116.c: 120 < 1 bytes [0x00]
/serial/ark3116.c: 121 > ok
/serial/ark3116.c: 122 < 1 bytes [0x01]
/serial/ark3116.c: 123 > ok
/serial/ark3116.c: 124 < 1 bytes [0xFFFFFFB0]
/serial/ark3116.c: ark3116_set_termios - port 0
/serial/ark3116.c: setting CS8
/serial/ark3116.c: setting parity to NONE
/serial/ark3116.c: setting 1 stop bit
/serial/ark3116.c: 000 < 1 bytes [0x02]
/serial/ark3116.c: setting baudrate to 9600 (->reg=312)
/serial/ark3116.c: 147 > ok
/serial/ark3116.c: 148 > ok
/serial/ark3116.c: 149 > ok
/serial/ark3116.c: 150 > ok
/serial/ark3116.c: 151 < 1 bytes [0x03]
/serial/ark3116.c: 152 > ok
/serial/ark3116.c: updating bit count, stop bit or parity (cfg=0x03)
/serial/ark3116.c: 153 < 1 bytes [0x00]
/serial/ark3116.c: 154 > ok
/serial/ark3116.c: ark3116_ioctl cmd 0x5401 not supported


	Jan
-- 
