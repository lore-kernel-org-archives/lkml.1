Return-Path: <linux-kernel-owner+w=401wt.eu-S965576AbXBFWN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965576AbXBFWN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 17:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965578AbXBFWNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 17:13:24 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:39739 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965558AbXBFWNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 17:13:20 -0500
Date: Tue, 6 Feb 2007 23:13:24 +0100
From: Adrian Bunk <bunk@stusta.de>
To: gregkh@suse.de
Cc: linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: drivers/usb/serial/mos7720.c: inconsequent NULL checking
Message-ID: <20070206221324.GN27397@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker noted the following inconsequent NULL checking in 
drivers/usb/serial/mos7720.c:

<--  snip  -->

...
static void mos7720_close(struct usb_serial_port *port, struct file *filp)
{
...

        /* While closing port, shutdown all bulk read, write  *
         * and interrupt read if they exists                  */
        if (serial->dev) {
                dbg("Shutdown bulk write");
                usb_kill_urb(port->write_urb);
                dbg("Shutdown bulk read");
                usb_kill_urb(port->read_urb);
        }

        data = 0x00;
        send_mos_cmd(serial, MOS_WRITE, port->number - port->serial->minor,
                     0x04, &data);
...

<--  snip  -->

Note that "send_mos_cmd(serial,...)" dereferences "serial->dev".

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed



