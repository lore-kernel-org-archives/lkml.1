Return-Path: <linux-kernel-owner+w=401wt.eu-S1752330AbXDTCkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330AbXDTCkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 22:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbXDTCkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 22:40:55 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:4401 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbXDTCky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 22:40:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=PAPYQ25yGKtTvrwciLMaSWG/CDvoFSbsaLOdHozTST+v07SYJAkVxqlJdoZzPv0ETwSvBU/8lu9HdMgvVWsKSij6zkBMAWrUMpLvCFV51zGUA526m1a3RUxjUg0ffcrltJ6RYjlXFkBkF6WNVQfBmrriqQRR7W5EKi/KuXSWm1I=
Message-ID: <cb7bb73a0704191940s1fd6487j9a4412aebd4342c0@mail.gmail.com>
Date: Fri, 20 Apr 2007 04:40:39 +0200
From: "Giuseppe Bilotta" <giuseppe.bilotta@gmail.com>
To: linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com, jkosina@suse.cz,
       edouard.tisserant@wanadoo.fr, svoltz@numericable.fr
Subject: Acecad USB Tablet: usbmouse takeover and odd motion
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I have a Medi@com-branded Acecad USB Tablet and I've been trying for a
while to set it up to work fine under Linux, without very much
success. I've been using the stock Debian kernel (2.6.18), but also
tried rolling my own 2.6.x git series (latest tried a 2.6.21-rc7 just
this evening). The problems still appear.

The first problem is that the usbmouse and usbhid drivers take control
of the device, so that when I plug it in the tablet appears as a
mouse, with extremely funny effects (cursor jumping around, buttons
clicking out of nowhere, and other strange stuff).I have to rmmod
usbmouse and usbhid and then re-modprobe acecad to get proper data
from the tablet (where by 'proper' I mean that input-events reports
apparently correct values for X, Y, pressure and keypresses.

So the first question is: is there a way to let acecad control the
tablet without blacklisting usbmouse and usbhid?

The second question is more user-space related, so this might not be
the right place to ask; feel free to address me to more appropriate
discussion places for the following issues.

Basically, in console the tablet works 'almost' correctly, with gpm
set to read from /dev/input/mice with protocol autops2: if I wrap the
pen from one side to the opposite side without passing through the
tablet, the cursor jumps to the correct place. However, if I move the
pen across the tablet, the motion seems to be always either too fast
or too slow, so that either the mouse reaches the opposite side of the
screen while I'm still halfway throught the tablet, or conversely.

In X (X.org 7.2.0), I cannot use the acecad driver (it fails to
initialize the device, probably because it's managed by the kernel
already, I assume), so I have to use the evdev driver version 1.1.0
(xinput version 1.2.0). With this setup, programs such as Inkscape or
Gimp 'know' that the Tablet is a tablet and correctly configure the
3rd axis for pressure, but the cursor movement is extremely jerky, and
neither pressure nor button presses seem to be received, making the
tablet essentially useless.

I've tried setting CONFIG_INPUT_MOUSEDEV_SCREEN_{X,Y} to match my
screen resolution {1600,1200}, but this has barely improved the motion
jerkiness, if at all (Why is there a need for the kernel to know the
resolution used by X, anyway? Shouldn't userspace itself take care of
scaling input->screen coordinates?) Moreover, it hasn't solved the
missing buttons/pressure.

 Is this an evdev/X bug, a kernel limitation, neither or both?

-- 
Giuseppe "Oblomov" Bilotta
