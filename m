Return-Path: <linux-kernel-owner+w=401wt.eu-S1753920AbYJ2MZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbYJ2MZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 08:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbYJ2MZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 08:25:21 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:61235 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbYJ2MZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 08:25:19 -0400
Message-ID: <ac3eb2510810290525h1579bad8i4836ce1291d9022@mail.gmail.com>
Date: Wed, 29 Oct 2008 13:25:17 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Folkert van Heusden" <folkert@vanheusden.com>
Subject: Re: [2.6.26] kobject_add_internal failed for 2:0 with -EEXIST / unable to handle kernel NULL pointer dereference in sysfs_create_link
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081029094041.GO11214@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081028151157.GI11214@vanheusden.com>
	 <ac3eb2510810281607o19266977l4c77d3d3ab4bb849@mail.gmail.com>
	 <20081029094041.GO11214@vanheusden.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 10:40, Folkert van Heusden
<folkert@vanheusden.com> wrote:
>> > While running my http://vanheusden.com/pyk/ script (which randomly
>> > inserts and removes modules) I triggered the folllowing oops in a 2.6.26
>> > kernel on an IBM xSeries 260. This oops (in fact no oops at all) did not
>> > get triggered in a 2.6.18 kernel on that system.
>> >
>> > [   42.507375] FDC 0 is a National Semiconductor PC87306
>> > [   42.509057] kobject_add_internal failed for 2:0 with -EEXIST, don't try to register things with the same name in the same directory.
>> > [   42.509291] Pid: 5301, comm: modprobe Not tainted 2.6.26-1-amd64 #1
>> > [   42.509431]
>> > [   42.509433] Call Trace:
>> > [   42.509685]  [<ffffffff8031b031>] kobject_add_internal+0x13f/0x17e
>> > [   42.509823]  [<ffffffff8031b46e>] kobject_add+0x74/0x7c
>> > [   42.509969]  [<ffffffff802e2470>] sysfs_addrm_finish+0x19/0x1ea
>> > [   42.510141]  [<ffffffff802e21b4>] sysfs_find_dirent+0x1b/0x2f
>> > [   42.510331]  [<ffffffff802e2741>] create_dir+0x5a/0x87
>> > [   42.510466]  [<ffffffff8031ae88>] kobject_get+0x12/0x17
>> > [   42.510614]  [<ffffffff80382771>] get_device+0x17/0x20
>> > [   42.510754]  [<ffffffff80382d81>] device_add+0x9b/0x53f
>> > [   42.510915]  [<ffffffff8031acf2>] kobject_init+0x41/0x69
>> > [   42.511374]  [<ffffffff803832d1>] device_create_vargs+0x9a/0xc6
>> > [   42.511519]  [<ffffffff8027d23b>] bdi_register+0x57/0xb4
>>
>> Looks like bdi sees two devices with the same devnum, or didn't
>> cleanup an old entry.
>> What does: ls -l "/sys/class/bdi/" print?
>
> The following:
> folkert@debiantesthw:~$ ls -l /sys/class/bdi/
> total 0

> drwxr-xr-x 3 root root 0 2008-10-28 18:32 2:0
> drwxr-xr-x 3 root root 0 2008-10-28 18:32 2:1

Oh, you are running the old sysfs layout without symlinks. Care to
tell where the "device" link in these directories points to?

Thanks,
Kay
