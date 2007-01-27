Return-Path: <linux-kernel-owner+w=401wt.eu-S932248AbXA2J1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248AbXA2J1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 04:27:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932261AbXA2J1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 04:27:54 -0500
Received: from mail.first.fraunhofer.de ([194.95.169.2]:59181 "EHLO
	mail.first.fraunhofer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932248AbXA2J1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 04:27:53 -0500
Subject: 2.6.20-rc6 pb_fnmode regression
From: Soeren Sonnenburg <kernel@nn7.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-usb-devel <linux-usb-devel@lists.sourceforge.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 27 Jan 2007 14:29:15 +0100
Message-Id: <1169904555.2462.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I realized that any setting to  /sys/module/usbhid/parameters/pb_fnmode
is just ignored until the machine does a suspend-resume cycle.

I've added a printk in drivers/usb/input/hid-core.c (which is the only
place where hid->pb_fnmode is set) and indeed only on module load ( in
my case usbhid is compiled into the kernel - so on kernel boot) any
change to hid>pb_fnmode is done. Adding a printk to hidinput_pb_event()
in drivers/hid/hid-input.c says the same: hid->pb_fnmode cannot be
changed on the fly anymore...

HOWEVER: If I s2ram the machine hid->pb_fnmode is initialized with the
value I put into /sys/module/usbhid/parameters/pb_fnmode .

As I have no idea how/whether sysfs works/is possible I now hope someone
more knowledgable than me can resolve this issue!

Soeren
-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
