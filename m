Return-Path: <linux-kernel-owner+w=401wt.eu-S932102AbXCEWNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbXCEWNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:13:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932103AbXCEWNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:13:14 -0500
Received: from twin.jikos.cz ([213.151.79.26]:41951 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932102AbXCEWNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:13:11 -0500
Date: Mon, 5 Mar 2007 23:12:53 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Li Yu <raise.sail@gmail.com>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Greg Kroah Hartman <greg@kroah.com>,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Vincent Legoll <vincentlegoll@gmail.com>,
       "Zephaniah E. Hull" <warp@aehallh.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Harold Sargeant <harold-sargeant@ntlworld.com>
Subject: Re: [linux-usb-devel] [DOC] The documentation for HID Simple Driver
 Interface 0.5.0
In-Reply-To: <200703051532096508636@gmail.com>
Message-ID: <Pine.LNX.4.64.0703052304070.10909@twin.jikos.cz>
References: <200703051532096508636@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Mar 2007, Li Yu wrote:

>  Under standard HID device driver development means, we need to write 
> one interrupt handler for each new HID device to report event to input 
> subsystem. However, although the most of they can not merge into 
> mainstream kernel tree, they have only some extended keys, e.g. many 
> remote controllers. I think it seem break a fly on the wheel, which 
> write one new interrupt handler for this reason.

This paragraph I don't seem to understand. Either the device is claimed by 
hid-input (*), and then when the device is behaving more-or-less 
correctly, hid-input handles the usages sent in reports and maps them 
properly to input events. New mapping can be quite trivially added to 
hid-input.

If the HID device is not claimed by hid-input, then userspace can access 
the hid events through hiddev and perform any actions that are needed.

Could you please elaborate a little bit more why your approach using 
"simple HID interface" is better than for example hiddev+uinput, done 
completely in userspace?

In addition to that, as I stated in some previous e-mail, I am currently 
working on new 'hidraw' interface, which will provide more flexibility to 
userland applications willing to operate on raw HID data, than they 
currently have with hiddev.

(*) OK, I would tend to agree that the algorithm which decides whether the 
given device will be claimed by hid-input driver could be improved to be 
more HID-specification and HUT compliant. I have this in my TODO, but I 
guess it doesn't matter too much here.

Thanks,

-- 
Jiri Kosina
