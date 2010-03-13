Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759332Ab0CMVgI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 16:36:08 -0500
Received: from netrider.rowland.org ([192.131.102.5]:38693 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759309Ab0CMVgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 16:36:00 -0500
Date: Sat, 13 Mar 2010 16:35:59 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
cc: Jiri Kosina <jkosina@suse.cz>, <linux-input@vger.kernel.org>,
       <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>
Subject: Re: [PATCH 1/3] picolcd: driver for PicoLCD HID device
In-Reply-To: <20100313203953.0f3436b3@neptune.home>
Message-ID: <Pine.LNX.4.44L0.1003131635170.19476-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Mar 2010, Bruno [UTF-8] Prémont wrote:

> Is something like below acceptable? (from error handling point of view
> it makes no difference...)
> 
> Thanks,
> Bruno
> 
> file: drivers/hid/hid-core.c
> 
>  int hid_add_device(struct hid_device *hdev)
>  {
>          static atomic_t id = ATOMIC_INIT(0);
>          int ret;
>  
>          if (WARN_ON(hdev->status & HID_STAT_ADDED))
>                  return -EBUSY;
>  
>          /* we need to kill them here, otherwise they will stay allocated to
>           * wait for coming driver */
>          if (hid_ignore(hdev))
>                  return -ENODEV;
>  
>          /* XXX hack, any other cleaner solution after the driver core
>           * is converted to allow more than 20 bytes as the device name? */
>          dev_set_name(&hdev->dev, "%04X:%04X:%04X.%04X", hdev->bus,
>                       hdev->vendor, hdev->product, atomic_inc_return(&id));
>  
> +        hid_debug_register(hdev, dev_name(&hdev->dev));
>          ret = device_add(&hdev->dev);
>          if (!ret)
>                  hdev->status |= HID_STAT_ADDED;
>  
> -        hid_debug_register(hdev, dev_name(&hdev->dev));
>  
>          return ret;
>  }

If the device_add() fails, you should undo the hid_debug_register() 
call.

Alan Stern

