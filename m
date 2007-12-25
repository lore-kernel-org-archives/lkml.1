Return-Path: <linux-kernel-owner+w=401wt.eu-S1751862AbXLYVve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbXLYVve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 16:51:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbXLYVv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 16:51:27 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:55594 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbXLYVv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 16:51:26 -0500
Date: Tue, 25 Dec 2007 22:51:25 +0100
From: Andreas Mohr <andi@lisas.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc6-mm1
Message-ID: <20071225215125.GA7427@rhlx01.hs-esslingen.de>
References: <20071222233056.d652743e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071222233056.d652743e.akpm@linux-foundation.org>
X-Priority: none
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

another one most likely related to the recent NFS_V4 define build error
saga:

  CC      fs/nfs/super.o
fs/nfs/super.c: In function 'nfs_sb_deactive':
fs/nfs/super.c:338: error: 'TASK_NORMAL' undeclared (first use in this function)
fs/nfs/super.c:338: error: (Each undeclared identifier is reported only once
fs/nfs/super.c:338: error: for each function it appears in.)
fs/nfs/super.c: In function 'nfs_put_super':
fs/nfs/super.c:349: error: 'TASK_UNINTERRUPTIBLE' undeclared (first use in this function)
fs/nfs/super.c:349: error: implicit declaration of function 'schedule'
make[3]: *** [fs/nfs/super.o] Error 1
make[2]: *** [fs/nfs] Error 2
make[1]: *** [fs] Error 2
make[1]: Leaving directory `/usr/src/linux-2.6.24-rc6-mm1.system-gate-patch'
make: *** [debian/stamp-build-kernel] Error 2


This was hand-patched from earlier kernel versions, however I wouldn't
think there was any problem due to this (a cleanly extracted version
doesn't show any md5sum difference for fs/nfs/super.c).

[plus hotfix x86-fix-system-gate-related-crash.patch]

I'm circa 120% sure there must be a sched.h include missing there, given the
whereabouts of these APIs ;)


CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
CONFIG_NFS_V4=y
# CONFIG_NFS_DIRECTIO is not set
CONFIG_NFSD=y
CONFIG_NFSD_V3=y
# CONFIG_NFSD_V3_ACL is not set
CONFIG_NFSD_V4=y
CONFIG_NFSD_TCP=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=y
CONFIG_NFS_COMMON=y


i386 K6-III@150, gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)

Thanks,

Andreas Mohr
