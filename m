Return-Path: <linux-kernel-owner+w=401wt.eu-S1764874AbXKUABi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764874AbXKUABi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 19:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757880AbXKUABb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 19:01:31 -0500
Received: from fmmailgate04.web.de ([217.72.192.242]:59264 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587AbXKUABa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 19:01:30 -0500
Date: Wed, 21 Nov 2007 01:01:27 +0100
Message-Id: <2097618015@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: System reboot triggered by just reading a device file....!?
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX18YK/lJI6Ih5UoQQDxqbjF7ln0A8/Kv4IRocgb2Qo1l5fbp1
 NN3Me+88HYOOwjbgN8VtaisJff67nJmLOWJ2BAS9Wchk3lFHXs=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>There is.. it's called "root privileges".
yes, true.

but - regardless of being a windows app or not - what if you want to take a look on your system as a whole, especially when using some tool which graphically shows how and where your diskspace is being used?  if i let this run from ordinary useraccount it would get lot`s of "permission denied"  and then it`s only telling half of the truth.....

>I'd say running pretty much anything through Wine as root is 
> not a good idea, a Windows app could hose the system without even 
> meaning to through exactly such things.
yes, true indeed. but maybe wine has an option to sandbox the windows app to do only r/o access.  if that feature doesn`t exist, (set r/o flag to dosdevices) maybe it would be an useful addon.
but that`s OT here....


> -----Ursprüngliche Nachricht-----
> Von: "Robert Hancock" <hancockr@shaw.ca>
> Gesendet: 21.11.07 00:35:23
> An: devzero@web.de
> CC: linux-kernel@vger.kernel.org
> Betreff: Re: System reboot triggered by just reading a device file....!?


> 
> devzero@web.de wrote:
> > good evening, 
> > 
> > i stumbled over some funny issue when trying windirstat (like KDirStat) with wine.
> > 
> > after running that tool for a while my system rebooted. i could reproduce this with every run.
> > 
> > after some deep investigation (i thought i had stability issues with my system and spent more than an hour on this) i found out, that the reboot is being triggered by iTCO_wdt ( /dev/watchdog )
> > 
> > this is how to reproduce:
> > 
> > - be root
> > -  cat /dev/watchdog or dd if=/dev/watchdog of=/dev/zero bs=1 count=1 or .....
> > -  wait one minute........
> > 
> > *reboot*!
> > 
> > i have heard 2 opinions for now (contacted the author and also discussed on wine-devel ) that this should be expected behaviour.
> 
> Yes, it is. It's a watchdog device, it's meant to reboot the machine if 
> whatever task is poking the watchdog dies.
> 
> > being sysadmin quite a while, i cannot believe that (accidentally) reading a device file (being root or not - what does that matter) triggers a system reboot.
> > 
> > ok - when i`m root , i shouldn`t do stupid things and be careful, but i thought reading/crawling trough a filesystem (r/o, btw.) with some tool which is built to do exactly this wasn`t so stupid - even from within wine.
> 
> I would say that running a Windows tool that opens up and reads random 
> files, on the /dev directory tree, as root, probably does qualify as 
> "stupid". I'd say running pretty much anything through Wine as root is 
> not a good idea, a Windows app could hose the system without even 
> meaning to through exactly such things.
> 
> > 
> > think of an admin writing a quick&dirty script for intrusion detection (find / -exec md5sum {} \; >/tmp/need-no-tripwire) and forgetting to exclude /dev, /sys or /proc appropriately......
> > think of someone exporting "/" via samba (readonly) and then navigating trough the /dev directory....
> > 
> > stupid?
> > i don`t think so.....i have seen worse things...... :)
> > 
> > should someone get punished  by an accidental system reboot and should he need to spend his time on this to investigate why this happens?
> > 
> > i`d wish there would be some fence around this or iTCO_wdt /dev/watchdog not being active after a default desktop installation.
> 
> There is.. it's called "root privileges".
> 
> > 
> > i`d be interested if i`m the only one who thinks this is strange/dangerous behaviour.
> > 
> > regards
> > roland
> 
> 
> -- 
> Robert Hancock      Saskatoon, SK, Canada
> To email, remove "nospam" from hancockr@nospamshaw.ca
> Home Page: http://www.roberthancock.com/
> 
> 


__________________________________________________________________________
Erweitern Sie FreeMail zu einem noch leistungsstärkeren E-Mail-Postfach!		
Mehr Infos unter http://produkte.web.de/club/?mc=021131

