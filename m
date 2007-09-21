Return-Path: <linux-kernel-owner+w=401wt.eu-S1759002AbXIUNn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759002AbXIUNn6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 09:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757313AbXIUNnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 09:43:50 -0400
Received: from frosty.hhs.nl ([145.52.2.15]:58325 "EHLO frosty.hhs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757181AbXIUNnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 09:43:50 -0400
Message-ID: <46F3C704.5000203@hhs.nl>
Date: Fri, 21 Sep 2007 15:28:36 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070911)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: USB autosuspend and turning of usb pendrive leds
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.2/RELEASE, bases: 21092007 #395929, status: clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Please keep me CC-ed as I'm not subscribed.

Some time ago a mail about turning of the leds on usb pendrives once unmounted 
by hal was send to the fedora-devel list:
https://www.redhat.com/archives/fedora-devel-list/2007-August/msg01807.html

This mail talked about echo 2 > power/state for usb devices.

I tested the method described in the mail to turn of the drive light and it 
worked well.

As I think that turning of the drive led (as windows does) would be good visual 
feedback to the end user that its safe to remove the device I've written a 
patch for hal which does the power state change automatically when the last 
partition of a usb massstorage device gets unmounted.

However when testing the patch I found out that my now newer kernel no longer 
has power/state for usb devices, it only has power/level. I can send suspend to 
power/level, but then remounting the device won't work and me syslog fills 
itself with:
sd 2:0:0:0: [sdc] READ CAPACITY failed
sd 2:0:0:0: [sdc] Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK,SUGGEST_OK
sd 2:0:0:0: [sdc] Sense not available.
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 00 00 00
sd 2:0:0:0: [sdc] Assuming drive cache: write through

Because hal keeps polling the device.

So this leads me to a couple of questions:
1) Would it be possible to funtionality to the kernel to suspend a device in
    such a way that it will automatically unsuspend when used again?
2) Would it be possible to still make the polls succeed then with out
    unsuspending the device (or atleast without doing something that would make
    the led light again, what makes the led light exactly is unknown), or should
    hal stop polling then?

Note I'm aware that some usb devices may not like being suspended, but thats a 
problem for later, if this cannot be made to work with devices which do handle 
suspend properly, then thinking about white and/or blacklisting it irrelevant.

Regards,

Hans

