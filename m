Return-Path: <linux-kernel-owner+w=401wt.eu-S965013AbXCFNrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965013AbXCFNrn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 08:47:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965021AbXCFNrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 08:47:43 -0500
Received: from twin.jikos.cz ([213.151.79.26]:59536 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965013AbXCFNrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 08:47:42 -0500
Date: Tue, 6 Mar 2007 14:47:11 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Marcel Holtmann <marcel@holtmann.org>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Li Yu <raise.sail@gmail.com>,
       Greg Kroah Hartman <greg@kroah.com>,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Vincent Legoll <vincentlegoll@gmail.com>,
       "Zephaniah E. Hull" <warp@aehallh.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Harold Sargeant <harold-sargeant@ntlworld.com>,
       liyu <liyu@ccoss.com.cn>
Subject: Re: [DOC] The documentation for HID Simple Driver Interface 0.5.0
In-Reply-To: <1173134421.6638.117.camel@aeonflux.holtmann.net>
Message-ID: <Pine.LNX.4.64.0703061444230.10909@twin.jikos.cz>
References: <200703051532096508636@gmail.com>  <1173127471.6638.96.camel@aeonflux.holtmann.net>
  <d120d5000703051211xb44adcckadd706560caa86e2@mail.gmail.com>
 <1173134421.6638.117.camel@aeonflux.holtmann.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Mar 2007, Marcel Holtmann wrote:

> no, because if I recall correctly these are the boot mode drivers and 
> actually not used at all in any modern distribution.

That's correct.

> For me the task of converting HID reports into input events shouldn't be 
> actually the job of the HID core layer. My understanding is that the HID 
> core should support multiple transport layers. This is currently 
> achieved through the hid_device abstraction and used by the USB and by 
> the Bluetooth subsystem. This is the lower interface to HID. On the 
> upper interface I like to see a driver like interface. So we can 
> register specific drivers that can handle specific use cases or vendor 
> specific reports. 

This I completely agree with, and have this on my TODO for quite a long 
time. If Li Yu would like to spend some time on it, it certainly would 
help. The current "simple HID interrface" is a suitable workaround for 
various buggy/broken/nonstandard hardware which is currently not handled 
by the HID kernel code properly, but it's definitely not a long-term 
solution that should go to mainline.

> For standard keyboard and mouse reports we however should have a 
> standard driver that can handle most of them.

Unfortunately there is a non-trivial bunch of hardware that pretends to be 
standard keyboard/mouse, but behaves badly. Last week I had to do 
workaround for Logitech S510, which seems to generate usages far above the 
logical maximum specified in report descriptor, to give one example.

So we will probably end up with many small driver for exotic pieces of 
hardware being registered to the hid bus. But this is definitely much 
better than the current mess of hid quirks.

On Mon, 5 Mar 2007, Dmitry Torokhov wrote:

> We are running out if quirks and we can't continue in this fashion so Li 
> tried to provide mechanism to augment default HID behaviour for sepcific 
> devices. 

That's right. We could always extend the quirks so that it's long long, or 
something like that, but this is also not sustainable in the long term.

-- 
Jiri Kosina
