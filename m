Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbZLBUAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbZLBUAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 15:00:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754572AbZLBUAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 15:00:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837AbZLBUAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 15:00:09 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jamie@shareable.org, pavel@ucw.cz, miklos@szeredi.hu,
       viro@ZenIV.linux.org.uk, duaneg@dghda.com, ebiederm@xmission.com
Subject: [PATCH 0/2] vfs: plug some holes involving LAST_BIND symlinks and file bind mounts (try #6)
Date: Wed,  2 Dec 2009 14:59:41 -0500
Message-Id: <1259783983-26884-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is another attempt to add missing dentry revalidations to
certain places in the lookup codepath. The main difference from the last
patchset is:

* I've dropped the patch that added permissions checks when chasing
  LAST_BIND symlinks. There's a lot disagreement about whether the
  current behavior is even a bug. I'd prefer to see more concensus on
  that point before we do anything here.

* I've rejiggered the error handling in this codepath to ensure that the
  bind mounts could still be unmounted. Testing showed that returning an
  error in do_lookup when a bind-mounted dentry went stale made it
  un-unmountable.

Comments and suggestions appreciated...

Jeff Layton (2):
  vfs: force reval of target when following LAST_BIND symlinks
  vfs: force reval on dentry of bind mounted files on FS_REVAL_DOT
    filesystems

 fs/namei.c |   56 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 55 insertions(+), 1 deletions(-)

