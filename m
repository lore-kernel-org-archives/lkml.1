Return-Path: <linux-kernel-owner+w=401wt.eu-S1754303AbZGBPT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbZGBPT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 11:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbZGBPTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 11:19:21 -0400
Received: from smtp.nokia.com ([192.100.122.230]:53138 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbZGBPTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 11:19:21 -0400
Message-ID: <4A4CCF99.30104@gmail.com>
Date: Thu, 02 Jul 2009 18:17:45 +0300
From: Artem Bityutskiy <dedekind1@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Daniel Mack <daniel@caiaq.de>
CC: linux-kernel@vger.kernel.org, Artem Bityutskiy <dedekind@infradead.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>,
       linux-mtd@lists.infradead.org
Subject: Re: [PATCH] ubifs: allow more than one volume to be mounted
References: <1246547747-13366-1-git-send-email-daniel@caiaq.de>
In-Reply-To: <1246547747-13366-1-git-send-email-daniel@caiaq.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 02 Jul 2009 15:17:47.0021 (UTC) FILETIME=[415653D0:01C9FB28]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Mack wrote:
> UBIFS uses a bdi device per volume, but does not care to hand out unique
> names to each of them. This causes an error when trying to mount more
> than one volumes.
> 
> [  239.277407] kobject_add_internal failed for ubifs with -EEXIST, don't try to register things with the same name in the same directory.
> [  239.289618] [<c002a45c>] (unwind_backtrace+0x0/0xdc) from [<c0160628>] (kobject_add_internal+0x188/0x1b8)
> [  239.299445] [<c0160628>] (kobject_add_internal+0x188/0x1b8) from [<c01607d8>] (kobject_add+0x48/0x5c)
> [  239.308896] [<c01607d8>] (kobject_add+0x48/0x5c) from [<c019d96c>] (device_add+0xac/0x510)
> [  239.317392] [<c019d96c>] (device_add+0xac/0x510) from [<c019de58>] (device_create_vargs+0x70/0xa4)
> [  239.326589] [<c019de58>] (device_create_vargs+0x70/0xa4) from [<c0073138>] (bdi_register+0x44/0x64)
> [  239.335854] [<c0073138>] (bdi_register+0x44/0x64) from [<c01249f0>] (ubifs_get_sb+0x3c8/0x10cc)
> [  239.344769] [<c01249f0>] (ubifs_get_sb+0x3c8/0x10cc) from [<c008b054>] (vfs_kern_mount+0x50/0xa8)
> [  239.353867] [<c008b054>] (vfs_kern_mount+0x50/0xa8) from [<c008b0f0>] (do_kern_mount+0x34/0xd0)
> [  239.362799] [<c008b0f0>] (do_kern_mount+0x34/0xd0) from [<c009f7b4>] (do_mount+0x644/0x6b4)
> [  239.371377] [<c009f7b4>] (do_mount+0x644/0x6b4) from [<c009f8a8>] (sys_mount+0x84/0xcc)
> [  239.379538] [<c009f8a8>] (sys_mount+0x84/0xcc) from [<c0025e80>] (ret_fast_syscall+0x0/0x2c)
> 
> Append the UBI volume and device ID to avoid that.
> 
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Artem Bityutskiy <dedekind@infradead.org>
> Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>
> Cc: linux-mtd@lists.infradead.org

Thanks, I'll look at this tomorrow and try to sent it to Linus
ASAP.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
