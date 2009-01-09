Return-Path: <linux-kernel-owner+w=401wt.eu-S1757263AbZAIU4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263AbZAIU4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 15:56:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755378AbZAIU4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 15:56:11 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52117 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757088AbZAIU4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 15:56:09 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] dlm patches for 2.6.29 (part 2)
Date: Fri,  9 Jan 2009 15:41:39 -0600
Message-Id: <1231537301-31459-1-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are two more dlm patches for merging in this cycle.

commit c7be761a8163d2f1ac0b606c21e4316b7abc5af7
Author: David Teigland <teigland@redhat.com>
Date:   Wed Jan 7 16:50:41 2009 -0600

    dlm: change rsbtbl rwlock to spinlock
    
    The rwlock is almost always used in write mode, so there's no reason
    to not use a spinlock instead.
    
    Signed-off-by: David Teigland <teigland@redhat.com>

 fs/dlm/debug_fs.c     |   24 ++++++++++++------------
 fs/dlm/dlm_internal.h |    2 +-
 fs/dlm/lock.c         |   26 +++++++++++++-------------
 fs/dlm/lockspace.c    |    2 +-
 fs/dlm/recover.c      |   10 +++++-----
 5 files changed, 32 insertions(+), 32 deletions(-)

commit 892c4467e335e9050c95e0d8409c136c4dadaca2
Author: David Teigland <teigland@redhat.com>
Date:   Wed Jan 7 16:48:52 2009 -0600

    dlm: fix seq_file usage in debugfs lock dump
    
    The old code would leak iterators and leave reference counts on
    rsbs because it was ignoring the "stop" seq callback.  The code
    followed an example that used the seq operations differently.
    This new code is based on actually understanding how the seq
    operations work.  It also improves things by saving the hash bucket
    in the position to avoid cycling through completed buckets in start.
    
    Siged-off-by: Davd Teigland <teigland@redhat.com>

 fs/dlm/debug_fs.c |  696 ++++++++++++++++++++++++++---------------------------
 1 files changed, 337 insertions(+), 359 deletions(-)

