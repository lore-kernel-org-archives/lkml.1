Return-Path: <linux-kernel-owner+w=401wt.eu-S932502AbXCTJZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502AbXCTJZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 05:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933277AbXCTJZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 05:25:59 -0400
Received: from mout2.freenet.de ([194.97.50.155]:41027 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932502AbXCTJZ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 05:25:58 -0400
X-Greylist: delayed 1642 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Mar 2007 05:25:57 EDT
To: linux-kernel@vger.kernel.org
From: balagi@justmail.de
Subject: user defined hotplug events?
X-Priority: 3
X-Abuse: 300631278 / 212.34.68.18
User-Agent: freenetMail
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <E1HTaAr-0007r6-B0@www10.emo.freenet-rz.de>
Date: Tue, 20 Mar 2007 09:58:33 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

on my notebook, the built in wlan card uses the ipw2100 driver. On boot
time, the ipw2100 module is loaded and fires a hotplug "add" event.
The hotplug event configures the interface and starts wpa_supplicant and wpa_cli.
The ipw2100 chip can be enabled/disabled by a hardware switch, so i 
only enabled it if i need a connection.

Now: even if the wlan hardware is disabled by the switch, wpa_supplicant tries
to get a connection. That's not fine...
The ipw2100 driver exports a switch state file in sysfs, but polling this file is not
fine also.

I want that it works as follows:
A state change of the hardware switch should fire a hotplug event, so that the
wpa_* programs are started if the switch is put on, and killed if the switch is put
off.
The ipw2100 driver already logs a state change of the switch in klog, so adding
a kobject_uevent should not be the major problem. But which KOBJ_* event enum
should be used? KOBJ_ONLINE, KOBJ_OFFLINE ?
Or new, user defined, ones?

Comments? Suggestions?

Thomas



"Jetzt Handykosten senken mit klarmobil - 14 Ct./Min.! Hier klicken"
http://www.klarmobil.de/index.html?pid=73025

