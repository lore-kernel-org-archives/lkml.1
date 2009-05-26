Return-Path: <linux-kernel-owner+w=401wt.eu-S1755719AbZEZNzC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbZEZNzC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 09:55:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755701AbZEZNyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 09:54:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:36079 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401AbZEZNyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 09:54:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=l3qye0WolrgZbvpofpP8lm2FbN0zJCkb8qQRJg5rpXhF/tBM8nhDehbIPhpR0dEaUo
         WZLGum9K6zj4p/ouNN5mDswxpyj98T9iZalB5UNn72suFv3I2nqvCO2K3qM+d4Dxh1iv
         BXojW9IAIbRy2mILmk2ofWH6Qxaz11X65/B+I=
Date: Tue, 26 May 2009 21:54:42 +0800
From: Ming Lei <tom.leiming@gmail.com>
To: mingo@elte.hu, a.p.zijlstra@chello.nl
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [RFC] kernel/lockdep: use BFS(breadth-first search) algorithm to
 search target
Message-ID: <20090526215442.2dbd888b@linux-lm>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.4; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,All

Currently lockdep uses recursion DFS(depth-first search) algorithm to
search target in checking lock circle(check_noncircular()),irq-safe
-> irq-unsafe(check_irq_usage()) and irq inversion when adding a new
lock dependency. I plan to replace the current DFS with BFS, based on
the following consideration:

	1,no loss of efficiency, no matter DFS or BFS, the running time
	are O(V+E) (V is vertex count, and E is edge count of one
	graph);

	2,BFS may be easily implemented by circular queue and consumes
	much less kernel stack space than DFS for DFS is implemented by
	recursion, we know kernel stack is very limited, eg. 4KB.

	3, The shortest path can be obtained by BFS if the target is
	found, but can't be got by DFS. By the shortest path, we can
	shorten the lock dependency chain and help to troubleshoot lock
	problem easier than before.

Any suggestions, objections or viewpoint?

Thanks,
-- 
Lei Ming
