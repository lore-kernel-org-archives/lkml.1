Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbYAJLuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbYAJLuc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 06:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752820AbYAJLuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 06:50:23 -0500
Received: from embla.aitel.hist.no ([158.38.50.22]:52384 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbYAJLuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 06:50:22 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jan 2008 06:50:21 EST
Message-ID: <478601D7.90004@aitel.hist.no>
Date: Thu, 10 Jan 2008 12:30:31 +0100
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Matthias Schniedermeyer <ms@citd.de>
CC: Tuomo Valkonen <tuomov@iki.fi>, linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi> <20080108164847.GA16462@skl-net.de> <slrnfo7e3i.c37.tuomov@jolt.modeemi.cs.tut.fi> <20080108230600.GA9071@citd.de>
In-Reply-To: <20080108230600.GA9071@citd.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthias Schniedermeyer wrote:
>>> Don't use udev then. Good old static dev works fine if you have a fixed
>>> set of devices.
>>>       
>> It doesn't, with the unpredictable SCSI mapping insanity.
>>     
>
> That what LABEL und UUID-Support in mount is for.
>
> You label the filesystems (e2label for ext2 and ext3) and use that label to mount them
>
> - fstab -
> LABEL=root  /        xfs     defaults,noatime	0 1
> LABEL=boot  /boot    ext2    defaults,noatime	0 2
>   
Would've been nice if they worked, but they don't.

Disks should be so easy to identify uniquely, because they have
storage space that can be used for that label.

So I tried (debian linux, last year).

Mount by label was fine, of course.
Until the 33rd reboot, when it was decided that a
fsck was necessary "just to be safe".  The problem was that fsck
fail to find the correct device when /etc/fstab specifies a label
instead of a device. The boot failed, reboot with init=/bin/sh
and replace the dysfunctional labels with oldfashioned device names.

I can live with this kind of problem on my desktop, but this machine
was going to be a internet router for a customer, so occational
boot failure requiring intervention was not an option.

Helge Hafting






