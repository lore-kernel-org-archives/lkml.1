Return-Path: <linux-kernel-owner+w=401wt.eu-S1760848AbXHAH4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760848AbXHAH4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 03:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbXHAH4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 03:56:25 -0400
Received: from webmail.icp-qv1-irony3.iinet.net.au ([203.59.1.108]:57568 "EHLO
	webmail.icp-qv1-irony3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752914AbXHAH4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 03:56:24 -0400
X-Greylist: delayed 621 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Aug 2007 03:56:23 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAAJzWr0bLzisi/2dsb2JhbAAN
X-IronPort-AV: i="4.19,207,1183305600"; 
   d="scan'208"; a="171907789:sNHT31428900"
Message-ID: <46B03A42.3030708@gmail.com>
Date: Wed, 01 Aug 2007 17:46:10 +1000
From: William Pettersson <william.pettersson@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070731)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: ALPS touchpad with new Dell not recognised
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've got a Dell Vostro 1400 here, which according to the Windows drivers
has an ALPS touchpad that I'm working on.  It has PS/2 pass through,
which means I can move the pointer around.  It also picks up (via
hardware I assume) quick double-taps as click-and-drag.  It however,
doesn't do multi-finger taps for middle and right mouse button.  It also
doesn't do side scrolling, which is the big one for me.

/proc/bus/inputs/devices lists the mouse as
I: Bus=0011 Vendor=0002 Product=0001 Version=0000
N: Name="PS/2 Generic Mouse"
P: Phys=isa0060/serio1/input0
S: Sysfs=/class/input/input20
H: Handlers=mouse0 event4
B: EV=7
B: KEY=70000 0 0 0 0 0 0 0 0
B: REL=3

I enabled debugging in the alps.c driver.  My touchpad "passes" the E6
test, but the E7 test it returns 0x73, 0x2, 0x50.  I've tried adding a
new model to the alps_model_info structure, with these numbers.
This made it be detected as an "Alps", but the behaviour was very
erratic, and kernel messages talked about the GlidePoint lost sync at
byte 1.

I'm not too familiar with the Alps driver, so I don't know exactly how
the byte0 or mask0 variables affect things.  I tried 0xff and 0xf8 as
they were two common options.

Is anyone familiar with the Alps driver, and able to help me work out
how to get this touchpad working?


William
