Return-Path: <linux-kernel-owner+w=401wt.eu-S1756160AbZBPXoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbZBPXoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 18:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbZBPXn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 18:43:59 -0500
Received: from smtp8.mana.pf ([202.3.225.219]:48103 "EHLO smtp8.mana.pf"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbZBPXn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 18:43:58 -0500
X-Greylist: delayed 878 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Feb 2009 18:43:58 EST
Message-ID: <4999F6C8.3050001@sysnux.pf>
Date: Mon, 16 Feb 2009 13:29:12 -1000
From: Jean-Denis Girard <jd.girard@sysnux.pf>
Organization: SysNux
User-Agent: Thunderbird 2.0.0.19 (X11/20090114)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: linux-usb@vger.kernel.org
Subject: ttyUSB sendbreak problem
X-Enigmail-Version: 0.95.7
OpenPGP: url=http://www.sysnux.pf/jdg.asc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi list,

I'm writing a program which communicates via modem with an embedded
device (electrical network monitoring). The frames are terminated by a
BREAK.

My program works fine when I use a Cyclades 8Yo multiports card, but
fails using USB to serial adapters (tried with pl2303 and FTDI
converters). I suspect that the BREAK are not passed correctly, but I
don't have equipment to check.

I've tried with:
 tcsendbreak(modem,0);
 ioctl(modem, TCSBRK,0);
 ioctl(modem, TCSBRKP, 0);

- From pl2303 debug mode, I see that pl2303_break_ctl is called:
 drivers/usb/serial/pl2303.c: pl2303_break_ctl - port 0
 drivers/usb/serial/pl2303.c: pl2303_break_ctl - turning break on
 drivers/usb/serial/pl2303.c: pl2303_write_bulk_callback - port 0
 drivers/usb/serial/pl2303.c: pl2303_send - port 0
 drivers/usb/serial/pl2303.c: pl2303_break_ctl - port 0
 drivers/usb/serial/pl2303.c: pl2303_break_ctl - turning break off

I found a few references of similar problems in the past, but it was for
older kernels (I'm using 2.6.28.4), so the question remains: should it
work or is there a known problem sending BREAK using ttyUSB?


Thanks,
- --
Jean-Denis Girard

SysNux                  Systèmes  Linux  en Polynésie française
http://www.sysnux.pf/   Tél: +689 50 10 40 / GSM: +689 79 75 27
-----BEGIN PGP SIGNATURE-----

iEYEARECAAYFAkmZ9sgACgkQuu7Rv+oOo/iFuQCeJSaxikghrQhjS68WKU0Hc//7
wZQAn2XMnmunfW2avO/uPFQDrw+s9INO
=AB0j
-----END PGP SIGNATURE-----
