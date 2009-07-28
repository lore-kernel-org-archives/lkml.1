Return-Path: <linux-kernel-owner+w=401wt.eu-S1752345AbZG1IwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbZG1IwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 04:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbZG1IwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 04:52:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36412 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbZG1IwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 04:52:14 -0400
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Miao Xie <miaox@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Paul Menage <menage@google.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Rientjes <rientjes@google.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUGFIX] set_mempolicy(MPOL_INTERLEAV) N_HIGH_MEMORY aware
From: Andi Kleen <andi@firstfloor.org>
References: <20090715182320.39B5.A69D9226@jp.fujitsu.com>
	<20090728161813.f2fefd29.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 28 Jul 2009 10:52:10 +0200
In-Reply-To: <20090728161813.f2fefd29.kamezawa.hiroyu@jp.fujitsu.com> (KAMEZAWA Hiroyuki's message of "Tue, 28 Jul 2009 16:18:13 +0900")
Message-ID: <877hxti405.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:

> tested on x86-64/fake NUMA and ia64/NUMA.
> (That ia64 is a host which orignal bug report used.)
>
> Maybe this is bigger patch than expected, but NODEMASK_ALLOC() will be a way
> to go, anyway. (even if CPUMASK_ALLOC is not used anyware yet..)
> Kosaki tested this on ia64 NUMA. thanks.

Note that low/high memory support in NUMA policy is only partial
anyways, e.g. the VMA based policy only supports a single zone. That
was by design choice and because NUMA has a lot of issues on 32bit due
to the limited address space and is not widely used.

So small fixes are ok but I wouldn't go to large effort to fix NUMA
policy on 32bit.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
