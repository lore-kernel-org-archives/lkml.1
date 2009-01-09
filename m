Return-Path: <linux-kernel-owner+w=401wt.eu-S1760121AbZAIWkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760121AbZAIWkc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 17:40:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757525AbZAIWkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 17:40:18 -0500
Received: from mail.impinj.com ([206.169.229.170]:32234 "EHLO earth.impinj.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757403AbZAIWkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 17:40:17 -0500
From: Vadim Lobanov <vlobanov@speakeasy.net>
To: Thomas Dahlmann <dahlmann.thomas@arcor.de>
Subject: Re: amd5536udc interrupts bug
Date: Fri, 9 Jan 2009 14:40:15 -0800
User-Agent: KMail/1.10.3 (Linux/2.6.27.9-159.fc10.x86_64; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <49661E83.2070703@arcor.de> <200901081802.43625.vlobanov@speakeasy.net> <496737E1.1090607@arcor.de>
In-Reply-To: <496737E1.1090607@arcor.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901091440.15888.vlobanov@speakeasy.net>
X-OriginalArrivalTime: 09 Jan 2009 22:40:16.0199 (UTC) FILETIME=[3E00E570:01C972AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 January 2009 03:41:21 Thomas Dahlmann wrote:
> Vadim Lobanov schrieb:
> > Alas, the hardware doesn't work. When I try plugging in the other end of
> > the USB cable, absolutely nothing happens. Not even an interrupt:
> > /proc/interrupts for the amd5536udc line stays at zero. Any thoughts on
> > possible ways to tackle this / what could be going wrong / etc?

Just realized that I forgot to mention that I do also have g_zero sitting on 
top of amd5536udc, so there should at least be a dummy USB device to 
enumerate.

> Is there any output in the kernel messages on the host side complaining
> about that device is
> not answering? If not than USB device port is probably not connected to
> UDC PHY. Please
> check in BIOS setup that port 4 is assigned to UDC.

Nope, nothing at all shows up in the logs or the interrupt counts when the 
cable is plugged, neither for the host drivers nor the device drivers. (The 
quickest test I have is to hook the device up to itself - one A port and one B 
port.)

The BIOS is configured "correctly" if the manuals are to be trusted. Here are 
the relevant settings
	OHCI: Enabled
	EHCI: Enabled
	UDC: Enabled
	UOC: Disabled
	Overcurrent reporting: Disabled
	Port 4 assignment: Device

> This will set bits PAD_EN and APU in UOC controller (DEVID 0x2097):
> 
http://www.amd.com/files/connectivitysolutions/geode/geode_lx/33238G_cs5536
>_db.pdf

Please pardon my ignorance, but what would be the best way to check if 
these bits are set?

Thanks.

