Return-Path: <linux-kernel-owner+w=401wt.eu-S1759802AbZE2US4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759802AbZE2US4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 16:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbZE2USq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 16:18:46 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45062 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbZE2USo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 16:18:44 -0400
To: Greg KH <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
References: <m1bppofm9k.fsf@fess.ebiederm.org>
	<1242865694-2100-1-git-send-email-ebiederm@xmission.com>
	<20090528001418.GA2499@kroah.com>
	<ac3eb2510905271730j59af10d6h58d955625324f206@mail.gmail.com>
	<20090528003721.GB2720@suse.de> <m1zlcwltri.fsf_-_@fess.ebiederm.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 29 May 2009 13:18:35 -0700
In-Reply-To: <m1zlcwltri.fsf_-_@fess.ebiederm.org> (Eric W. Biederman's message of "Thu\, 28 May 2009 15\:58\:25 -0700")
Message-ID: <m1r5y73bok.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: gregkh@suse.de, ebiederm@aristanetworks.com, linux-fsdevel@vger.kernel.org, cornelia.huck@de.ibm.com, tj@kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, greg@kroah.com, kay.sievers@vrfy.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1115]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 0/26] sysfs cleanups v3.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here is the third respin of my sysfs patches.

Tejun had a good point I was doing to much when I touched __sysfs_read_dir.
So that work has been split into 3 patches.

This made a good excuse for me to review the if (!dir_sd) check and be
certain it was not needed.  I have not found any actual problems so
the resulting code is the same as the last patchset.

Now the change to delete each dirent in sysfs_read_dir is it's own
separate patch so Tejun can happily beat me up on just that one idea.
I honestly can't see how holding sysfs_mutex over the entire directory
deletion helps anything.

The net change is less buggy than the current sysfs and a fair bit simpler.

 git-diff-tree --stat v2.6.30-rc5..HEAD
 drivers/base/core.c   |   21 +--
 fs/namei.c            |   22 --
 fs/sysfs/dir.c        |  596 ++++++++++++++++---------------------------------
 fs/sysfs/file.c       |   47 +---
 fs/sysfs/inode.c      |  154 ++++++++------
 fs/sysfs/mount.c      |   20 +-
 fs/sysfs/symlink.c    |   93 +++++----
 fs/sysfs/sysfs.h      |   28 +--
 include/linux/namei.h |    1 -
 include/linux/sysfs.h |    9 +
 10 files changed, 383 insertions(+), 608 deletions(-)


Eric
