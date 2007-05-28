Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbXE1QYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbXE1QYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 12:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbXE1QYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 12:24:13 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:13708 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbXE1QYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 12:24:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=FkJtw2SGwKx/Ez8m1UpF0GyJmj0UE4n4jwnphON4xaZ9qcBwbhzR2wPABpUyViZJAPF6PZ5tYuVhpyqb2Ua3WwIC6VAVidsWK+W1XJfaSL/HOmdrRl2o164XrWgc2SPhwIGXB++jBk3kgb8vBF7RfAlOa5alMpQqVam6duVLYlc=
Subject: [PATCHSET 2.6.22-rc2-mm1] sysfs: reduce memory footprint of sysfs_dirent
In-Reply-To: 
X-Mailer: git-send-email
Date: Tue, 29 May 2007 01:24:06 +0900
Message-Id: <118036944617-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, dmitry.torokhov@gmail.com, cornelia.huck@de.ibm.com,
       oneukum@suse.de, rpurdie@rpsys.net, stern@rowland.harvard.edu,
       maneesh@in.ibm.com, linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, all.

This patchset reduces the size of sysfs_dirent to 88 byte from 136 on
64bit and to 52 from 76 on 32bit.  Combined with forthcoming
reclaimable sysfs directories, this will make sysfs much more scalable
on very large machines and very small machines.

This patchset contains the following three patches.

#01: move-s_active-functions-to-fs-sysfs-dir-c, prep for #02
#02: slim-down-sysfs_dirent-s_active
#03: use-signly-linked-list-for-sysfs_dirent-tree

I'm pretty sure #02 is a good idea but #03 is debatable.  The code
doesn't look much uglier after the conversion tho.  Inputs welcome.

This patchset is on top of

  2.6.22-rc2-mm1
+ [1] sysfs-assorted-fixes patchset

 fs/sysfs/dir.c   |  272 ++++++++++++++++++++++++++++++++++++++++++++-----------
 fs/sysfs/inode.c |   12 +-
 fs/sysfs/mount.c |    3 
 fs/sysfs/sysfs.h |  111 ++--------------------
 4 files changed, 237 insertions(+), 161 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/535372


