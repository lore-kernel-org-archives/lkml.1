Return-Path: <linux-kernel-owner+w=401wt.eu-S1756525AbZGUXIC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525AbZGUXIC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 19:08:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756517AbZGUXIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 19:08:00 -0400
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:3624 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480AbZGUXH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 19:07:59 -0400
X-Greylist: delayed 2094 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Jul 2009 19:07:59 EDT
Message-ID: <4A664220.5070503@shikadi.net>
Date: Wed, 22 Jul 2009 08:33:04 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.8.1.21) Gecko/20090529 Thunderbird/2.0.0.21 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
CC: Linux USB <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Blacklisting a usbhid device
References: <d1351198778762a135751934d1977539.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <d1351198778762a135751934d1977539.squirrel@intranet.cs.nmsu.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Any suggestions on how to either work within the usbhid framework or how
> to get usbhid to stop claiming the device?

>From userland you can get the usbhid driver to release the device like this:

  cd /sys/bus/usb/drivers/usbhid
  echo '9-1:1.0' > unbind

Where '9-1:1.0' is the device you want to release.  Presumably you could do
the same thing on the kernel side when your driver is loaded.  This would give
better functionality, in that the usbhid driver would handle basic
functionality if your driver isn't loaded, but as soon as your driver was
loaded the extra functionality would become available.

Of course this bypasses usbhid's functionality.  I imagine it would be better
to write a hid driver and let usbhid handle the USB side of things.  Have a
look in drivers/hid/ for some hid driver examples that do this.

Cheers,
Adam.

