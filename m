Return-Path: <linux-kernel-owner+w=401wt.eu-S1030472AbXAYRiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030472AbXAYRiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 12:38:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030479AbXAYRiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 12:38:25 -0500
Received: from fmmailgate09.web.de ([217.72.192.184]:34911 "EHLO
	fmmailgate09.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030472AbXAYRiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 12:38:24 -0500
Date: Thu, 25 Jan 2007 18:38:21 +0100
Message-Id: <1584060127@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Subject: Re: maximum of 256 loop devices - not enough for cdrom server
Organization: http://freemail.web.de/
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi !

this thread was about maximum number of loopdevices being limited to 256.

actually, there is dm-loop.c under development, a device-mapper target to replace traditional loopdevice. see discussion on dm-devel mailinglist.

it`s still having issues and thus not being an option for now, but maybe worth keeping an eye on if you are in need of having more than 256 loop devices......

regards
roland



On Thu, 26 May 2005 22:14:38 +0200 Jose Luis Domingo Lopez wrote:

> On Thursday, 26 May 2005, at 03:06:34 +0200,
> roland wrote:
> 
> > I want to build a cd-rom server and want to use the loop-driver (loop.c) for \
> > that.
> > That server will be HUGE and I will need to loopback mount more than 256 .iso \
> > images in the near future.
> > Unfortunately, the loop driver doesn`t support >256 device nodes.
> > 
> > Is there a possible solution for this "problem" ?


First, let's understand the kernel version.  2.4.x or 2.6.y?
I'm only looking at 2.6.y.

Roland, have you tried increasing the max. value of max_loop yet?


> Beware: not a kernel hacker, not even a proficient programmer.
> 
> It seems it would be easy, just changing the max current loop device
> number value (256) to something higher (i.e., 4096). Note, however, that
> loop devices are described by an array of structs statically allocated at
> module load time, so expect memory usage to grow linearly and search operations 
> on the array become slower at least linearly.

The loop_device array is kmalloc-ed at load/init time.
On x86 (32-bit), struct loop_device is 336 bytes, and with kmalloc()
having an upper limit of 128 KB, the max. number of loop_devices that
can be allocated at one time is 128 * 1024 / 336 = 390, not a huge
improvement over 256 loopback devices.

I don't know of any reason that vmalloc() couldn't be used here
instead of kmalloc(), and once that hurdle is cleared (the 128 KB one),
since minor number on 2.6.y is 20 bits, there can be plenty of loopback
devices AFAIK.

I'm sure that Al or probably Andrew could answer this reliably.

> There is one thing that maybe would need some attetion: minor number
> allocation for loopback block devices. Now they are assigned at module
> initialization, but I don't know the current status in the Linux kernel
> with respect to (major,minor) sizes and allocation.
> 
> Hope someone more knowledgeable jumps into this :-)


---
~Randy
http://www.madrone.org/donate/RFD1.html
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
_____________________________________________________________________
Der WEB.DE SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen!
http://smartsurfer.web.de/?mc=100071&distributionid=000000000066

