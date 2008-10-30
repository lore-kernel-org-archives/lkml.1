Return-Path: <linux-kernel-owner+w=401wt.eu-S1757065AbYJ3SyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065AbYJ3SyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 14:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbYJ3SyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 14:54:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47115 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835AbYJ3SyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 14:54:12 -0400
Date: Thu, 30 Oct 2008 19:53:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: jens.axboe@oracle.com, paulmck@linux.vnet.ibm.com,
       jeremy.fitzhardinge@citrix.com, nickpiggin@yahoo.com.au,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       asit.k.mallick@intel.com
Subject: Re: [patch] generic-ipi: fix the smp_mb() placement
Message-ID: <20081030185322.GE17822@elte.hu>
References: <20081029224229.GK30573@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029224229.GK30573@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> Subject: generic-ipi: fix the smp_mb() placement
> 
> smp_mb() is needed (to make the memory operations visible globally) 
> before sending the ipi on the sender and the receiver (on Alpha 
> atleast) needs smp_read_barrier_depends() in the handler before 
> reading the call_single_queue list in a lock-free fashion.
> 
> On x86, x2apic mode register accesses for sending IPI's don't have 
> serializing semantics. So the need for smp_mb() before sending the 
> IPI becomes more critical in x2apic mode.
> 
> Remove the unnecessary smp_mb() in csd_flag_wait(), as the presence 
> of that smp_mb() doesn't mean anything on the sender, when the ipi 
> receiver is not doing any thing special (like memory fence) after 
> clearing the CSD_FLAG_WAIT.

nice! Did you see an actual lockup due to this? Seems like a v2.6.28 
fix to me in any case.

	Ingo
