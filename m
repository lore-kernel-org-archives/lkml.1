Return-Path: <linux-kernel-owner+w=401wt.eu-S1755262AbYGaHdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbYGaHdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 03:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbYGaHdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 03:33:41 -0400
Received: from mga10.intel.com ([192.55.52.92]:45955 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753224AbYGaHdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 03:33:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,284,1215414000"; 
   d="scan'208";a="366677596"
Subject: Re: VolanoMark regression with 2.6.27-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1217474425.25608.150.camel@ymzhang>
References: <1217474425.25608.150.camel@ymzhang>
Content-Type: text/plain
Date: Thu, 31 Jul 2008 15:31:03 +0800
Message-Id: <1217489463.25608.157.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-07-31 at 11:20 +0800, Zhang, Yanmin wrote:
> Ingo,
> 
> volanoMark has regression with 2.6.27-rc1.
> 1) 70% on 16-core tigerton;
> 2) 18% on a new multi-core+HT mahcine;
> 
> I tried to use git bisect to locate the root cause, but git bisect always went
> back to 2.6.26. Then, I used my mechanical bisect script linearly to locate below commit:
> 
> commit 82638844d9a8581bbf33201cc209a14876eca167
> Merge: 9982fbf... 63cf13b...
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Wed Jul 16 00:29:07 2008 +0200
> 
>     Merge branch 'linus' into cpus4096
> 
>     Conflicts:
> 
>         arch/x86/xen/smp.c
>         kernel/sched_rt.c
>         net/iucv/iucv.c
> 
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> 
> But if I use 'git show 82638844d9a8581bbf33201cc209a14876eca167', it looks like I could only
> get a part of the patch. If I use web to acces the commit, I could get a big patch. As it's
> a merge, what're commit numbers of the subpatches?
> 
> 
> BTW, sysbench+mysql(oltp readonly) has about 15% regression, but git bisect looks crazy again.
Oh, it looks like they are the old issues in 2.6.26-rc1 and the 2 patches were reverted before 2.6.26.
New patches are merged into 2.6.27-rc1, but the issues are still not resolved clearly.
http://www.uwsg.iu.edu/hypermail/linux/kernel/0805.2/1148.html.

yanmin


