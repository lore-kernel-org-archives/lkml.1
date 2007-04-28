Return-Path: <linux-kernel-owner+w=401wt.eu-S1756282AbXD1Npg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbXD1Npg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 09:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756212AbXD1Nk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 09:40:27 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:45348 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195AbXD1Njq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 09:39:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=mkxFCrCZM9nqiwVE9zBViwTs/xDaQ5TZLQzlMqcjPBpbIhqvU0pJeeoik1fJdPb/P80qOgqz6iFaLVA82g2XaX6PBJo5oeY2C+ryhOt42vEv912EOUm1cg/9woX8T/nV67MOqgj8tmkgdELVvbouB9skeyWxC+a7vQKqgqjENso=
Subject: [PATCHSET] sysfs: sysfs rework, take #2
In-Reply-To: 
X-Mailer: git-send-email
Date: Sat, 28 Apr 2007 22:39:35 +0900
Message-Id: <11777675753460-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, dmitry.torokhov@gmail.com, cornelia.huck@de.ibm.com,
       oneukum@suse.de, rpurdie@rpsys.net, stern@rowland.harvard.edu,
       maneesh@in.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCHSET] sysfs: sysfs rework, take #2

Hello, all.

This is respin of syswork rework patchset in gregkh patch series.
Changes are...

* ida implemented and used to allocate sysfs_dirent inode numbers
  instead of using pointer values which caused problems on certain
  configurations including 32bit userland on 64bit kernel.

* reordered patches a bit such that minor updates added later are now
  in the front of the patchset.

* 09-sysfs-flatten-and-fix-sysfs_rename_dir-error_handling added.

* 12-sysfs-add-sysfs_dirent-s_name now updates syfs_rename_dir() such
  that the renaming is reflected in sd->s_name.  This fixes netif
  rename problem.

* lockdep annotation updated to handle sysfs nodes deleting other
  nodes properlyand merged into 17-sysfs-implement-sysfs_dirent-
  active-references-and-immediate-disconnect

* patches which fix fallouts of kill-attr-owner conversion were added
  19-sysfs-kill-unnecessary-attribute-owner.  Source tree is scanned
  with grep and brace matching perl script and more fallouts have been
  converted.

* reimplement-sysfs_drop_dentry() patches are completely redone.  This
  was necessary because there was no way to look up the dentry
  matching a sysfs_dirent for shadow directories, not without getting
  the hands all dirty with dcache internals.  Please read descriptions
  of patch #20 and 21 for more info.  This fixes two races conditions
  around sysfs dentry/inode reclamation which triggers BUG_ON().

All the known regrssions are fixed.  I think I've got all the
attr->owner but haven't verified with cross compiling yet, just
allyesconfig on x86-64 and i386.  I'll try to setup some cross compile
environments tomorrow and follow up if I can find more fallouts.

The patches are against Linus's master branch of the day -
b9099ff63c75216d6ca10bce5a1abcd9293c27e6

Thanks.

--
tejun


