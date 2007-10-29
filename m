Return-Path: <linux-kernel-owner+w=401wt.eu-S1753665AbXJ2CZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbXJ2CZk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 22:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbXJ2CZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 22:25:32 -0400
Received: from mga10.intel.com ([192.55.52.92]:17047 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750848AbXJ2CZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 22:25:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,339,1188802800"; 
   d="scan'208";a="362023385"
Subject: Re: aim7 -30% regression in 2.6.24-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20071026112307.GA30406@elte.hu>
References: <1193391787.3019.174.camel@ymzhang>
	 <20071026112307.GA30406@elte.hu>
Content-Type: text/plain; charset=utf-8
Date: Mon, 29 Oct 2007 10:22:18 +0800
Message-Id: <1193624538.3019.189.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-26 at 13:23 +0200, Ingo Molnar wrote:
> * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> 
> > I tested 2.6.24-rc1 on my x86_64 machine which has 2 quad-core processors.
> > 
> > Comparing with 2.6.23, aim7 has about -30% regression. I did a bisect 
> > and found patch 
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=b5869ce7f68b233ceb81465a7644be0d9a5f3dbb 
> > caused the issue.
> 
> weird, that's a commit diff - i.e. it changes no code.
I got the tag from #git log. As for above link, I just added prior http address,
so readers could check the patch by clicking.

> 
> > kbuild/SPECjbb2000/SPECjbb2005 also has big regressions. On my another 
> > tigerton machine (4 quad-core processors), SPECjbb2005 has more than 
> > -40% regression. I didn't do a bisect on such benchmark testing, but I 
> > suspect the root cause is like aim7's.
> 
> these two commits might be relevant:
> 
>   7a6c6bcee029a978f866511d6e41dbc7301fde4c
I did a quick testing. This patch has no impact.

>   95dbb421d12fdd9796ed153853daf3679809274f
Above big patch doesn't include this one, which means if I do
'git checkout b5869ce7f68b233ceb81465a7644be0d9a5f3dbb', the kernel doesn't include
95dbb421d12fdd9796ed153853daf3679809274f.

> 
> but a bisection result would be the best info.
I will do a bisect between 2.6.23 and tag 9c63d9c021f375a2708ad79043d6f4dd1291a085.

-yanmin
