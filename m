Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838AbYFKODm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbYFKODm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 10:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbYFKODV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 10:03:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbYFKODU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 10:03:20 -0400
From: Jeff Layton <jlayton@redhat.com>
To: trond.myklebust@fys.uio.no, bfields@fieldses.org
Cc: linux-nfs@vger.kernel.org, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] fix potential races in lockd and nfs4-callback startup/shutdown
Date: Wed, 11 Jun 2008 10:03:09 -0400
Message-Id: <1213192992-7635-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.5.3.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Trond Myklebust pointed out, the current kthread-based lockd and
nfsv4 callback threads have a race condition if they are started and
brought down very rapidly. If this occurs, there is a chance that the
main thread function will never be run, and the cleanup done when the
function exits will not occur. This patchset fixes this by moving the
cleanup into the respective *_down functions.

While Bruce has just taken in a patchset from me to change nfsd to
kthreads, this race doesn't seem to exist there. We aren't using
kthread_stop() to take down nfsd, only signals, so I don't think the
kthread can be stopped before nfsd() actually runs.

The set also includes a patch to remove the BKL from nfs_callback_up
and nfs_callback_down.

Signed-off-by: Jeff Layton <jlayton@redhat.com>

