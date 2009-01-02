Return-Path: <linux-kernel-owner+w=401wt.eu-S1757780AbZABOAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780AbZABOAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 09:00:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbZABOAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 09:00:33 -0500
Received: from ti-out-0910.google.com ([209.85.142.185]:27070 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbZABOAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 09:00:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=glh2NGqJX/8p80HaMfHznvwMqbYUGxto5xLHVxeDUM8BXHxY8oHg3M1s0z/pjaHdi4
         nWeYApBJhBa7RlR4uR7om8nH/fvwDYGQ0TMq8tB3TEUM1rF5uNAsreQsPewrWbZzIxDH
         fQg19KOlKxgV0n65wOaAVcOWmrHIO6CrLfkLY=
Date: Fri, 2 Jan 2009 22:00:23 +0800
From: Yan Li <elliot.li.tech@gmail.com>
To: Tino Keitel <tino.keitel@gmx.de>, Alan Stern <stern@rowland.harvard.edu>
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Enable CONFIG_USB_SUSPEND by default or some mobile HD can't
	be unplugged safely
Message-ID: <20090102140023.GC4833@thyme.bj.intel.com>
Mail-Followup-To: Tino Keitel <tino.keitel@gmx.de>,
	Alan Stern <stern@rowland.harvard.edu>, gregkh@suse.de,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090101160343.GA4278@thyme.bj.intel.com> <20090102095643.GB17103@x61>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090102095643.GB17103@x61>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 10:56:43AM +0100, Tino Keitel wrote:
> With a WD My Passport drive (2,5"), I need to use sg_start --stop --pc=3
> to stop the disk before unplugging it. Maybe this works with your
> drive, too.  This is also required by some Firewire hard disks.  Maybe
> the eject command should be extended to use this method, as it is used
> also by HAL to eject hotplug devices.

Hum...  I grepped my hal and hal-info packages but haven't found any
scripts using `sg_*'. I'm using hal package 0.5.11-6 from Debian
testing.

Now I know 3 methods supposed can be used to shut the device:
1. (Alan Stern said Windows use this) cut the USB port's power
2. send STOP SCSI command to stop it
3. put it into suspend mode

For the 1st method I have no much experience with Windows so I can't
verify. But now I doubt it. Since there are many early USB devices
that still show light on after you "safely remove" it from Windows. I
guess the power is still supplied but the device is send a command to
be shutdown or suspended.

For the 2nd and 3rd methods, I don't know which one is better, hope
some experts can give advice.

Whatever, I think the suspend mode is a standard USB design and the
kernel should support it by default so we should enable
CONFIG_USB_SUSPEND.

-- 
Li, Yan
