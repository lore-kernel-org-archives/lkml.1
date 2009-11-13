Return-Path: <linux-kernel-owner+w=401wt.eu-S1755995AbZKMJeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbZKMJeH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 04:34:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755736AbZKMJeC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 04:34:02 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48908 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755749AbZKMJdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 04:33:52 -0500
Date: Fri, 13 Nov 2009 10:33:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.32-rc6] workqueue: fix race condition in
 schedule_on_each_cpu()
Message-ID: <20091113093341.GB26185@elte.hu>
References: <4AFD26F5.809@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFD26F5.809@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> Commit 65a64464349883891e21e74af16c05d6e1eeb4e9 which allows
> schedule_on_each_cpu() to be called from keventd added a race
> condition.  schedule_on_each_cpu() may race with cpu hotplug and end
> up executing the function twice on a cpu.
> 
> Fix it by moving direct execution into the section protected with
> get/put_online_cpus().  While at it, update code such that direct
> execution is done after works have been scheduled for all other cpus
> and drop unnecessary cpu != orig test from flush loop.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> ---
> Andi, Oleg, this patch tested fine on my machine but it would be great
> if you guys can ack it.  Ingo, upon ack, can you please route this
> patch?
> 
> Thanks.

Andrew's doing workqueue patches - i've Cc:-ed him.

Looks good to me. Btw., 65a644643 should have been done via -mm, or at 
least it should have gathered proper Acks from interested parties before 
pushing the change upstream.

	Ingo
