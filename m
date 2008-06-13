Return-Path: <linux-kernel-owner+w=401wt.eu-S1759689AbYFMVzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759689AbYFMVzM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 17:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbYFMVy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 17:54:58 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49517 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939AbYFMVy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 17:54:57 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4852ECAC.9060106@s5r6.in-berlin.de>
Date: Fri, 13 Jun 2008 23:54:52 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Shawn Jin <shawnxjin@gmail.com>
CC: Tomasz Chmielewski <mangoo@wpkg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Force a usb drive to be /dev/sda?
References: <4850DFB4.5020205@wpkg.org> <4851046E.907@s5r6.in-berlin.de>	 <c3d0340b0806122232s72d37509wd976217d336b83e7@mail.gmail.com>	 <48521539.9020102@s5r6.in-berlin.de> <c3d0340b0806131329n604b11bcv5dce0985580516fc@mail.gmail.com>
In-Reply-To: <c3d0340b0806131329n604b11bcv5dce0985580516fc@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shawn Jin wrote:
>>> The bootloader I'm using is LILO. So I have to specify the boot device
>>> and the root device in lilo.conf. For example, boot=/dev/sda,
>>> root=/dev/sda1. I'm not sure how mounting filesystem by UUID or by
>>> label can help. A little bit elaboration will be more helpful.
>> Ah I forgot that...  Looks like this requires an initrd too, though without
>> special scripts of your own.
> 
> Forgive my slowness to understand your suggestion. The kernel I built
> has all the sata drivers, usb drivers, and scsi layer built in. So
> during the kernel bootup before the root is mounted, all drives (sata
> and usb) are scanned and detected. How does an initrd plus mounting
> the root filesystem by UUID or label help here? Or how can I set the
> "root" in the lilo.conf?

I haven't used lilo for a while, nor initrd, hence I can't give you a 
detailed recipe.  You specify the initrd as device with root filesystem 
to the boot manager.  In the initrd you have e.g. an fstab by which you 
mount the later root filesystem based on the filesystem ID.  Then the 
initrd chroots to that fs.

> If an initrd is used, I would rather go with option 3. That is, build
> SATA drivers as loadable modules and load them in the initrd. Then
> before initrd loads sata drivers, there is only one usb drive as
> /dev/sda.

In that case you don't need an initrd at all.

> Also I'm lost by this comment: "though without special scripts of your
> own". Could you explain it in another way? Were you saying that I need
> my own special scripts to mount the root filesystem by UUID or label?
> I think this is quite obvious since I need to build an initrd, which
> is always customized. :-P

A little bit more would be necessary if the initrd had to pick up device 
IDs.  If you just use the initrd to load some modules and to mount the 
subsequent root fs, it won't really look different from most distributor 
initrds AFAICS.
-- 
Stefan Richter
-=====-==--- -==- -==-=
http://arcgraph.de/sr/
