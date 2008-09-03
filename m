Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425AbYICD3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbYICD3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 23:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754250AbYICD3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 23:29:03 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52949 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbYICD3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 23:29:01 -0400
Date: Wed, 3 Sep 2008 12:33:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, hugh@veritas.com,
       menage@google.com, xemul@openvz.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [RFC][PATCH] Remove cgroup member from struct page
Message-Id: <20080903123306.316beb9d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <48BD337E.40001@linux.vnet.ibm.com>
References: <20080831174756.GA25790@balbir.in.ibm.com>
	<200809011656.45190.nickpiggin@yahoo.com.au>
	<20080901161927.a1fe5afc.kamezawa.hiroyu@jp.fujitsu.com>
	<200809011743.42658.nickpiggin@yahoo.com.au>
	<48BD0641.4040705@linux.vnet.ibm.com>
	<20080902190256.1375f593.kamezawa.hiroyu@jp.fujitsu.com>
	<48BD0E4A.5040502@linux.vnet.ibm.com>
	<20080902190723.841841f0.kamezawa.hiroyu@jp.fujitsu.com>
	<48BD119B.8020605@linux.vnet.ibm.com>
	<20080902195717.224b0822.kamezawa.hiroyu@jp.fujitsu.com>
	<48BD337E.40001@linux.vnet.ibm.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Sep 2008 18:07:18 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> I understand your concern and I am not trying to reduce memcg's performance - or
> add a fancy feature. I am trying to make memcg more friendly for distros. I see
> your point about the overhead. I just got back my results - I see a 4% overhead
> with the patches. Let me see if I can rework them for better performance.
> 
Just an idea, by using atomic_ops page_cgroup patch, you can encode page_cgroup->lock
to page_cgroup->flags and use bit_spinlock(), I think.
(my new patch set use bit_spinlock on page_cgroup->flags for avoiding some race.)

This will save extra 4 bytes.

Thanks,
-Kame

