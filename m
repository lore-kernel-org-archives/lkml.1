Return-Path: <linux-kernel-owner+w=401wt.eu-S1751182AbXA2LNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751182AbXA2LNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 06:13:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbXA2LNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 06:13:24 -0500
Received: from twin.jikos.cz ([213.151.79.26]:49588 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbXA2LNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 06:13:23 -0500
Date: Mon, 29 Jan 2007 12:13:17 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Soeren Sonnenburg <kernel@nn7.de>
cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>
Subject: Re: 2.6.20-rc6 pb_fnmode regression
In-Reply-To: <Pine.LNX.4.64.0701291138260.9448@twin.jikos.cz>
Message-ID: <Pine.LNX.4.64.0701291202230.9448@twin.jikos.cz>
References: <1169904555.2462.10.camel@localhost>  <Pine.LNX.4.64.0701291049190.9448@twin.jikos.cz>
 <1170066737.13904.12.camel@localhost> <Pine.LNX.4.64.0701291138260.9448@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007, Jiri Kosina wrote:

> Ah, now I see. The problem is that in pre-2.6.20-rc1 the pb_fnmode was 
> setting global variable, but after the HID layer rework, this is a 
> per-hid variable, which is of course not updated when write to sysfs 
> triggers. I will try to fix this before I send 2.6.20-rc6 updates to 
> Linus, thanks for pointing this out.

Actually the cleanest solution would be when I change the code in such a 
way that pb_fnmode parameter would be passed to hid instead of usbhid 
module, as this is where the input mapping is being done (you could 
potentially have a keyboard which needs the very same handling of fn mode 
as usb powerbook keyboards currently have, but on different transport
- input mapping is logically transport independent).

But I guess you will be not OK with breaking the backward compatibility in 
such way, because all the already existing tutorials, etc. right? 

Would warning that would trigger when the module parameter is passed to 
usbhid and would instruct user to pass the parameter to hid module 
instead, be acceptable? (and then changing the parameter of hid module 
through sysfs would work as expected again).

Thanks,

-- 
Jiri Kosina
