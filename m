Return-Path: <linux-kernel-owner+w=401wt.eu-S933290AbXCFNSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933290AbXCFNSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 08:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934113AbXCFNSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 08:18:52 -0500
Received: from coyote.holtmann.net ([217.160.111.169]:34453 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933290AbXCFNSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 08:18:51 -0500
Subject: Re: [DOC] The documentation for HID Simple Driver Interface 0.5.0
From: Marcel Holtmann <marcel@holtmann.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Li Yu <raise.sail@gmail.com>, Greg Kroah Hartman <greg@kroah.com>,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Vincent Legoll <vincentlegoll@gmail.com>,
       "Zephaniah E. Hull" <warp@aehallh.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Harold Sargeant <harold-sargeant@ntlworld.com>,
       liyu <liyu@ccoss.com.cn>
In-Reply-To: <d120d5000703051211xb44adcckadd706560caa86e2@mail.gmail.com>
References: <200703051532096508636@gmail.com>
	 <1173127471.6638.96.camel@aeonflux.holtmann.net>
	 <d120d5000703051211xb44adcckadd706560caa86e2@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 05 Mar 2007 23:40:21 +0100
Message-Id: <1173134421.6638.117.camel@aeonflux.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

> > This also means that the current keyboard and mouse
> > input devices will become a HID driver.
> 
> Are you talking about usbmouse and usbkbd?

no, because if I recall correctly these are the boot mode drivers and
actually not used at all in any modern distribution.

For me the task of converting HID reports into input events shouldn't be
actually the job of the HID core layer. My understanding is that the HID
core should support multiple transport layers. This is currently
achieved through the hid_device abstraction and used by the USB and by
the Bluetooth subsystem. This is the lower interface to HID. On the
upper interface I like to see a driver like interface. So we can
register specific drivers that can handle specific use cases or vendor
specific reports. For standard keyboard and mouse reports we however
should have a standard driver that can handle most of them.

For identification we actually do have the bus type, vendor id and
product id available. We also can register drivers for specific report
ids or usages.

I do like the HID simple driver idea, but it is not a simple driver, it
should be a generic driver interface.

Regards

Marcel


