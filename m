Return-Path: <linux-kernel-owner+w=401wt.eu-S1752527AbXKRQdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbXKRQdT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 11:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751013AbXKRQdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 11:33:05 -0500
Received: from neopsis.com ([213.239.204.14]:49720 "EHLO
	matterhorn.dbservice.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750997AbXKRQdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 11:33:04 -0500
Message-ID: <4740692E.7010801@dbservice.com>
Date: Sun, 18 Nov 2007 17:32:46 +0100
From: Tomas Carnecky <tom@dbservice.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070802)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: laptop reboots right after hibernation
References: <473730F6.2010900@dbservice.com> <20071118105214.GB7299@ucw.cz>
In-Reply-To: <20071118105214.GB7299@ucw.cz>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Neopsis-MailScanner-Information: Neopsis MailScanner using ClamAV and Spaassassin
X-Neopsis-MailScanner: Found to be clean
X-Neopsis-MailScanner-SpamCheck: not spam, SpamAssassin (score=-2.284,
	required 5, autolearn=spam, AWL 0.21, BAYES_00 -2.60,
	RDNS_DYNAMIC 0.10)
X-MailScanner-From: tom@dbservice.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>> echo disk > /sys/power/state
>>
>> successfully saves that state to the disk, but just as the laptop is
>> about to turn itself off, it reboots (successfully, so the
>> hibernation/resume process works well, even with X running! which is
>> awesome :) ). But I'd rather like the computer turned off after I
>> hibernate it. Where could the problem be?
>>
>> It's a new laptop, TP X61 tablet, I tried ubuntu (7.10, gutsy) for a few
>> days, both suspend and hibernate worked there (with one or two crashes,
>> probably due to X, I've read that the intel driver got some
>> suspend/resume improvements recently). Now I'm running gentoo, kernel
>> 2.6.24-rc2. I'm using newer versions of almost all software now compared
>> to the ubuntu system.
> 
> If it works in older ubuntu, you can probably do bisect. Does normal
> shutdown work? You can try platform vs. shutdown mode...
> 

I don't have ubuntu anymore, though I'll try if hibernate works with the
livecd. One interesting thing I've found out: hibernate reboots the
laptop _only_ if it is in the docking station. If I hibernate while
outside of the docking station, it properly shuts down the laptop.

The default mode seems to be 'platform', after I echoed 'shutdown' to
/sys/power/disk the notebook correctly shuts down after hibernation!

Some interesting facts. All tests were done with 2.6.24-rc2, custom
tailored kernel with just the options needed for my notebook (ThinkPad
X61 Tablet) - without drm modules and bluetooth but with iwl4965 loaded.
All tests were done without X running, from the console. If I say
something 'works' it means I tested it at least three/four times in a
row (if not even more).

(1) Both STR and STD work correctly if I keep the notebook outside of
the docking station (both in platform and shutdown mode).

(2) Both STR and STD work correctly if I keep the notebook in the
docking station (both in platform and shutdown mode - with the small
glitch in platform mode that the notebook won't power off after
hibernation).

(3) Once the notebook was in the docking station (whether I boot it
while in the dock or boot it outside and then put it into the dock) and
I take it out (press the 'undock' button on the dock, wait for the green
led, then take out the notebook) things get interesting:

(a) I initiate STR, notebook correctly goes to sleep, but it only wakes
up if I have it in the docking station. If I try to wake it up outside
of the docking station it will fail.

(b) I initiate STD, and it locks up after a few seconds, at that time
only the cursor in the top left screen is visible (not blinking). If I
put the notebook in its locked up state into the dock, it will reboot
after a few seconds.

(4) If the notebook is in the dock and I initiate STR and then press the
undock button, it resumes (I assume that is 'working as intended').

(5) If the notebook is in the dock, I press the undock button and wait
for the green led then initiate STR, I can take the notebook out but
resuming doesn't work - unless I resume it while the notebook is back in
the docking station (see point 3a)

(6) If the notebook is in the dock, I press the undock button and wait
for the green led, then initiate STD:

(a) in platform mode: I can take the notebook out but resuming doesn't
work - unless I resume it while the notebook is back in the docking
station (contrary to point 3b). It seems as the notebook 'locks' itself
into the docking station during STD, I see the green led change into red
during the hibernation process (just before heavy HD activity starts).

(b) in shutdown mode: STD fails with a completely black screen, not even
the cursor is visible.

There doesn't seem to be a difference between platform and shutdown mode
other than the reboot glitch when the laptop is in the docking station
or as described in point 6.

tom
