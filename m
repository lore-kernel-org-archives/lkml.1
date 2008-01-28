Return-Path: <linux-kernel-owner+w=401wt.eu-S1759696AbYA1Sy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759696AbYA1Sy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 13:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbYA1Syt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 13:54:49 -0500
Received: from rtr.ca ([76.10.145.34]:1028 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbYA1Sys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 13:54:48 -0500
Message-ID: <479E24F7.4090502@rtr.ca>
Date: Mon, 28 Jan 2008 13:54:47 -0500
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Problem with ata layer in 2.6.24
References: <200801272122.21823.gene.heskett@gmail.com>
In-Reply-To: <200801272122.21823.gene.heskett@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
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
..

The only libata change I can see that could possibly affect your setup,
is this one here, which went in sometime between -rc7 and -final:

--- linux-2.6.24-rc7/drivers/ata/libata-eh.c    2008-01-06 16:45:38.000000000 -0500
+++ linux-2.6.24/drivers/ata/libata-eh.c        2008-01-24 17:58:37.000000000 -0500
@@ -1733,11 +1733,15 @@
                ehc->i.action &= ~ATA_EH_PERDEV_MASK;
        }

-       /* consider speeding down */
+       /* propagate timeout to host link */
+       if ((all_err_mask & AC_ERR_TIMEOUT) && !ata_is_host_link(link))
+               ap->link.eh_context.i.err_mask |= AC_ERR_TIMEOUT;
+

It looks pretty innocent to me, though.
If you want to try reverting just that change
(comment out the two lines and rebuild),
then that might provide useful information here.

If -final is still b0rked even with those two lines changed back,
then I suspect you're just "getting lucky" when switching between
the -rc7/-rc8 kernel and the -final kernel.

"Lucky" in a bad way, that is.

The real test would be to rebuild the kernel without libata,
and *with* the old IDE driver instead, and see if the problems persist.

If you need help with that, then perhaps someone familiar with Fedora
might be able to assist.

Cheers 
