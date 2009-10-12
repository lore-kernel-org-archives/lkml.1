Return-Path: <linux-kernel-owner+w=401wt.eu-S1755885AbZJLKSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbZJLKSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 06:18:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754685AbZJLKSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 06:18:06 -0400
Received: from mail.gmx.net ([213.165.64.20]:56709 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754592AbZJLKSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 06:18:04 -0400
X-Authenticated: #2813124
X-Provags-ID: V01U2FsdGVkX19JO54I+wBJk00uaxSMN436GWBuPlx5aaVy+MbzYf
	oM39xWcQMRF9AL
Message-ID: <4AD30229.6090607@gmx.ch>
Date: Mon, 12 Oct 2009 12:17:13 +0200
From: Daniel Ritz <daniel.ritz@gmx.ch>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Christian Loitsch <lkml@abc.delta64.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: eGalax TouchScreen
References: <200910082219.43160.lkml@abc.delta64.com>
In-Reply-To: <200910082219.43160.lkml@abc.delta64.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Christian

On 08.10.2009 22:19, Christian Loitsch wrote:
> Hello
> 
> (please CC me directly)
> 
> i don't need this touchscreen any longer, and would like to donate it to 
> anybody willing to work on improved support.
> 
> 10" (currently used with an MSI Wind)
> 0eef:0001 D-WAV Scientific Co., Ltd eGalax TouchScreen
> (you can find this touchscreen on ebay)
> 
> I once was able to make the touchscreen work, but it wasn't as easy as 
> pluging the touchscreen in.
> 
> First come first served, except for Daniel Ritz (the developer of the 
> touchscreen module), who has highest priority.

thanks a lot for this offer! but i will leave it to other interested
people since i have access to a eGalax screen (from xenarc).

> 
> Please just email me your address.  I will try to update: 
> <http://christian.delta64.com/touchscreen/stillAvailable.html>
> as fast as possible.
> 
> Please give me ~1week to prepare the package (and also give Daniel some 
> time to respond).
> 
> a+
> christian
> 
> here are some details i found out:
> 
> There are currently 3 ways an eGalax touchscreen 0eef:0001 can be 
> handled by the kernel.
> 
> 1) tkusb: a module (GPL) provided by the manufacturer, which is not in 
> the kernel and (AFAIK) requires a binary-only xorg module. [1]
> 
> 2) usbhid: which recognized my touchscreen, but I was not able to make 
> it work in xorg.
> 
> 3) the usbtouchscreen module.  This module only "accepts" the 
> touchscreen if usbhid did not (so I currently unload usbhid before 
> activating the touchscreen).
> This module however only works if the touchscreen is set to use a 
> different mode. (loading the tkusb module before the usbtouchscreen 
> module works, as tkusb sends this mode-change command to the touchscreen 
> [2])
> 
> The touchscreen works perfectly with usbtouchscreen and evdev.  I was 
> not able to make it work in any other way.
> 
> If I understood the usbtouchscreen code correctly you would just need to 
> add a device specific init for eGalax touchscreens and send the command 
> ([2]) to the device.  (AFAIK eeti does the same in their tkusb module 
> for every eGalax touchscreen).
> 
> [1]  <http://home.eeti.com.tw/web20/eGalaxTouchDriver/linuxDriver.htm>
> [2]  code from eeti-driver tkusb.c:
> ---
>                 #ifndef _REMOVE_CHANGE_FORMAT^M
>                         scr->output[0] = 0x0A;^M
>                         scr->output[1] = 1;^M
>                         scr->output[2] = 'A';^M
>                         if( !DoSendData( scr, 3 ) )^M
> ---
jup, that's the way to do it. i have some patches for usbtouchscreen
from various people in the mess that is my mailbox. i think one of
them adds exactly that init code. i'll try to get those in mergable
state soon...

thanks
-daniel



