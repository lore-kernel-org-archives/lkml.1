Return-Path: <linux-kernel-owner+w=401wt.eu-S1758805AbZKKCmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805AbZKKCmF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 21:42:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758755AbZKKCmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 21:42:05 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51928 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757093AbZKKCmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 21:42:03 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 6/6] mm: sigbus instead of abusing oom
Cc: kosaki.motohiro@jp.fujitsu.com, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Izik Eidus <ieidus@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20091111113719.589e61d7.kamezawa.hiroyu@jp.fujitsu.com>
References: <Pine.LNX.4.64.0911102202500.2816@sister.anvils> <20091111113719.589e61d7.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20091111114119.FD53.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 11 Nov 2009 11:42:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 10 Nov 2009 22:06:49 +0000 (GMT)
> Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:
> 
> > When do_nonlinear_fault() realizes that the page table must have been
> > corrupted for it to have been called, it does print_bad_pte() and
> > returns ... VM_FAULT_OOM, which is hard to understand.
> > 
> > It made some sense when I did it for 2.6.15, when do_page_fault()
> > just killed the current process; but nowadays it lets the OOM killer
> > decide who to kill - so page table corruption in one process would
> > be liable to kill another.
> > 
> > Change it to return VM_FAULT_SIGBUS instead: that doesn't guarantee
> > that the process will be killed, but is good enough for such a rare
> > abnormality, accompanied as it is by the "BUG: Bad page map" message.
> > 
> > And recent HWPOISON work has copied that code into do_swap_page(),
> > when it finds an impossible swap entry: fix that to VM_FAULT_SIGBUS too.
> > 
> > Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> 
> Thank you !
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Thank you, me too.

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



