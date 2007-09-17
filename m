Return-Path: <linux-kernel-owner+w=401wt.eu-S1755410AbXIRIBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbXIRIBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 04:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbXIRIBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 04:01:31 -0400
Received: from frosty.hhs.nl ([145.52.2.15]:34126 "EHLO frosty.hhs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418AbXIRIBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 04:01:31 -0400
X-Greylist: delayed 67864 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Sep 2007 04:01:30 EDT
Message-ID: <46EE7961.3050309@hhs.nl>
Date: Mon, 17 Sep 2007 14:56:01 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070911)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: [GIT PATCH] USB autosuspend fixes for 2.6.23-rc6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.2/RELEASE, bases: 17092007 #394302, status: clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Please keep me CC-ed I'm not on the list. I just found out about this thread 
while ivnestegating some autosuspend problems, which I will describe in another 
list.

stern at rowland  wrote:
 > Linus Torvalds wrote:
 > > - US_FL_FIX_CAPACITY:
 > > This is a generic SCSI issue, not a USB one, and maybe there are
 > > better solutions to it. Are we perhaps doing something wrong? Is
 > > there some patterns we haven't seen? Why do we need this, when
 > > presumably Windows does not?
 >
 > Why doesn't Windows need this? For all we know, it does. Has anybody
 > ever tried forcing Windows to read the sector beyond the end of one of
 > these buggy devices?

I haven't but I'm pretty sure it will crash my hp usb printer (with builtin 
cardreader)

 > For one reason or another, Linux supports filesystems/partitioning
 > schemes which do need to access the last sector (EFI GUID, md, maybe
 > others). Some devices are so buggy that trying to read the nonexistent
 > "last" sector causes them to lock up, requiring a power cycle.
 > Obviously we can't probe for this sort of behavior. (There was one
 > report of a device which _could_ read its last sector correctly, but
 > only if the transfer was exactly 1 sector long! Attempts to read two
 > sectors starting from the second-to-last sector would cause it to
 > crash.)

Yes and the reporter of that one device (a HP PSC1350) would be me, I even 
wrote a patch introducing a new quirk for this (shoot me, I don't like quirks 
either, but if we can choose between making some device work and not 
introducing a quirk, I say make the device work!)

Talking about this patch (posted to the usb-storage list) I haven't received 
any feedback, any chance this patch could get integrated soon? I have found 
another Linux user with the same printer and the same problem who has 
independently verified my patch fixes it. Currently a third Linux using owner 
of such a device has contacted me, I'm waiting for his feedback if the patch 
helps him too, but I assume it will. That makes 3 users who have jumped through 
many hoops to get it to work, so there are probably many other users who have 
just given up, or even returned to that other OS!

I'm pretty sure the only reason why that other OS doesn't crash the printer is 
because it normally doesn't try to read the last sector, I haven't tried as I 
no longer have that other OS on any computer in my home.

Also I think it might be an idea to have an option to easily disable the 
partition reading code which tries to read the end of the disk, this seems to 
cause problems in various places.

Regards,

Hans

