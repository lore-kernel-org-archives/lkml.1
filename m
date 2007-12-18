Return-Path: <linux-kernel-owner+w=401wt.eu-S1752700AbXLRUU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbXLRUU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 15:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbXLRUTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 15:19:50 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736AbXLRUTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 15:19:44 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-nfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, nfsv4@linux-nfs.org
Subject: [PATCH 0/7] Intro: convert lockd to kthread and fix use-after-free (try #3)
Date: Tue, 18 Dec 2007 15:19:35 -0500
Message-Id: <1198009182-27895-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the third patchset to fix the use-after-free problem in lockd,
and to convert lockd to use the kthread API instead of kernel_thread.
The main change from the last patchset is the elimination of the
svc_create_kthread helper function, and having lockd_up call kthread_run
directly. I've also made some changes to the function prototype for
the lockd function to eliminate the need for casting the function
pointer.

Tested against the reproducer I have for the main issue (detailed in
patch #7). As always, comments and suggestions are appreciated.

Signed-off-by: Jeff Layton <jlayton@redhat.com>

