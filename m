Return-Path: <linux-kernel-owner+w=401wt.eu-S1754966AbYASUdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966AbYASUdW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 15:33:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbYASUdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 15:33:12 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50639 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbYASUdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 15:33:10 -0500
To: szaka@ntfs-3g.org
CC: miklos@szeredi.hu, util-linux-ng@vger.kernel.org,
       akpm@linux-foundation.org, hch@infradead.org, serue@us.ibm.com,
       viro@ftp.linux.org.uk, kzak@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
In-reply-to: <Pine.LNX.4.61.0801191745520.4482@dhcppc1> (message from Szabolcs
	Szakacsits on Sat, 19 Jan 2008 18:05:15 +0200 (MET DST))
Subject: Re: [patch] util-linux-ng: unprivileged mounts support
References: <E1JF7Xh-0003q3-Qv@pomaz-ex.szeredi.hu> <Pine.LNX.4.61.0801191745520.4482@dhcppc1>
Message-Id: <E1JGKMY-00033X-FF@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 19 Jan 2008 21:32:22 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This is an experimental patch for supporing unprivileged mounts and
> > umounts.  
> 
> User unmount unfortunately still doesn't work if the kernel doesn't have 
> the unprivileged mount support but as we discussed this in last July that 
> shouldn't be needed for this case.
> 
>   % mount -t ntfs-3g /dev/hda10 /tmp/test
>   % cat /proc/mounts | grep /tmp/test                                                                         
>   /dev/hda10 /tmp/test fuseblk rw,nosuid,nodev,user_id=501,group_id=501,allow_other 0 0
>   % mount | grep /tmp/test
>   /dev/hda10 on /tmp/test type fuseblk (rw,nosuid,nodev,allow_other,blksize=1024,user=szaka)
>   % umount /tmp/test
>   umount: /dev/hda10: not mounted
>   umount: /tmp/test: must be superuser to umount
>   umount: /dev/hda10: not mounted
>   umount: /tmp/test: must be superuser to umount

But 'fusermount -u /tmp/test' does work, doesn't it?

Yes, this should probably be fixed in umount(8), but it's an (almost)
completely separate issue.

Miklos
