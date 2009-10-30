Return-Path: <linux-kernel-owner+w=401wt.eu-S1756252AbZJ3IUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252AbZJ3IUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 04:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756196AbZJ3IUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 04:20:52 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49672 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756194AbZJ3IUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 04:20:49 -0400
Date: Fri, 30 Oct 2009 19:20:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>
Subject: linux-next: manual merge of the percpu tree with Linus' tree
Message-Id: <20091030192050.06a0f706.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the percpu tree got a conflict in mm/percpu.c
between commit 403a91b1659cb149dbddc5885f892734ae4542d8 ("percpu: allow
pcpu_alloc() to be called with IRQs off") from Linus' tree and commit
0f5e4816dbf38ce9488e611ca2296925c1e90d5e ("percpu: remove some sparse
warnings") from the percpu tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/percpu.c
index d907971,e2e80fc..0000000
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@@ -369,7 -364,8 +367,8 @@@ static struct pcpu_chunk *pcpu_chunk_ad
   * RETURNS:
   * 0 if noop, 1 if successfully extended, -errno on failure.
   */
 -static int pcpu_extend_area_map(struct pcpu_chunk *chunk)
 +static int pcpu_extend_area_map(struct pcpu_chunk *chunk, unsigned long *flags)
+ 	__releases(lock) __acquires(lock)
  {
  	int new_alloc;
  	int *new;
