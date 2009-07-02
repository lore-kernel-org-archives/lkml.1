Return-Path: <linux-kernel-owner+w=401wt.eu-S1754991AbZGBPfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbZGBPfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 11:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbZGBPfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 11:35:30 -0400
Received: from smtp.nokia.com ([192.100.122.233]:24649 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbZGBPf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 11:35:28 -0400
Subject: Re: [PATCH] ubifs: allow more than one volume to be mounted
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Daniel Mack <daniel@caiaq.de>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, linux-kernel@vger.kernel.org,
       Adrian Hunter <adrian.hunter@nokia.com>, linux-mtd@lists.infradead.org
In-Reply-To: <20090702152730.GJ18340@buzzloop.caiaq.de>
References: <1246547747-13366-1-git-send-email-daniel@caiaq.de>
	 <4A4CCF99.30104@gmail.com>  <20090702152730.GJ18340@buzzloop.caiaq.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Jul 2009 18:34:50 +0300
Message-Id: <1246548890.20721.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 02 Jul 2009 15:34:51.0765 (UTC) FILETIME=[A421DA50:01C9FB2A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-02 at 17:27 +0200, Daniel Mack wrote:
> On Thu, Jul 02, 2009 at 06:17:45PM +0300, Artem Bityutskiy wrote:
> > Daniel Mack wrote:
> >> UBIFS uses a bdi device per volume, but does not care to hand out unique
> >> names to each of them. This causes an error when trying to mount more
> >> than one volumes.
> >>
> >> [  239.277407] kobject_add_internal failed for ubifs with -EEXIST, don't try to register things with the same name in the same directory.
> >> [  239.289618] [<c002a45c>] (unwind_backtrace+0x0/0xdc) from [<c0160628>] (kobject_add_internal+0x188/0x1b8)
> >> [  239.299445] [<c0160628>] (kobject_add_internal+0x188/0x1b8) from [<c01607d8>] (kobject_add+0x48/0x5c)
> >> [  239.308896] [<c01607d8>] (kobject_add+0x48/0x5c) from [<c019d96c>] (device_add+0xac/0x510)
> >> [  239.317392] [<c019d96c>] (device_add+0xac/0x510) from [<c019de58>] (device_create_vargs+0x70/0xa4)
> >> [  239.326589] [<c019de58>] (device_create_vargs+0x70/0xa4) from [<c0073138>] (bdi_register+0x44/0x64)
> >> [  239.335854] [<c0073138>] (bdi_register+0x44/0x64) from [<c01249f0>] (ubifs_get_sb+0x3c8/0x10cc)
> >> [  239.344769] [<c01249f0>] (ubifs_get_sb+0x3c8/0x10cc) from [<c008b054>] (vfs_kern_mount+0x50/0xa8)
> >> [  239.353867] [<c008b054>] (vfs_kern_mount+0x50/0xa8) from [<c008b0f0>] (do_kern_mount+0x34/0xd0)
> >> [  239.362799] [<c008b0f0>] (do_kern_mount+0x34/0xd0) from [<c009f7b4>] (do_mount+0x644/0x6b4)
> >> [  239.371377] [<c009f7b4>] (do_mount+0x644/0x6b4) from [<c009f8a8>] (sys_mount+0x84/0xcc)
> >> [  239.379538] [<c009f8a8>] (sys_mount+0x84/0xcc) from [<c0025e80>] (ret_fast_syscall+0x0/0x2c)
> >>
> >> Append the UBI volume and device ID to avoid that.
> >>
> >> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> >> Cc: Artem Bityutskiy <dedekind@infradead.org>
> >> Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>
> >> Cc: linux-mtd@lists.infradead.org
> >
> > Thanks, I'll look at this tomorrow and try to sent it to Linus
> > ASAP.
> 
> Btw - Adrian Hunter's email in MAINTAINERS seems to be outdated:
> 
> <ext-adrian.hunter@nokia.com>: host mx1.nokia.com[192.100.122.228] said:
> 550 5.1.1 <ext-adrian.hunter@nokia.com>... User unknown (in reply to RCPT TO command)

Ok, I'll fix that too, thanks. Nowadays it is: adrian.hunter@nokia.com

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

