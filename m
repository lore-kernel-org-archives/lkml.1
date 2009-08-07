Return-Path: <linux-kernel-owner+w=401wt.eu-S1754640AbZHGRg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbZHGRg5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 13:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbZHGRg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 13:36:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:65463 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538AbZHGRgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 13:36:55 -0400
Date: Fri, 7 Aug 2009 13:36:54 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Eric Dumazet <eric.dumazet@gmail.com>,
       linux kernel <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: [GIT PULL] ring-buffer: Fix memleak in ring_buffer_free()
In-Reply-To: <4A7C06B9.2090302@gmail.com>
Message-ID: <alpine.DEB.2.00.0908071335380.1251@gandalf.stny.rr.com>
References: <4A7C06B9.2090302@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent


Eric Dumazet (1):
      ring-buffer: Fix memleak in ring_buffer_free()

----
 kernel/trace/ring_buffer.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
---------------------------
commit bd3f02212d6a457267e0c9c02c426151c436d9d4
Author: Eric Dumazet <eric.dumazet@gmail.com>
Date:   Fri Aug 7 12:49:29 2009 +0200

    ring-buffer: Fix memleak in ring_buffer_free()
    
    I noticed oprofile memleaked in linux-2.6 current tree,
    and tracked this ring-buffer leak.
    
    Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
    LKML-Reference: <4A7C06B9.2090302@gmail.com>
    Cc: stable@kernel.org
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index d4d3580..a330513 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -735,6 +735,7 @@ ring_buffer_free(struct ring_buffer *buffer)
 
 	put_online_cpus();
 
+	kfree(buffer->buffers);
 	free_cpumask_var(buffer->cpumask);
 
 	kfree(buffer);
