Return-Path: <linux-kernel-owner+w=401wt.eu-S1758139AbZEZUFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139AbZEZUFe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 16:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756686AbZEZUF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 16:05:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48231 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574AbZEZUF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 16:05:27 -0400
Date: Tue, 26 May 2009 22:05:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] oprofile fixlet
Message-ID: <20090526200516.GA1364@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
Robert Richter (1):
      oprofile: fix cpu buffer size


 drivers/oprofile/cpu_buffer.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index f0e99d4..242257b 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -78,16 +78,20 @@ void free_cpu_buffers(void)
 	op_ring_buffer_write = NULL;
 }
 
+#define RB_EVENT_HDR_SIZE 4
+
 int alloc_cpu_buffers(void)
 {
 	int i;
 
 	unsigned long buffer_size = oprofile_cpu_buffer_size;
+	unsigned long byte_size = buffer_size * (sizeof(struct op_sample) +
+						 RB_EVENT_HDR_SIZE);
 
-	op_ring_buffer_read = ring_buffer_alloc(buffer_size, OP_BUFFER_FLAGS);
+	op_ring_buffer_read = ring_buffer_alloc(byte_size, OP_BUFFER_FLAGS);
 	if (!op_ring_buffer_read)
 		goto fail;
-	op_ring_buffer_write = ring_buffer_alloc(buffer_size, OP_BUFFER_FLAGS);
+	op_ring_buffer_write = ring_buffer_alloc(byte_size, OP_BUFFER_FLAGS);
 	if (!op_ring_buffer_write)
 		goto fail;
 
