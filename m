Return-Path: <linux-kernel-owner+w=401wt.eu-S1761250AbXKTXey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761250AbXKTXey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 18:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbXKTXer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 18:34:47 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:29652 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbXKTXeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 18:34:46 -0500
Date: Tue, 20 Nov 2007 17:34:24 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: System reboot triggered by just reading a device file....!?
In-reply-to: <fa.NKMd2cOUI5zSAFh0xiVy3hZdy3s@ifi.uio.no>
To: devzero@web.de
Cc: linux-kernel@vger.kernel.org
Message-id: <47436F00.80005@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15; format=flowed
Content-transfer-encoding: 7bit
References: <fa.NKMd2cOUI5zSAFh0xiVy3hZdy3s@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

devzero@web.de wrote:
> good evening, 
> 
> i stumbled over some funny issue when trying windirstat (like KDirStat) with wine.
> 
> after running that tool for a while my system rebooted. i could reproduce this with every run.
> 
> after some deep investigation (i thought i had stability issues with my system and spent more than an hour on this) i found out, that the reboot is being triggered by iTCO_wdt ( /dev/watchdog )
> 
> this is how to reproduce:
> 
> - be root
> -  cat /dev/watchdog or dd if=/dev/watchdog of=/dev/zero bs=1 count=1 or .....
> -  wait one minute........
> 
> *reboot*!
> 
> i have heard 2 opinions for now (contacted the author and also discussed on wine-devel ) that this should be expected behaviour.

Yes, it is. It's a watchdog device, it's meant to reboot the machine if 
whatever task is poking the watchdog dies.

> being sysadmin quite a while, i cannot believe that (accidentally) reading a device file (being root or not - what does that matter) triggers a system reboot.
> 
> ok - when i`m root , i shouldn`t do stupid things and be careful, but i thought reading/crawling trough a filesystem (r/o, btw.) with some tool which is built to do exactly this wasn`t so stupid - even from within wine.

I would say that running a Windows tool that opens up and reads random 
files, on the /dev directory tree, as root, probably does qualify as 
"stupid". I'd say running pretty much anything through Wine as root is 
not a good idea, a Windows app could hose the system without even 
meaning to through exactly such things.

> 
> think of an admin writing a quick&dirty script for intrusion detection (find / -exec md5sum {} \; >/tmp/need-no-tripwire) and forgetting to exclude /dev, /sys or /proc appropriately......
> think of someone exporting "/" via samba (readonly) and then navigating trough the /dev directory....
> 
> stupid?
> i don`t think so.....i have seen worse things...... :)
> 
> should someone get punished  by an accidental system reboot and should he need to spend his time on this to investigate why this happens?
> 
> i`d wish there would be some fence around this or iTCO_wdt /dev/watchdog not being active after a default desktop installation.

There is.. it's called "root privileges".

> 
> i`d be interested if i`m the only one who thinks this is strange/dangerous behaviour.
> 
> regards
> roland


-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

