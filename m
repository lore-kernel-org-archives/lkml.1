Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbZEPFS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbZEPFS6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 01:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbZEPFSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 01:18:47 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:45481 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbZEPFSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 01:18:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=jdE142sfrhTvWJE4vgWXHhrYXDJ90CQGmj1VVDduUf81Vi9+u9WeKxch/TtVaZ3xjh
         YorjfwQhGhWV8ZCGNxfNXtlSpW+SLDIDZQIHnpuTfKOJ2PsdCDLvka0iJyBDie/ejqB4
         kYBQgO3GPuvhwuCU5UN/jgqcCtGbDVbgPjSMU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 0/2] tracing/stat: cleanups, latency
Date: Sat, 16 May 2009 07:18:42 +0200
Message-Id: <1242451124-5466-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are two patches for the stat tracing.
I would also like to do more work on the stat tracing to make
it able to manage by itself the entries for the tracers, ie:
the memory allocation, accesses, locking, releases, etc...

And the workqueue tracer would be a good base to work on it.
Then Ingo, if you pull this, could you please also merge tracing/core
into tracing/workqueue, so that I can continue the work
with these patches and prepare pull requests against tracing/workqueue.
It should be mergeable without conflicts, I just applied the raw patches
from this pull-request into tracing/workqueue and it was fine.

Thanks,
Frederic.


The following changes since commit 5872144f64b34a5942f6b4acedc90b02de72c58b:
  Li Zefan (1):
        tracing/filters: fix off-by-one bug

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/core

Frederic Weisbecker (2):
      tracing/stat: replace trace_stat_session by stat_session
      tracing/stat: replace linked list by an rbtree for sorting

 kernel/trace/trace_stat.c |  166 ++++++++++++++++++++++++++++++--------------
 1 files changed, 113 insertions(+), 53 deletions(-)
