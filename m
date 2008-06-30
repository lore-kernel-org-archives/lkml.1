Return-Path: <linux-kernel-owner+w=401wt.eu-S1760752AbYF3LGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760752AbYF3LGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 07:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbYF3LF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 07:05:58 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:45082 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbYF3LF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 07:05:57 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: "Alfred E. Heggestad" <aeh@db.org>
Subject: Re: [PATCH] input: driver for USB VoIP phones with CM109 chipset #2
Date: Mon, 30 Jun 2008 13:06:27 +0200
User-Agent: KMail/1.9.9
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200806271424.50425.oliver@neukum.org> <486652D1.4010008@db.org>
In-Reply-To: <486652D1.4010008@db.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806301306.27933.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag 28 Juni 2008 17:03:45 schrieb Alfred E. Heggestad:
 
Hello,

> many many thanks for your patch and your suggested code improvements.
> I have tested your patch and I have some comments:
> 
> * The first version of your patch was tested, and it applied cleanly
>    and compiled with out any errors. The module was loaded OK, but when
>    I inserted the CM109-device into the USB-port, the machine crashed.
>    I fixed that issue by adding this to the usb_probe() function:
> 
> 	init_waitqueue_head(&dev->wait);

Sorry about that.

> * The second version of your patch was applied with some local mods.
>    This is now working as expected.

Good.

> * I have tested suspend/resume with 2.6.25.9 and TuxOnIce 3.0-rc7
>    and it works fine (cm109 device was plugged in during suspend).
>    During suspend I get this in syslog:
> 
>      drivers/input/misc/cm109.c: cm109: usb_suspend (event=1)
>      drivers/input/misc/cm109.c: urb_irq_callback: urb status -2

That is normal. It indicates that usb_kill_urb() had terminated the URB.
Which logging level did you use?

> * The flag "char disconnecting:1" is no longer used in your second
>    patch, and has been removed from the struct.

Sorry again.

> * When the buzzer is triggered by SND_TONE/SND_BELL, I get these
>    warnings in syslog:
> 
>      drivers/input/misc/cm109.c: urb_ctl_callback: usb_submit_urb failed -22
>      drivers/input/misc/cm109.c: buzz: usb_submit_urb failed -22
>      drivers/input/misc/cm109.c: urb_ctl_callback: usb_submit_urb failed -22
>      drivers/input/misc/cm109.c: buzz: usb_submit_urb failed -22
> 
>    It seems that the ctl URB is shared between buzzer and keypress
>    handling. I am thinking about adding a new URB just for the buzzer,
>    but I am not sure if that really is necesary. Any suggestions?

Under which conditions did you get this? Was the device opened or not?

	Regards
		Oliver
