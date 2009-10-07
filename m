Return-Path: <linux-kernel-owner+w=401wt.eu-S1759040AbZJGMiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759040AbZJGMiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 08:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758924AbZJGMiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 08:38:14 -0400
Received: from bc.sympatico.ca ([209.226.175.184]:50980 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754341AbZJGMiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 08:38:13 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlMFAOIjzEpMROOX/2dsb2JhbACBUdNQhCoE
Date: Wed, 7 Oct 2009 08:36:59 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/4] DEBUG_RCU_HEAD: Debug and fix racy call_rcu() users
Message-ID: <20091007123658.GA27363@Krystal>
References: <20091006143727.868480435@polymtl.ca> <20091007042054.GE6838@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20091007042054.GE6838@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 08:31:03 up 49 days, 23:20,  2 users,  load average: 0.27, 0.23,
	0.22
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Tue, Oct 06, 2009 at 10:37:28AM -0400, Mathieu Desnoyers wrote:
> > Here is a patchset, done on 2.6.30.9, which permits to detect and fix racy
> > call_rcu() users.
> > 
> > Fix for vunmap, which happens to be one of them, is included.
> > 
> > Note that some false-positives might come up when call_rcu() is called on
> > uninitialized struct rcu_head. The solution is, surprisingly enough, to
> > initialize them.
> 
> Very cool, Mathieu!!!
> 
> I do like adding the debug-only field to struct rcu_head.  Lots of
> additional places need initialization, or am I missing a trick here?
> 

In my case, only 2 sites in the process management and 1 site in the now
deprecated marker.c complained about not being initialized.

I can guess we will find others though. Please see the v2 of my patch,
which adds the supplementary "debug" field rather than depending on
word-aligned pointers. I volountarily complain about the .debug pointer
being non-NULL when we find an uninitialized site. I could be more
specific and complain "differently" if the pointer happens to be random
vs if it's LIST_POISON1.

Thanks,

Mathieu

> 							Thanx, Paul

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
