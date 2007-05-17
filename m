Return-Path: <linux-kernel-owner+w=401wt.eu-S1757562AbXEQO2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562AbXEQO2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 10:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbXEQO2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 10:28:39 -0400
Received: from twin.jikos.cz ([213.151.79.26]:48078 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754572AbXEQO2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 10:28:38 -0400
Date: Thu, 17 May 2007 16:28:35 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Tomas Carnecky <tom@dbservice.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: SideWinder GameVoice driver
In-Reply-To: <464C5FAC.8060609@dbservice.com>
Message-ID: <Pine.LNX.4.64.0705171623280.27422@twin.jikos.cz>
References: <464C5FAC.8060609@dbservice.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007, Tomas Carnecky wrote:

> Despite it's a Microsoft product, it's actually very nice and useful. A 
> little pad with a few buttons and connectors for a headset. It's an USB 
> device, but it doesn't represent itself as an input/HID device:
>    HID device not claimed by input or hiddev
> What would be the best way to have this device appear in the system? 
> Having a separate driver/device node? Or is it possible to have a small 
> driver that would translate the gamevoice commands into evdev messages 
> and have a new /dev/input/eventX device appear?
> I could write something like that myself, my C skills are good enough 
> for that, I'd just need some advice how to use the kernel USB/evdev 
> interfaces.

Hi Tomas,

the reason for hid-input not claiming the device is very probably that the 
report descriptor of the device doesn't comply with what the in-kernel 
HID-input driver is accepting.

Could you please 

- compile the kernel with CONFIG_HID_DEBUG and send me the output you 
  receive when you connect the device
- if you'd like to work on it yourself, try to analyze the hid report 
  descriptor (it will be in the kernel log after you plug the device into 
  CONFIG_HID_DEBUG compiled kernel) and see what types of collection types 
  and usages does it contain. Please look at the code in 
  drivers/hid/hid-input.c:hidinput_connect() to understand which HID 
  devices are being claimed by the hid-input subsystem (the very first 
  loop over all the collections is the most important one)

-- 
Jiri Kosina
