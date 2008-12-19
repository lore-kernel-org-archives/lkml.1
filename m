Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbYLSIbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbYLSIbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 03:31:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbYLSIbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 03:31:18 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:44448 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbYLSIbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 03:31:17 -0500
Date: Fri, 19 Dec 2008 17:29:03 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Hugh Dickins" <hugh@veritas.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       nishimura@mxp.nes.nec.co.jp
Subject: [bug][mmtom] memcg: MEM_CGROUP_ZSTAT underflow
Message-Id: <20081219172903.7ca9b123.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Current(I'm testing 2008-12-16-15-50 with some patches, though) memcg have
MEM_CGROUP_ZSTAT underflow problem.

How to reproduce:
- make a directory, set mem.limit.
- run some programs exceeding mem.limit.
- make another directory, and all the tasks in old directory to new one.
- New directory's "inactive_anon" in memory.stat underflows.

>From my investigation:
- This problem seems to happen only when swapping anonymous pages. It seems
  not to happen about shmem.
- After removing memcg-fix-swap-accounting-leak-v3.patch(and of course
  memcg-fix-swap-accounting-leak-doc-fix.patch), this problem doesn't happen.

Thoughts?


Thanks,
Daisuke Nishimura.
