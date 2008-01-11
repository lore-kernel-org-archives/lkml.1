Return-Path: <linux-kernel-owner+w=401wt.eu-S1760261AbYAKLEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760261AbYAKLEt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 06:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757390AbYAKLEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 06:04:31 -0500
Received: from ns.suse.de ([195.135.220.2]:43849 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755637AbYAKLEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 06:04:30 -0500
Subject: Query on lock protection in random number driver
From: Nikanth Karthikesan <knikanth@suse.de>
To: linux-kernel@vger.kernel.org, mpm@selenic.com
Content-Type: text/plain
Date: Fri, 11 Jan 2008 16:38:11 +0530
Message-Id: <1200049691.3844.44.camel@nikanth-laptop.blr.novell.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A query on locks used to protect entropy_store

struct entropy_store {
	/* mostly-read data: */
	struct poolinfo *poolinfo;
	__u32 *pool;
	const char *name;
	int limit;
	struct entropy_store *pull;

	/* read-write data: */
	spinlock_t lock ____cacheline_aligned_in_smp;
	unsigned add_ptr;
	int entropy_count;
	int input_rotate;
};

Is this lock meant to protect all the data within the structure?
The lock is being taken whenever entropy_count is modified, but it is
not so when it is read, see random_poll(), random_read(). Either it
should be lock protected or made as atomic_t, right?

Also the globals random_read_wakeup_thresh and
random_write_wakeup_thresh are not at all protected by any locks! Why
locks are not needed for these?

Sorry, if that was a stupid question.

Thanks
Nikanth Karthikesan


