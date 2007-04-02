Return-Path: <linux-kernel-owner+w=401wt.eu-S1753030AbXDBEQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbXDBEQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 00:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbXDBEQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 00:16:23 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:9686 "EHLO
	asav00.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbXDBEQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 00:16:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAF4gEEZKhRO4UGdsb2JhbACHO4hCAQEq
From: Dmitry Torokhov <dtor@insightbb.com>
To: Li Yu <raise.sail@gmail.com>
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
Date: Mon, 2 Apr 2007 00:15:43 -0400
User-Agent: KMail/1.9.3
Cc: Jiri Kosina <jkosina@suse.cz>, yanghong@ccoss.com.cn,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       hongzhiyi@ccoss.com.cn, Marcel Holtmann <marcel@holtmann.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200703051532096508636@gmail.com> <Pine.LNX.4.64.0704010002280.6040@jikos.suse.cz> <4610609C.9030101@gmail.com>
In-Reply-To: <4610609C.9030101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704020015.44167.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 April 2007 21:47, Li Yu wrote:
> Let me explain the internal of my current HID bus implementation. I
> think that selecting one user scene as example is good idea.
> 
> Well, the user A plug a USB joystick into computer. The work processing
> of HID subsystem for this joystick is same with our mind: The USB/base
> driver works for it. However, the world is not faultless. This joystick
> is buggy, its some keys need specific handling, our good friend udev
> discover that there is also have another driver can handle it, so it
> insert that kernel module, then our sweet leading role specific/shadow
> HID driver appear on scene. Registering shadow driver let HID core clone
> a hid_device first, and start new usage configuration processing for new
> cloned hid_device (if we like, even I think we can reread reports from
> physical device), the shadow driver can join with HID core to
> custom/hook in this recofiguration processing. If this shadow driver is
> input-able, the HID core will unregister working input device come from
> USB/base hid_device, and register new input device for this shadow
> hid_device. So we have not two input_dev for one HID device at same time.
>

No, please don't do that. As soon as there is a special driver written
for a device that device's VID/PID should be added to generic HID
blacklist. This way udev will load the proper driver right away and
there will not be any flip-flopping of input devices. 
 
> When user A remove this shadow driver, the USB/base driver should resume
> work for this joystick, IOW, it should register back its input device again.
> 

Why would we want to revert to using generic HID's implementation if we
know that it is broken for that particular device???

-- 
Dmitry
