Return-Path: <linux-kernel-owner+w=401wt.eu-S1756632AbZF1PE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbZF1PE6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 11:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbZF1PEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 11:04:51 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:58849 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbZF1PEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 11:04:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=uYokmg55s9VrnjlCLbkoo3pjZhbZslExjKQkpLJNQUXs2P8UR8rJVcxt0Dz7LgG0Tu
         1My0uZNpwBLS8N4MtcRpuSFy0SuUvbjoMazFB6FRO28z09nHOxbMdPC47cOP7UtcpqRC
         o8BR8WfTEJYtj3N9Y/vhx8rL3XUI2E2sK4sbg=
From: tom.leiming@gmail.com
To: a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu
Subject: [RESEND PATCH 0/11] kernel:lockdep:replace DFS with BFS
Date: Sun, 28 Jun 2009 23:04:35 +0800
Message-Id: <1246201486-7308-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,Peter

Currently lockdep uses recursion DFS(depth-first search) algorithm to
search target in checking lock circle(check_noncircular()),irq-safe
-> irq-unsafe(check_irq_usage()) and irq inversion when adding a new
lock dependency. This patches replace the current DFS with BFS, based on
the following consideration:

    1,no loss of efficiency, no matter DFS or BFS, the running time
    are O(V+E) (V is vertex count, and E is edge count of one
    graph);

    2,BFS may be easily implemented by circular queue and consumes
    much less kernel stack space than DFS for DFS is implemented by
    recursion.

    3,The shortest path can be obtained by BFS if the target is
    found, but can't be got by DFS. By the shortest path, we can
    shorten the lock dependency chain and help to troubleshoot lock
    problem easier than before.



