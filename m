Return-Path: <linux-kernel-owner+w=401wt.eu-S1758218AbXJCRqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218AbXJCRqv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 13:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754346AbXJCRqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 13:46:44 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51420 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754465AbXJCRqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 13:46:43 -0400
Date: Wed, 3 Oct 2007 10:46:40 -0700
From: Paul Jackson <pj@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: akpm@linux-foundation.org, menage@google.com, linux-kernel@vger.kernel.org,
       dino@in.ibm.com, cpw@sgi.com, mingo@elte.hu
Subject: Re: [PATCH] cpuset and sched domains: sched_load_balance flag
Message-Id: <20071003104640.85c8208b.pj@sgi.com>
In-Reply-To: <200710030630.19850.nickpiggin@yahoo.com.au>
References: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com>
	<200710030553.27822.nickpiggin@yahoo.com.au>
	<20071003054149.a18b0547.pj@sgi.com>
	<200710030630.19850.nickpiggin@yahoo.com.au>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick wrote:
> So if a new pdflush is spawned, it get's moved to some cpuset? That
> probably isn't something these realtime systems want to do (ie. the
> non-realtime portion probably doesn't want to have any sort of scheduler
> or even worry about cpusets at all).

No - the new pdflush is put in the same cpuset as its parent, with a
patch that I sent in early this year.  See the following code in
mm/pdflush.c:

        /*
         * Some configs put our parent kthread in a limited cpuset,
         * which kthread() overrides, forcing cpus_allowed == CPU_MASK_ALL.
         * Our needs are more modest - cut back to our cpusets cpus_allowed.
         * This is needed as pdflush's are dynamically created and destroyed.
         * The boottime pdflush's are easily placed w/o these 2 lines.
         */
        cpus_allowed = cpuset_cpus_allowed(current);
        set_cpus_allowed(current, cpus_allowed);

        return __pdflush(&my_work);

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
