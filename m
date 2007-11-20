Return-Path: <linux-kernel-owner+w=401wt.eu-S1759530AbXKTXHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530AbXKTXHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 18:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756835AbXKTXHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 18:07:01 -0500
Received: from fmmailgate05.web.de ([217.72.192.243]:63583 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484AbXKTXHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 18:07:00 -0500
Date: Wed, 21 Nov 2007 00:06:57 +0100
Message-Id: <2097505946@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Subject: System reboot triggered by just reading a device file....!?
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX19z5uju4YC8KvGXjvDDlxPckFCRvjyReJbgP/2VuT3ACuWYo
 y7kB2y72ZrFX/djiklDn5y60rSEytmkg49LvRhFlIwyK2snWl8=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

good evening, 

i stumbled over some funny issue when trying windirstat (like KDirStat) with wine.

after running that tool for a while my system rebooted. i could reproduce this with every run.

after some deep investigation (i thought i had stability issues with my system and spent more than an hour on this) i found out, that the reboot is being triggered by iTCO_wdt ( /dev/watchdog )

this is how to reproduce:

- be root
-  cat /dev/watchdog or dd if=/dev/watchdog of=/dev/zero bs=1 count=1 or .....
-  wait one minute........

*reboot*!

i have heard 2 opinions for now (contacted the author and also discussed on wine-devel ) that this should be expected behaviour.

being sysadmin quite a while, i cannot believe that (accidentally) reading a device file (being root or not - what does that matter) triggers a system reboot.

ok - when i`m root , i shouldn`t do stupid things and be careful, but i thought reading/crawling trough a filesystem (r/o, btw.) with some tool which is built to do exactly this wasn`t so stupid - even from within wine.

think of an admin writing a quick&dirty script for intrusion detection (find / -exec md5sum {} \; >/tmp/need-no-tripwire) and forgetting to exclude /dev, /sys or /proc appropriately......
think of someone exporting "/" via samba (readonly) and then navigating trough the /dev directory....

stupid?
i don`t think so.....i have seen worse things...... :)

should someone get punished  by an accidental system reboot and should he need to spend his time on this to investigate why this happens?

i`d wish there would be some fence around this or iTCO_wdt /dev/watchdog not being active after a default desktop installation.

i`d be interested if i`m the only one who thinks this is strange/dangerous behaviour.

regards
roland


_____________________________________________________________________
Der WEB.DE SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen!
http://smartsurfer.web.de/?mc=100071&distributionid=000000000066

