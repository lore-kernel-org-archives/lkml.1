Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbYAEMDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbYAEMDg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 07:03:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbYAEMDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 07:03:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715AbYAEMC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 07:02:58 -0500
From: Jeff Layton <jlayton@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] Intro: convert lockd to kthread and fix use-after-free (try #5)
Date: Sat,  5 Jan 2008 07:02:16 -0500
Message-Id: <1199534542-3384-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the fifth patchset to fix the use-after-free problem in lockd
which we originally discussed back in October. The main problem is
detailed in the last patch of the series. Along the way, Christoph
Hellwig mentioned that it would be advantageous to convert lockd to use
the kthread API. This patch set first makes that change and then
patches it to actually fix the use after free problem. It also fixes
a couple of minor bugs in the current lockd implementation.

The main changes from the original patchset are:

+ dropped the new thread creation helper and just have lockd_up call
  kthread_run directly. 
+ dropped the first patch that changed svc_pool_map_set_cpumask, since
  it's no longer needed. 
+ added a warning message when lockd_down is called for the final time,
  but lockd is still up
+ done some style cleanups recommended by checkpatch.pl.

I've done some basic smoke testing and everything seems to work as
expected. I've also tested this against the reproducer that I have for
the use-after-free problem and this does fix it. I've tried to make
this cleanly bisectable, but have only really tested the final result.

Many thanks to Trond Myklebust, Chuck Lever and Christoph Hellwig for
their guidance on this.

Signed-off-by: Jeff Layton <jlayton@redhat.com>

