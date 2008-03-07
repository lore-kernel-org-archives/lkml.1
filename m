Return-Path: <linux-kernel-owner+w=401wt.eu-S1756833AbYCGHe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833AbYCGHe5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 02:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbYCGHer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 02:34:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38278 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbYCGHer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 02:34:47 -0500
Date: Fri, 7 Mar 2008 08:34:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: git bisect in 2.6.25-rc1 looks weird
Message-ID: <20080307073434.GA27975@elte.hu>
References: <1204872163.17994.44.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204872163.17994.44.camel@ymzhang>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:

> Are the patches committed in line? or there are many paths crossing?

it's fine. git-bisect works on a tree of commits (not a queue/line of 
commits) - so certain 'lines' of patches can jump in and out.

the scheduler patches are always in a straight line, so later on in the 
bisection the jumping should be simplified.

you might want to look at "gitk" output and pick out a specific line of 
scheduler patches. For example:

  commit 32a76006683f7b28ae3cc491da37716e002f198e

to:

  commit 6d082592b62689fb91578d0338d04a9f50991990

is a straight line of 95 scheduler related commits. That's one of the 
probable areas where the regression you are looking for came in. 

when you bisect that specific range, you should try to undo the 
following two commits:

      commit 58e2d4ca581167c2a079f4ee02be2f0bc52e8729
      Author: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
      Date:   Fri Jan 25 21:08:00 2008 +0100
      sched: group scheduling, change how cpu load is calculated

      commit 6b2d7700266b9402e12824e11e0099ae6a4a6a79
      Author: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
      Date:   Fri Jan 25 21:08:00 2008 +0100
      sched: group scheduler, fix fairness of cpu bandwidth allocation for task

	Ingo
