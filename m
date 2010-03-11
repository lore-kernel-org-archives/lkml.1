Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab0CKH46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 02:56:58 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35442 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab0CKH4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 02:56:54 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 11 Mar 2010 16:53:15 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       kirill@shutemov.name
Subject: [RFC][PATCH 0/3] memcg: oom notifier at el. (v3)
Message-Id: <20100311165315.c282d6d2.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated against mmotm-Mar9.

This patch set's feature is
 - add filter to memcg's oom waitq.
 - oom kill notifier for memcg.
 - oom kill disable for memcg.

Major changes since previous one are
 - add filter to wakeup queue.
 - use its own function and logic rather than reusing thresholds.
 - some minor fixes.

If oom-killer disabled, all tasks under memcg will sleep in memcg_oom_waitq.
What users can do when memcg-oom-killer is disabled is:
 - enlarge limit.
 - kill some task. ---(*)
 - move some task to other cgroup. (with account migration)
   (This patchset doesn't handle a case when account migraion isn't set.)

The benefit of (*) is that the user can save information of all tasks before
killing and he can take coredump (by gcore.) of troublesome process.

I'm now wondering when I remove RFC...but I think this will not have
much HUNK with dirty_ratio sets.

If some codes are unclear, feel free to request me.

Thanks,
-Kame

