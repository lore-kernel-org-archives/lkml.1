Return-Path: <linux-kernel-owner+w=401wt.eu-S1755325AbYAGTyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbYAGTyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 14:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbYAGTyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 14:54:10 -0500
Received: from mailout03.sul.t-online.de ([194.25.134.81]:56893 "EHLO
	mailout03.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752577AbYAGTyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 14:54:09 -0500
Message-ID: <4782833D.3010600@t-online.de>
Date: Mon, 07 Jan 2008 20:53:33 +0100
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.24-rc7, intel audio: alsa doesn't say a beep
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: r1ke0mZYYh-FSdIT8L+J8xJBPyqJil17rjVRP3grxQvA3ayqjsiuiGyHOw7jld6ZK6
X-TOI-MSGID: f91b3485-feff-4cc2-b0f7-1b505dc95a0c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

Upgrading from 2.6.24-rc6 to rc7 Alsa stopped working for me. I still
can access /dev/dsp, change the volume and so on, but the speakers
are quiet. Moving back to rc6 there is no such problem.

Of course the config files are the same (except for some new
CONFIG_SLABINFO variable).


lspci says:

00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 02)
00:1b.0 0403: 8086:284b (rev 02)

% aplay -l
**** List of PLAYBACK Hardware Devices ****
card 0: Intel [HDA Intel], device 0: STAC92xx Analog [STAC92xx Analog]
   Subdevices: 1/1
   Subdevice #0: subdevice #0
card 0: Intel [HDA Intel], device 1: STAC92xx Digital [STAC92xx Digital]
   Subdevices: 1/1
   Subdevice #0: subdevice #0



The only difference between rc6 and rc7 in sound/pci/hda/hda_intel.c is
this:

diff -ur linux-2.6.24-rc6/sound/pci/hda/hda_intel.c linux-2.6.24-rc7/sound/pci/hda/hda_intel.c
--- linux-2.6.24-rc6/sound/pci/hda/hda_intel.c	2007-12-21 02:25:48.000000000 +0100
+++ linux-2.6.24-rc7/sound/pci/hda/hda_intel.c	2008-01-06 22:45:38.000000000 +0100
@@ -555,7 +555,8 @@
  		}
  		if (!chip->rirb.cmds)
  			return chip->rirb.res; /* the last value */
-		schedule_timeout_uninterruptible(1);
+		udelay(10);
+		cond_resched();
  	} while (time_after_eq(timeout, jiffies));

  	if (chip->msi) {


Do you think this could be related to the problem?


Any hint would be highly appreciated. Please mail if I can help to
track this down.


Regards

Harri

