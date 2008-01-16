Return-Path: <linux-kernel-owner+w=401wt.eu-S1755759AbYAPMhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbYAPMhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 07:37:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbYAPMfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 07:35:19 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34443 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbYAPMfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 07:35:07 -0500
Message-Id: <20080116123147.466284860@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 16 Jan 2008 13:31:47 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, hch@infradead.org, serue@us.ibm.com,
       viro@ftp.linux.org.uk, kzak@redhat.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, util-linux-ng@vger.kernel.org
Subject: [patch 00/10] mount ownership and unprivileged mount syscall (v7)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to everyone for the comments on the previous submission.

Christoph, could you please look through the patches if they are
acceptable from the VFS point of view?

Thanks,
Miklos

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
