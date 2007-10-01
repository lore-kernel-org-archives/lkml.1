Return-Path: <linux-kernel-owner+w=401wt.eu-S1755208AbXJAOpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbXJAOpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 10:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbXJAOos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 10:44:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58058 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbXJAOop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 10:44:45 -0400
Date: Mon, 1 Oct 2007 16:44:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, maneesh@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>
Subject: Re: [RFC/PATCH] Add sysfs control to modify a user's cpu share
Message-ID: <20071001144402.GA3505@elte.hu>
References: <1190723327.7112.5.camel@Homer.simpson.net> <1190724893.13716.8.camel@Homer.simpson.net> <20070925131717.GM26289@linux.vnet.ibm.com> <1190725693.13716.10.camel@Homer.simpson.net> <20070925132528.GN26289@linux.vnet.ibm.com> <1190726682.11260.1.camel@Homer.simpson.net> <20070925140559.GB26310@linux.vnet.ibm.com> <20070925143755.GA15594@elte.hu> <20070926210737.GA8663@elte.hu> <20071001140454.GA19439@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071001140454.GA19439@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


hi Dhaval,

* Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:

> Hi Ingo,
> 
> Adds tunables in sysfs to modify a user's cpu share.
> 
> A directory is created in sysfs for each new user in the system.
> 
> 	/sys/kernel/uids/<uid>/cpu_share
> 
> Reading this file returns the cpu shares granted for the user.
> Writing into this file modifies the cpu share for the user. Only an 
> administrator is allowed to modify a user's cpu share.
> 
> Ex: 
> 	# cd /sys/kernel/uids/
> 	# cat 512/cpu_share
> 	1024
> 	# echo 2048 > 512/cpu_share
> 	# cat 512/cpu_share
> 	2048
> 	#

looks good to me! I think this API is pretty straightforward. I've put 
this into my tree and have updated the sched-devel git tree:

 git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git

but there seems to be a bug in it, i get this:

 kobject_add failed for 500 with -EEXIST, don't try to register things with the same name in the same directory.
  [<c01e1730>] kobject_shadow_add+0x13b/0x169
  [<c01e1795>] kobject_set_name+0x28/0x91
  [<c01299d5>] user_kobject_create+0x6a/0x90
  [<c0129d3c>] alloc_uid+0x141/0x181
  [<c012d05c>] set_user+0x1c/0x91
  [<c012e4c7>] sys_setresuid+0xd9/0x17d
  [<c0103cf6>] sysenter_past_esp+0x5f/0x85
  =======================

	Ingo
