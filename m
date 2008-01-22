Return-Path: <linux-kernel-owner+w=401wt.eu-S1760459AbYAVAcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760459AbYAVAcu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 19:32:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756564AbYAVAcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 19:32:41 -0500
Received: from smtp04.mtu.ru ([62.5.255.51]:64068 "EHLO smtp04.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755284AbYAVAcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 19:32:41 -0500
From: Anton Salikhmetov <salikhmetov@gmail.com>
To: linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, protasnb@gmail.com, miklos@szeredi.hu,
       r.e.wolff@bitwizard.nl, hidave.darkstar@gmail.com, hch@infradead.org
Subject: [PATCH -v7 0/2] Fixing the issue with memory-mapped file times
Date: Tue, 22 Jan 2008 03:32:34 +0300
Message-Id: <12009619562023-git-send-email-salikhmetov@gmail.com>
X-Mailer: git-send-email 1.4.4.4
X-DCC-STREAM-Metrics: smtp04.mtu.ru 10001; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the seventh version of my solution for the bug #2645:

http://bugzilla.kernel.org/show_bug.cgi?id=2645

Since the previous version, the following has changed: based on
Linus' comment, SMP-safe PTE update implemented.

Discussions, which followed my past submissions, showed that it was
tempting to approach this problem using very different assumptions.
However, many such designs have proved to be incomplete or inefficient.

Taking into account the obvious complexity of this problem, I prepared a
design document, the purpose of which is twofold. First, it summarizes
previous attempts to resolve the ctime/mtime issue. Second, it attempts
to prove that what the patches do is necessary and sufficient for mtime
and ctime update provided that we start from a certain sane set of
requirements. The design document is available via the following link:

http://bugzilla.kernel.org/show_bug.cgi?id=2645#c40

For the seventh version, comprehensive performance testing was performed.
The results of performance tests, including numbers, are available here:

http://bugzilla.kernel.org/show_bug.cgi?id=2645#c43
