Return-Path: <linux-kernel-owner+w=401wt.eu-S1753500AbXDIPd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbXDIPd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 11:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbXDIPd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 11:33:56 -0400
Received: from vms040pub.verizon.net ([206.46.252.40]:38899 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbXDIPdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 11:33:55 -0400
Date: Mon, 09 Apr 2007 11:33:42 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: plain 2.6.21-rc5 (1) vs amanda (0)
In-reply-to: <1175661256.31439.23.camel@obelisk.thedillows.org>
To: linux-kernel@vger.kernel.org
Cc: Dave Dillow <dave@thedillows.org>, ray-gmail@madrabbit.org,
       Ingo Molnar <mingo@elte.hu>, amanda-hackers@amanda.org,
       amanda-users@amanda.org
Message-id: <200704091133.44684.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200704010100.19016.gene.heskett@verizon.net>
 <1175488272.3161.28.camel@obelisk.thedillows.org>
 <1175661256.31439.23.camel@obelisk.thedillows.org>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 April 2007, Dave Dillow wrote:
>On Mon, 2007-04-02 at 00:31 -0400, Dave Dillow wrote:
>> On Mon, 2007-04-02 at 00:20 -0400, Gene Heskett wrote:
>
>[snipped for brevity]
>
>> > [root@coyote music]# stat .
>> > Device: fd00h/64768d    Inode: 10354963    Links: 39
>> >
>> > Now rebooted to 2.6.21-rc5:
>> > Device: ee00h/60928d    Inode: 10354963    Links: 39
>>
>> For those playing along at home, I believe the issue is that GNU tar
>> sees a different device number for the directories than what is listed
>> in the listed-incremental snapshot file, and thinks all of the
>> directories are new. I've asked Gene to make a few back-to-back runs
>> of the tar command under the same kernel to see if the subsequent runs
>> figure out that there's nothing to do, as expected.
>
>Gene has confirmed that GNU tar figures it out as expected.
>
>> Then it is a matter of figuring out why the device number changed --
>> I'm thinking it is device-mapper, but will look closer tomorrow.
>
>This commit is the one that changed it:
>
>commit fdf892be32d84a1745fa0aee5fc60517421b8038
>Author: Andrew Morton <akpm@osdl.org>
>Date:   Mon Feb 12 00:51:44 2007 -0800
>
>    [PATCH] register_blkdev(): don't hand out the LOCAL/EXPERIMENTAL
> majors
>
>    As pointed out in http://bugzilla.kernel.org/show_bug.cgi?id=7922,
> dynamic blockdev major allocation can hand out majors which LANANA has
> defined as being for local/experimental use.
>
>
>I'm not sure I could argue for that to be reverted, so here's a possible
>workaround for Fedora -- completely untested.
>
>Add the following to /etc/modprobe.conf:
>options dm_mod major=253

This does not work.

>And make a new initrd for the problematic kernel. This assumes that
>you're using device mapper as a module.
>
>If you're building it in, then either dm.major=253 or dm_mod.major=253
>should work on the kernel command line, but I'm not sure which it is.

I'll try this, I just put both in the kernel command line for 2.6.21-rc6, 
except I set it for the 238 it was at before the patch was reverted.  I'd 
put the patch back in myself, but my searching of the lkml corpus here 
hasn't turned it up.

>Dave



-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Do not drink coffee in early A.M.  It will keep you awake until noon.
