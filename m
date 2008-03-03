Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869AbYCCOjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbYCCOjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 09:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbYCCOjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 09:39:14 -0500
Received: from psa.adit.fi ([217.112.250.17]:56972 "EHLO psa.adit.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358AbYCCOjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 09:39:13 -0500
Message-ID: <47CC0D5E.6040405@adit.fi>
Date: Mon, 03 Mar 2008 16:38:22 +0200
From: Pekka Sarnila <sarnila@adit.fi>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.11) Gecko/20070217 Iceape/1.0.8 (Debian-1.0.8-4)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch] hid: quirk to fixup fullspeed interval on highspeed devices
References: <47C96DEB.5070304@adit.fi> <Pine.LNX.4.64.0803031333080.15209@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0803031333080.15209@jikos.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

thanks for the answer.

Jiri Kosina wrote:
> On Sat, 1 Mar 2008, Pekka Sarnila wrote:
> 
>> Many vendors highspeed devices give erroneously fullspeed interval value 
>> in endpoint descriptor for interrupt endpoints. This quirk fixes up that 
>> by recalculating the right value for highspeed device.
> 
> Hi Pekka,
> 
> thanks for the patch. I however think that HID code is really a wrong 
> place to to this, we really want to do this in USB core instead, as that 
> it where it belongs.

Yes, I kind of agree, but ...

> Why do you think that adding a new quirk for this device to 
> usb/core/quirks.c and then checking for it in usb_parse_endpoint() is not 
> feasible?

The quirks for usb/core (only two so far) are listed in
include/linux/usb/quirks.h. As it is states there:

/*
 * This file holds the definitions of quirks found in USB devices.
 * Only quirks that affect the whole device, not an interface,
 * belong here.
 */

There are two interfaces on this particular device. Only one interface is
HID, and the problem pertains only to that interface. Thus a class specific
quirk (HID) to eliminate the kernel tinkering with the endpoints of the
other interface (not having this problem).

This rises the question of the generality of this quirk. In this particular
case there are no interrupt endpoints on the other device. So based on this
one case it is impossible say anything on whether on devices having several
interrupt endpoints, maybe on several interfaces, the problem is device,
interface or endpoint specific. I suspect all combinations exist.
One might speculate that manufacturers are combining in to one usb.2 device
old usb.1 and new usb.2 components forgetting to update the interval value
in the firmware for the old component (I suspects this has happened in this
case: new being dvb, old ifr kbd).

If so it implies the need, not only for device or class specific, but also
interface and endpoint specific quirks. No such quirk-mechanism (to my
knowledge) exist.

Anyway, in the case of this particular device it was justified to limit
the quirk to HID-class. What to do in general is the question: My guess is
(without interface or endpoint specific quirks) class specific quirks hit
the target more precisely. But it is really only a guess.

Pekka

 
> Thanks,
> 
