Return-Path: <linux-kernel-owner+w=401wt.eu-S1758187AbZEaOtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187AbZEaOtj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 10:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753051AbZEaOtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 10:49:32 -0400
Received: from mail-px0-f123.google.com ([209.85.216.123]:48224 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbZEaOtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 10:49:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vfX+4idGtOcxur6/rLsG1iXMTfBIS9/arigtvLmsPfKl9ceCtHhhZfWpFR8AQmBC0M
         YEacidwRfLiDKy5YwTB7wFB1ozWncr2uTfjqoBZyfXOkWUK4c2J5iN8W7+YU4G4AOnBy
         mirtGTVDTnhtX1sDNkepXYwXaD9cyU7sblhqc=
From: tom.leiming@gmail.com
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl
Subject: [PATCH 0/8] kernel:lockdep:replace DFS with BFS
Date: Sun, 31 May 2009 22:49:17 +0800
Message-Id: <1243781365-26814-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
In-Reply-To: <yes>
References: <yes>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,
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

     3, The shortest path can be obtained by BFS if the target is
     found, but can't be got by DFS. By the shortest path, we can
     shorten the lock dependency chain and help to troubleshoot lock
     problem easier than before.


