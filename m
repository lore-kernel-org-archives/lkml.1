Return-Path: <linux-kernel-owner+w=401wt.eu-S1751409AbZHRTM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409AbZHRTM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 15:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750823AbZHRTMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 15:12:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55592 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbZHRTMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 15:12:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Harald Dunkel <harald.dunkel@t-online.de>
Subject: Re: [Bug #13374] reiserfs blocked for more than 120secs
Date: Tue, 18 Aug 2009 21:12:53 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: =?iso-8859-2?q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jeff Mahoney <jeffm@suse.com>, Tejun Heo <htejun@gmail.com>
References: <upey9ZSfnaF.A.-oE.rpgdKB@chimera> <200908122315.09420.rjw@sisk.pl> <4A8AE52F.6030606@t-online.de>
In-Reply-To: <4A8AE52F.6030606@t-online.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200908182112.53486.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 August 2009, Harald Dunkel wrote:
> Hi Rafael,
> 
> I haven't seen the 120secs timeout yet, but using 2.6.31-rc5 there _are_
> some delays that I am not sure of. Sometimes it takes about 30 secs till
> the XWindow server comes up, for example. (I use xinit on the command line
> at login. / and /home are both reiserfs.) For 2.6.30.4 and older I haven't
> seen this delay yet, AFAIR.
> 
> Most recent event: I tried to format a 4 GByte USB stick with reiserfs.
> Here is the screen output:
> 
> 	# device=/dev/sdf
> 	# parted $device mklabel gpt
> 	Warning: The existing disk label on /dev/sdf will be destroyed and
> 	all data on this disk will be lost. Do you want to continue?
> 	Yes/No? Yes
> 	Information: You may need to update /etc/fstab.
> 
> 	# parted -- $device mkpart primary 0s -1s
> 	Warning: You requested a partition from 0.00B to 4127MB.
> 	The closest location we can manage is 17.4kB to 4127MB.
> 	Is this still acceptable to you?
> 	Yes/No? Yes
> 	Information: You may need to update /etc/fstab.
> 
> 	# mkreiserfs -l usbstick /dev/sdf1
> 	mkreiserfs 3.6.21 (2009 www.namesys.com)
> 	:
> 	:
> 	UUID: 154d66cc-02ac-4979-9a39-163e3cf80623
> 	LABEL: usbstick
> 	ATTENTION: YOU SHOULD REBOOT AFTER FDISK!
> 	        ALL DATA WILL BE LOST ON '/dev/sdf1'!
> 	Continue (y/n):y
> 	Initializing journal - 0%....20%....40%....60%....80%....100%
> 	Syncing..ok
> 	ReiserFS is successfully created on /dev/sdf1.
> 
> It took about 2 to 3 minutes till the "ok" in the "Syncing" line
> was shown. /var/log/messages was silent. When I tried to reproduce
> the delay it was gone, of course.

Thanks for the update.

> Since I would like to try 2.6.31-rc6 anyway, maybe you could post
> some hints about what debugging options to set in the config file?

Unfortunately, I don't have much experience with debugging issues of this kind.

Perhaps Tejun will have some hints (CC added)?

Best,
Rafael
