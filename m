Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795AbZHQHHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbZHQHHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 03:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbZHQHHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 03:07:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35073 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbZHQHHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 03:07:51 -0400
Date: Mon, 17 Aug 2009 03:07:36 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: esandeen@redhat.com, eteo@redhat.com, eparis@redhat.com,
       Amerigo Wang <amwang@redhat.com>, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, sds@tycho.nsa.gov,
       hirofumi@mail.parknet.co.jp, viro@zeniv.linux.org.uk
Message-Id: <20090817071001.5913.94767.sendpatchset@localhost.localdomain>
Subject: [V4 Patch 0/2] fix file truncations when both suid and write permissions set
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When suid is set and the non-owner user has write permission,
any writing into this file should be allowed and suid should be
removed after that.

However, current kernel only allows writing without truncations,
when we do truncations on that file, we get EPERM. This is a bug.

Steps to reproduce this bug:

% ls -l rootdir/file1
-rwsrwsrwx 1 root root 3 Jun 25 15:42 rootdir/file1
% echo h > rootdir/file1
zsh: operation not permitted: rootdir/file1
% ls -l rootdir/file1
-rwsrwsrwx 1 root root 3 Jun 25 15:42 rootdir/file1
% echo h >> rootdir/file1
% ls -l rootdir/file1
-rwxrwxrwx 1 root root 5 Jun 25 16:34 rootdir/file1

This patch fixes it.

Signed-off-by: WANG Cong <amwang@redhat.com>

Andrew, these two patches can replace the -mm patch
"vfs-allow-file-truncations-when-both-suid-and-write-permissions-set.patch".

Thanks!


