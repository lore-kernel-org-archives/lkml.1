Return-Path: <linux-kernel-owner+w=401wt.eu-S1762326AbYBEVjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762326AbYBEVjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 16:39:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761596AbYBEVhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 16:37:52 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:38770 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761615AbYBEVhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 16:37:47 -0500
Message-Id: <20080205213616.343721693@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 05 Feb 2008 22:36:16 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, hch@infradead.org, serue@us.ibm.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 00/10] mount ownership and unprivileged mount syscall (v8)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just documentation updates, compared to the previous submission.
Thanks to Serge for the relentless reviews :)

Please consider for -mm, and then for 2.6.26.

Thanks,
Miklos

v7 -> v8

 - extend documentation of allow_usermount sysctl tunable
 - describe new unprivileged mounting in fuse.txt

v6 -> v7:

 - add '/proc/sys/fs/types/<type>/usermount_safe' tunable (new patch)
 - do not make FUSE safe by default, describe possible problems
   associated with unprivileged FUSE mounts in patch header
 - return EMFILE instead of EPERM, if maximum user mount count is exceeded
 - rename option 'nomnt' -> 'nosubmnt'
 - clean up error propagation in dup_mnt_ns
 - update util-linux-ng patch

v5 -> v6:

 - update to latest -mm
 - preliminary util-linux-ng support (will post right after this series)

v4 -> v5:

 - fold back Andrew's changes
 - fold back my update patch:
    o use fsuid instead of ruid
    o allow forced unpriv. unmounts for "safe" filesystems
    o allow mounting over special files, but not over symlinks
    o set nosuid and nodev based on lack of specific capability
 - patch header updates
 - new patch: on propagation inherit owner from parent
 - new patch: add "no submounts" mount flag

v3 -> v4:

 - simplify interface as much as possible, now only a single option
   ("user=UID") is used to control everything
 - no longer allow/deny mounting based on file/directory permissions,
   that approach does not always make sense

v1 -> v3:

 - add mount flags to set/clear mnt_flags individually
 - add "usermnt" mount flag.  If it is set, then allow unprivileged
   submounts under this mount
 - make max number of user mounts default to 1024, since now the
   usermnt flag will prevent user mounts by default

--
