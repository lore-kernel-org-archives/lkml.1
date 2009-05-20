Return-Path: <linux-kernel-owner+w=401wt.eu-S1752759AbZETEKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbZETEKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 00:10:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750746AbZETEJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 00:09:57 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:41393 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbZETEJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 00:09:56 -0400
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
CC: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 0/20] Sysfs cleanups
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 19 May 2009 21:09:43 -0700
Message-ID: <m1bppofm9k.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: gregkh@suse.de, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, cornelia.huck@de.ibm.com, tj@kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patch series cleans up sysfs to the point where itq is
generally a good citizen of the vfs layer.  The big theme is lazy
synchronization from the sysfs data structures to the vfs data
structures using the same techniques as most other distributed
filesystems.

This allows the complete removal of i_mutex from the sysfs code,
the death of lookup_one_noperm, and probably a few other weird
cases that slip my tongue.

Included in this is the latest version of my work that merges
sysfs_move_dir and sysfs_rename_dir to simplify maitenance of.

I have been running these patches for several months so there should
be no really nasty surprises in here.

 drivers/base/core.c   |   18 +-
 fs/namei.c            |   22 --
 fs/sysfs/dir.c        |  565 ++++++++++++++-----------------------------------
 fs/sysfs/file.c       |   47 +----
 fs/sysfs/inode.c      |  154 ++++++++------
 fs/sysfs/mount.c      |   20 +-
 fs/sysfs/symlink.c    |   71 +++----
 fs/sysfs/sysfs.h      |   25 +--
 include/linux/namei.h |    1 -
 include/linux/sysfs.h |    9 +
 10 files changed, 325 insertions(+), 607 deletions(-)

Eric

