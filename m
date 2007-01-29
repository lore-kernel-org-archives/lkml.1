Return-Path: <linux-kernel-owner+w=401wt.eu-S1751167AbXA2LYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167AbXA2LYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 06:24:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbXA2LYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 06:24:43 -0500
Received: from mail.first.fraunhofer.de ([194.95.169.2]:63043 "EHLO
	mail.first.fraunhofer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbXA2LYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 06:24:42 -0500
Subject: Re: 2.6.20-rc6 pb_fnmode regression
From: Soeren Sonnenburg <kernel@nn7.de>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.64.0701291202230.9448@twin.jikos.cz>
References: <1169904555.2462.10.camel@localhost>
	 <Pine.LNX.4.64.0701291049190.9448@twin.jikos.cz>
	 <1170066737.13904.12.camel@localhost>
	 <Pine.LNX.4.64.0701291138260.9448@twin.jikos.cz>
	 <Pine.LNX.4.64.0701291202230.9448@twin.jikos.cz>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 29 Jan 2007 12:24:34 +0100
Message-Id: <1170069874.13904.29.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-01-29 at 12:13 +0100, Jiri Kosina wrote:
> On Mon, 29 Jan 2007, Jiri Kosina wrote:
> 
> > Ah, now I see. The problem is that in pre-2.6.20-rc1 the pb_fnmode was 
> > setting global variable, but after the HID layer rework, this is a 
> > per-hid variable, which is of course not updated when write to sysfs 
> > triggers. I will try to fix this before I send 2.6.20-rc6 updates to 
> > Linus, thanks for pointing this out.
> 
> Actually the cleanest solution would be when I change the code in such a 
> way that pb_fnmode parameter would be passed to hid instead of usbhid 
> module, as this is where the input mapping is being done (you could 
> potentially have a keyboard which needs the very same handling of fn mode 
> as usb powerbook keyboards currently have, but on different transport
> - input mapping is logically transport independent).
> 
> But I guess you will be not OK with breaking the backward compatibility in 
> such way, because all the already existing tutorials, etc. right? 

That sounds good for me. Breaking with what was there is not a problem
as long as this feature is still there, it can be done in a more clean
way this way, and the new  /sys/foo/bar path is documented (basically
people nowadays expect slight user interface changes between kernel
versions).

> Would warning that would trigger when the module parameter is passed to 
> usbhid and would instruct user to pass the parameter to hid module 
> instead, be acceptable? (and then changing the parameter of hid module 
> through sysfs would work as expected again).

I guess this warning is not too useful, except if it is triggered on
echo  >/sys/*/pb_fnmode too (which I suspect is what most people do).

Soeren
-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
