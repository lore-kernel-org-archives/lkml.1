Return-Path: <linux-kernel-owner+w=401wt.eu-S1757364AbYFXGD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364AbYFXGD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 02:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbYFXGDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 02:03:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341AbYFXGDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 02:03:18 -0400
Date: Tue, 24 Jun 2008 02:03:14 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
cc: davem@davemloft.net, Alasdair G Kergon <agk@redhat.com>
Subject: [10/10 PATCH] inline dispatch_job
In-Reply-To: <Pine.LNX.4.64.0806240154140.27784@engineering.redhat.com>
Message-ID: <Pine.LNX.4.64.0806240201530.27784@engineering.redhat.com>
References: <Pine.LNX.4.64.0806240136200.27784@engineering.redhat.com>
 <Pine.LNX.4.64.0806240154140.27784@engineering.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inline dispatch_job. It is called at two places, but it is quite small.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-2.6.26-rc7-devel/drivers/md/dm-kcopyd.c
===================================================================
--- linux-2.6.26-rc7-devel.orig/drivers/md/dm-kcopyd.c	2008-06-24 07:37:54.000000000 +0200
+++ linux-2.6.26-rc7-devel/drivers/md/dm-kcopyd.c	2008-06-24 07:37:59.000000000 +0200
@@ -433,7 +433,7 @@
   * to do the copy, otherwise the io has to be split up into many
   * jobs.
   */
-static void dispatch_job(struct kcopyd_job *job)
+static __always_inline void dispatch_job(struct kcopyd_job *job)
  {
  	struct dm_kcopyd_client *kc = job->kc;
  	atomic_inc(&kc->nr_jobs);
