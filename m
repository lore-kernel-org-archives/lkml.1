Return-Path: <linux-kernel-owner+w=401wt.eu-S1763827AbYA1WT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763827AbYA1WT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:19:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762718AbYA1WMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:12:35 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:46556 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758370AbYA1WMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:12:33 -0500
Date: Tue, 29 Jan 2008 00:13:00 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Tobias Lorenz <tobias.lorenz@gmx.net>, mchehab@infradead.org
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: media/radio/radio-si470x.c: check-after-use
Message-ID: <20080128221300.GH8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted the following check-after-use in 
drivers/media/radio/radio-si470x.c:

<--  snip  -->

...
static void si470x_usb_driver_disconnect(struct usb_interface *intf)
{
        struct si470x_device *radio = usb_get_intfdata(intf);

        del_timer_sync(&radio->timer);    <------------------
        flush_scheduled_work();

        usb_set_intfdata(intf, NULL);
        if (radio) {                      <------------------
                video_unregister_device(radio->videodev);
                kfree(radio->buffer);
                kfree(radio);
        }
}
...

<--  snip  -->

Either "radio" can be NULL and this case has to be properly handled or 
the NULL check is not required.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

