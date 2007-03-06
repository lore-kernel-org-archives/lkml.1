Return-Path: <linux-kernel-owner+w=401wt.eu-S1030469AbXCFJkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030469AbXCFJkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 04:40:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030472AbXCFJkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 04:40:37 -0500
Received: from twin.jikos.cz ([213.151.79.26]:46859 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030469AbXCFJkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 04:40:36 -0500
Date: Tue, 6 Mar 2007 10:40:09 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Li Yu <liyu@ccoss.com.cn>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Vincent Legoll <vincentlegoll@gmail.com>,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       Harold Sargeant <harold-sargeant@ntlworld.com>,
       Greg Kroah Hartman <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, Li Yu <raise.sail@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-usb-devel] [DOC] The documentation for HID Simple Driver
 Interface 0.5.0
In-Reply-To: <45ECC5A4.20203@ccoss.com.cn>
Message-ID: <Pine.LNX.4.64.0703061036120.10909@twin.jikos.cz>
References: <200703051532096508636@gmail.com> <Pine.LNX.4.64.0703052304070.10909@twin.jikos.cz>
 <d120d5000703051427r577acc82x85a70ff963b991fa@mail.gmail.com>
 <45ECC5A4.20203@ccoss.com.cn>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2007, Li Yu wrote:

> > If we define HID "bus" allowing drivers to bind on VID:PID and provide 
> > default library module for parsing HID reports and providing access to 
> > HID transports (USB/BT) then writing tiny drivers adjusting just a 
> > part of hid_input_event and relying on default implemenattaion where 
> > it makes sense will become a breeze.
> But (You may guess I will say this word :), before the HID bus or other 
> better implementation come , I hope use the extended keys of my keyboard 
> on Linux, and I guess other people also think same with me, so we need 
> something here temporarily, even it do not merge into upstream code 
> tree.
> And, I want to know that is somebody works on HID bus, Can I join it?

I will probably start working on it one day. Anyway some parts of what 
Dmitry described are already in the mainline since 2.6.20 - the parser 
code (and hid_device registration and initialization in general) is 
already there. Access to transport layers (USB/BT) is partly also there 
(see hid_open(), hid_close() and hidinput_input_event() callbacks in 
struct hid_device). So really the only one pending thing which is 
non-trivial would be creating an interface for registering the device 
driver for given VID/PID on the HID bus, and solving the fallback 
mechanism, i.e. assuring that everything works for drivers which are OK 
with generic hid and hid-input behavior.

I will happily accept such patches from you, if you do them. Otherwise I 
will start to work on it in a future anyway.

Thanks,

-- 
Jiri Kosina
