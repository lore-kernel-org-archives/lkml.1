Return-Path: <linux-kernel-owner+w=401wt.eu-S1753214AbYKBGnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbYKBGnf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 01:43:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbYKBGn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 01:43:27 -0500
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:2658 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbYKBGn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 01:43:26 -0500
Message-ID: <490D4C0B.603@shikadi.net>
Date: Sun, 02 Nov 2008 16:43:23 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.8.1.16) Gecko/20080727 Thunderbird/2.0.0.16 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: Driver for new hid class (was: Can you use the USB HID interface
 within a driver?)
References: <490C4133.30400@shikadi.net> <alpine.LRH.1.10.0811012122250.19257@twin.jikos.cz> <490CE432.5040005@shikadi.net>
In-Reply-To: <490CE432.5040005@shikadi.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> For 2.6.28, the HID code has been completely refactored, and converted 
>> into a proper bus, making it possible to write driver easily in a way 
>> that the driver implements only parts where device deviates from the 
>> HID standard, and lets the rest to be handled by generic code. I guess 
>> this is what you are looking for?
> 
> Yes, that sounds like exactly what I'm after!  This device seems to be 
> HID with a custom protocol over the top, so presumably I can let the HID 
> driver handle all the USB initialisation and just focus on the protocol.

Okay, I've upgraded to 2.6.28-rc2 and started writing a driver for the 
new hid class.  It didn't take long for me to get stuck though :-(

When I load my module, it calls hid_register_driver() which returns 
0/success.  However that's as far as it gets.  I've defined a probe 
function to attach to the device, but this never gets called.

Is there something else I need to do?  The USB IDs are right, and I 
tried replugging the device with my "driver" loaded but it seems to be 
ignored.  It seems the device appears as a full HID input 
implementation, so it gets an evdev device associated with it.

Does this mean I need to blacklist it to stop the HID input driver from 
claiming it?  Or should my driver be able to claim it in preference to 
the input driver as mine is for a specific device, as opposed to the 
whole class?

Thanks,
Adam.
