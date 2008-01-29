Return-Path: <linux-kernel-owner+w=401wt.eu-S932749AbYA2Uhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749AbYA2Uhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 15:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755784AbYA2UhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 15:37:23 -0500
Received: from mail.gmx.net ([213.165.64.20]:54788 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751556AbYA2UhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 15:37:22 -0500
X-Authenticated: #2283611
X-Provags-ID: V01U2FsdGVkX1/5G6Q1X+j5C4LrwBNnv4OuFIn8S0Rk2DhZGkRLq3
	1k47mtmnV+AXZ5
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH] radio-si470x.c: check-after-use
Date: Tue, 29 Jan 2008 21:37:17 +0100
User-Agent: KMail/1.9.7
References: <20080128221300.GH8767@does.not.exist> <200801282343.13589.tobias.lorenz@gmx.net> <200801292037.36647.oliver@neukum.org>
In-Reply-To: <200801292037.36647.oliver@neukum.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Adrian Bunk <bunk@kernel.org>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801292137.18035.tobias.lorenz@gmx.net>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > > Either "radio" can be NULL and this case has to be properly handled or 
> > > the NULL check is not required.
> > 
> > These two lines should indeed better be inside the if statement. The patch for this is below.
> 
> No, in disconnect intfdata must be valid. Any check for NULL is wrong
> there.

Why hadn't anybody told me that earlier? :-)
I removed the complete check for radio==NULL.
See the patch below.

Thanks,
  Toby


Signed-off-by: Tobias Lorenz <tobias.lorenz@gmx.net>
--- linux-2.6.23/drivers/media/radio/radio-si470x.c     2008-01-23 00:01:07.000000000 +0100
+++ linux-2.6.23.new/drivers/media/radio/radio-si470x.c 2008-01-27 15:31:42.000000000 +0100
@@ -1441,13 +1441,11 @@ static void si470x_usb_driver_disconnect
        struct si470x_device *radio = usb_get_intfdata(intf);

        usb_set_intfdata(intf, NULL);
-       if (radio) {
-               del_timer_sync(&radio->timer);
-               flush_scheduled_work();
-               video_unregister_device(radio->videodev);
-               kfree(radio->buffer);
-               kfree(radio);
-       }
+       del_timer_sync(&radio->timer);
+       flush_scheduled_work();
+       video_unregister_device(radio->videodev);
+       kfree(radio->buffer);
+       kfree(radio);
 }
