Return-Path: <linux-kernel-owner+w=401wt.eu-S1758707AbYCYSA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707AbYCYSA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 14:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756611AbYCYSAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 14:00:14 -0400
Received: from brick.kernel.dk ([87.55.233.238]:9604 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755308AbYCYSAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 14:00:12 -0400
Date: Tue, 25 Mar 2008 19:00:06 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de, paulus@samba.org,
       tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH 0/5] Generic smp_call_function(), improvements, and smp_call_function_single()
Message-ID: <20080325180004.GE15355@kernel.dk>
References: <1205927772-31401-1-git-send-email-jens.axboe@oracle.com> <1FE6DD409037234FAB833C420AA843ECE137D9@orsmsx424.amr.corp.intel.com> <20080321183149.GB15355@kernel.dk> <1FE6DD409037234FAB833C420AA843ECE1387F@orsmsx424.amr.corp.intel.com> <20080322122903.GD15355@kernel.dk> <1FE6DD409037234FAB833C420AA843ECE5B76D@orsmsx424.amr.corp.intel.com> <20080325081219.GO15355@kernel.dk> <1FE6DD409037234FAB833C420AA843ECE5BEDC@orsmsx424.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FE6DD409037234FAB833C420AA843ECE5BEDC@orsmsx424.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25 2008, Luck, Tony wrote:
> > So now I/we just need to figure out why the hack to call
> > init_call_single_data() is needed. You seem to imply it was being called
> > too late, I thought perhaps too early. Where did you stick the
> > init_call_single_data() call in?
> 
> In ia64 the first calls to smp_call_function_single() are made
> while bringing up other cpus ... which happens from:
> 
> 	kernel_init()
> 		smp_init()
> 
> The init calls are made a few lines later (still in kernel_init):
> 
> 		do_basic_setup()
> 			do_initcalls()
> 
> I moved the call radically earlier (before sched_init() in
> init/main.c:start_kernel()) just to be sure, but that was
> overkill.
> 
> Perhaps making the call from do_pre_smp_initcalls() is the
> logical place?  Like this (though purists will say that the
> extern declaration should be in some header file):

It looks fine to me, not a big deal I think... I was woried that
core_initcall() would not suit all, so this helps.

Thanks Tony!

-- 
Jens Axboe

