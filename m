Return-Path: <linux-kernel-owner+w=401wt.eu-S1760191AbYCGH40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760191AbYCGH40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 02:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754908AbYCGH4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 02:56:14 -0500
Received: from mga10.intel.com ([192.55.52.92]:61486 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756672AbYCGH4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 02:56:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,461,1199692800"; 
   d="scan'208";a="304295741"
Subject: Re: git bisect in 2.6.25-rc1 looks weird
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080307073434.GA27975@elte.hu>
References: <1204872163.17994.44.camel@ymzhang>
	 <20080307073434.GA27975@elte.hu>
Content-Type: text/plain; charset=utf-8
Date: Fri, 07 Mar 2008 15:50:17 +0800
Message-Id: <1204876217.17994.50.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-07 at 08:34 +0100, Ingo Molnar wrote:
> * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> 
> > Are the patches committed in line? or there are many paths crossing?
> 
> it's fine. git-bisect works on a tree of commits (not a queue/line of 
> commits) - so certain 'lines' of patches can jump in and out.
> 
> the scheduler patches are always in a straight line, so later on in the 
> bisection the jumping should be simplified.
Thanks.

> 
> you might want to look at "gitk" output and pick out a specific line of 
> scheduler patches. For example:
> 
>   commit 32a76006683f7b28ae3cc491da37716e002f198e
> 
> to:
> 
>   commit 6d082592b62689fb91578d0338d04a9f50991990
> 
> is a straight line of 95 scheduler related commits. That's one of the 
> probable areas where the regression you are looking for came in. 
> 
> when you bisect that specific range, you should try to undo the 
> following two commits:
It looks like many patches commited ater the 2 patches changed same
code lines or nearby code lines. So there are many conflictions when I undo
the 2 patches.

Let me retry.

> 
>       commit 58e2d4ca581167c2a079f4ee02be2f0bc52e8729
>       Author: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
>       Date:   Fri Jan 25 21:08:00 2008 +0100
>       sched: group scheduling, change how cpu load is calculated
> 
>       commit 6b2d7700266b9402e12824e11e0099ae6a4a6a79
>       Author: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
>       Date:   Fri Jan 25 21:08:00 2008 +0100
>       sched: group scheduler, fix fairness of cpu bandwidth allocation for task
> 
> 	Ingo

