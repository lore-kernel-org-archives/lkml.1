Return-Path: <linux-kernel-owner+w=401wt.eu-S1760450AbXLRQxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760450AbXLRQxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 11:53:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758057AbXLRQxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 11:53:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757008AbXLRQxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 11:53:07 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-nfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, nfsv4@linux-nfs.org
Subject: [PATCH 0/7] Intro: convert lockd to kthread and fix use-after-free (try #2)
Date: Tue, 18 Dec 2007 11:42:32 -0500
Message-Id: <1197996159-20799-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second patchset to fix the use-after-free problem in lockd,
and to convert lockd to use the kthread API instead of kernel_thread.
The main change from the last patchset is that svc_prepare_thread is
now exported and svc_create_kthread no longer calls it. The caller of
svc_create_kthread must now call it (or do the equivalent to set up
the svc_rqst.

Tested against the reproducer I have for the main issue (detailed in
patch #7). As always, comments and suggestions are appreciated.

Signed-off-by: Jeff Layton <jlayton@redhat.com>

