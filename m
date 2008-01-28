Return-Path: <linux-kernel-owner+w=401wt.eu-S1753593AbYA1IRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbYA1IRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 03:17:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750780AbYA1IRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 03:17:22 -0500
Received: from aun.it.uu.se ([130.238.12.36]:34056 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbYA1IRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 03:17:21 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18333.36746.819935.641383@harpo.it.uu.se>
Date: Mon, 28 Jan 2008 09:17:14 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Problem with ata layer in 2.6.24
In-Reply-To: <200801272122.21823.gene.heskett@gmail.com>
References: <200801272122.21823.gene.heskett@gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett writes:
 > Greeting;
 > 
 > I had to reboot early this morning due to a freezeup, and I had a 
 > bunch of these in the messages log:
 > ==============
 > Jan 27 19:42:11 coyote kernel: [42461.915961] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
 > Jan 27 19:42:11 coyote kernel: [42461.915973] ata1.00: cmd ca/00:08:b1:66:46/00:00:00:00:00/e8 tag 0 dma 4096 out
 > Jan 27 19:42:11 coyote kernel: [42461.915974]          res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
 > Jan 27 19:42:11 coyote kernel: [42461.915978] ata1.00: status: { DRDY }
 > Jan 27 19:42:11 coyote kernel: [42461.916005] ata1: soft resetting link
 > Jan 27 19:42:12 coyote kernel: [42462.078216] ata1.00: configured for UDMA/100
 > Jan 27 19:42:12 coyote kernel: [42462.078232] ata1: EH complete
 > Jan 27 19:42:12 coyote kernel: [42462.090700] sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
 > Jan 27 19:42:12 coyote kernel: [42462.114230] sd 0:0:0:0: [sda] Write Protect is off
 > Jan 27 19:42:12 coyote kernel: [42462.115079] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
 > support DPO or FUA
 > ===============
 > That one showed up about 2 hours ago, so I expect I'll be locked 
 > up again before I've managed a 24 hour uptime.  This drive passed
 > a 'smartctl -t long /dev/sda' with flying colors after the reboot
 > this morning.
 > 
 > Two instances were logged after I had rebooted to 2.6.24 from 2.6.24-rc8:
 > 
 > Jan 24 20:46:33 coyote kernel: [    0.000000] Linux version 2.6.24 (root@coyote.coyote.den) (gcc version 4.1.2 20070925 
 > (Red Hat 4.1.2-33)) #1 SMP Thu Jan 24 20:17:55 EST 2008
 > ----
 > Jan 27 02:28:29 coyote kernel: [193207.445158] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
 > Jan 27 02:28:29 coyote kernel: [193207.445170] ata1.00: cmd 35/00:08:f9:24:0a/00:00:17:00:00/e0 tag 0 dma 4096 out
 > Jan 27 02:28:29 coyote kernel: [193207.445172]          res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
 > Jan 27 02:28:29 coyote kernel: [193207.445175] ata1.00: status: { DRDY }
 > Jan 27 02:28:29 coyote kernel: [193207.445202] ata1: soft resetting link
 > Jan 27 02:28:29 coyote kernel: [193207.607384] ata1.00: configured for UDMA/100
 > Jan 27 02:28:29 coyote kernel: [193207.607399] ata1: EH complete
 > Jan 27 02:28:29 coyote kernel: [193207.609681] sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
 > Jan 27 02:28:29 coyote kernel: [193207.619277] sd 0:0:0:0: [sda] Write Protect is off
 > Jan 27 02:28:29 coyote kernel: [193207.649041] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
 > support DPO or FUA
 > Jan 27 02:30:06 coyote kernel: [193304.336929] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
 > Jan 27 02:30:06 coyote kernel: [193304.336940] ata1.00: cmd ca/00:20:69:22:a6/00:00:00:00:00/e7 tag 0 dma 16384 out
 > Jan 27 02:30:06 coyote kernel: [193304.336942]          res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
 > Jan 27 02:30:06 coyote kernel: [193304.336945] ata1.00: status: { DRDY }
 > Jan 27 02:30:06 coyote kernel: [193304.336972] ata1: soft resetting link
 > Jan 27 02:30:06 coyote kernel: [193304.499210] ata1.00: configured for UDMA/100
 > Jan 27 02:30:06 coyote kernel: [193304.499226] ata1: EH complete
 > Jan 27 02:30:06 coyote kernel: [193304.499714] sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
 > Jan 27 02:30:06 coyote kernel: [193304.499857] sd 0:0:0:0: [sda] Write Protect is off
 > Jan 27 02:30:06 coyote kernel: [193304.502315] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
 > support DPO or FUA
 > 
 > None were logged during the time I was running an -rc7 or -rc8.
 > 
 > The previous hits on this resulted in the udma speed being downgraded 
 > till it was actually running in pio just before the freeze that 
 > required the hardware reset button.
 > 
 > I'll reboot to -rc8 right now and resume.  If its the drive, I should see it.
 > If not, then 2.6.24 is where I'll point the finger.
 > 
 > Idea's anyone?

1. Wrong mailing list; use linux-ide (@vger) instead.
2. Incomplete dmesg, in particular, we can't see what your hardware is.
   Just post the complete dmesg.
