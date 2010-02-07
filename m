Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab0BGDcM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 22:32:12 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:56301 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab0BGDcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 22:32:10 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Failure to fallback to nfsd-v3 (?)
Date: Sun, 07 Feb 2010 12:32:04 +0900
Message-ID: <87pr4h67rf.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've recently noticed I couldn't mount nfs on 2.6.33-rc6. The environment is

	server (nfsd-v3, 2.6.33-rc6) <-> client (2.6.32.7, nfs-utils 1.2.1)

And mount command is

	# mount server:/path /mntpoint

(i.e. without any options. If I specified "vers=3" option, it works).

With some debugging, it seems to change of the error code on nfsd - the
log of failure is the following.

nfsd_dispatch: vers 4 proc 0
nfsd_dispatch: vers 4 proc 1
nfsv4 compound op #1/3: 24 (OP_PUTROOTFH)
nfsv4 compound op ffff88012d9e10c0 opcnt 3 #1: 24: status 30000
nfsv4 compound returned 30000
nfsd: Dropping request; may be revisited later
found domain *.xxx.xx
found fsidtype 1
found fsid length 4
Path seems to be <>
nfsd_dispatch: vers 4 proc 1
nfsv4 compound op #1/3: 24 (OP_PUTROOTFH)
nfsv4 compound op ffff88012dab6228 opcnt 3 #1: 24: status 10006
nfsv4 compound returned 10006

On the older kernel (2.6.32.7), it seems to fallback to nfsv3,

nfsd_dispatch: vers 4 proc 0
nfsd_dispatch: vers 4 proc 1
nfsv4 compound op #1/3: 24 (OP_PUTROOTFH)
nfsv4 compound op d9c04850 opcnt 3 #1: 24: status 2
nfsv4 compound returned 2
nfsd_dispatch: vers 3 proc 0
[...]


And the following commit seems to change the behavior.

[nfsd4: fix error return when pseudoroot missing]
f39bde24b275ddc45df1ed835725b609e178c7a0

Well, anyway, is this a expected behavior change, or something bug?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
