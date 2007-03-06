Return-Path: <linux-kernel-owner+w=401wt.eu-S965413AbXCFR56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965413AbXCFR56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 12:57:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965441AbXCFR56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 12:57:58 -0500
Received: from coyote.holtmann.net ([217.160.111.169]:34890 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965413AbXCFR54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 12:57:56 -0500
Subject: Re: [DOC] The documentation for HID Simple Driver Interface 0.5.0
From: Marcel Holtmann <marcel@holtmann.org>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Li Yu <raise.sail@gmail.com>,
       Greg Kroah Hartman <greg@kroah.com>,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Vincent Legoll <vincentlegoll@gmail.com>,
       "Zephaniah E. Hull" <warp@aehallh.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Harold Sargeant <harold-sargeant@ntlworld.com>,
       liyu <liyu@ccoss.com.cn>
In-Reply-To: <Pine.LNX.4.64.0703061444230.10909@twin.jikos.cz>
References: <200703051532096508636@gmail.com>
	 <1173127471.6638.96.camel@aeonflux.holtmann.net>
	 <d120d5000703051211xb44adcckadd706560caa86e2@mail.gmail.com>
	 <1173134421.6638.117.camel@aeonflux.holtmann.net>
	 <Pine.LNX.4.64.0703061444230.10909@twin.jikos.cz>
Content-Type: text/plain
Date: Tue, 06 Mar 2007 19:57:20 +0100
Message-Id: <1173207440.11247.24.camel@aeonflux.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

> > For me the task of converting HID reports into input events shouldn't be 
> > actually the job of the HID core layer. My understanding is that the HID 
> > core should support multiple transport layers. This is currently 
> > achieved through the hid_device abstraction and used by the USB and by 
> > the Bluetooth subsystem. This is the lower interface to HID. On the 
> > upper interface I like to see a driver like interface. So we can 
> > register specific drivers that can handle specific use cases or vendor 
> > specific reports. 
> 
> This I completely agree with, and have this on my TODO for quite a long 
> time. If Li Yu would like to spend some time on it, it certainly would 
> help. The current "simple HID interrface" is a suitable workaround for 
> various buggy/broken/nonstandard hardware which is currently not handled 
> by the HID kernel code properly, but it's definitely not a long-term 
> solution that should go to mainline.

my point is basically that we shouldn't waste any effort on a simple
driver while we actually need a generic driver interface. This generic
interface might be look simple and stupid in the beginning, but it can
easily grow over time. With this interface of course we need the concept
of a HID bus.

> > For standard keyboard and mouse reports we however should have a 
> > standard driver that can handle most of them.
> 
> Unfortunately there is a non-trivial bunch of hardware that pretends to be 
> standard keyboard/mouse, but behaves badly. Last week I had to do 
> workaround for Logitech S510, which seems to generate usages far above the 
> logical maximum specified in report descriptor, to give one example.
> 
> So we will probably end up with many small driver for exotic pieces of 
> hardware being registered to the hid bus. But this is definitely much 
> better than the current mess of hid quirks.

Maybe the report descriptor is broken. I have some Bluetooth HID where
they actually byte-swapped values and it totally confused the report
descriptor parser. For some devices it might be better to actually patch
the report descriptor instead of adding quirks to the HID core.

Regards

Marcel


