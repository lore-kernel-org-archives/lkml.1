Return-Path: <linux-kernel-owner+w=401wt.eu-S1757974AbZHQSYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974AbZHQSYi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 14:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757956AbZHQSYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 14:24:37 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33036 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757952AbZHQSYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 14:24:37 -0400
Subject: Re: [PATCH -tip/core/rcu 1/6] Cleanups and fixes for RCU in face
 of heavy CPU-hotplug stress
From: Josh Triplett <josht@linux.vnet.ibm.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       hugh.dickins@tiscali.co.uk, benh@kernel.crashing.org
In-Reply-To: <20090815165153.GA8886@linux.vnet.ibm.com>
References: <20090815165153.GA8886@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 17 Aug 2009 11:24:47 -0700
Message-Id: <1250533487.2709.14.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-08-15 at 09:51 -0700, Paul E. McKenney wrote:
> These pass tests combining rcutorture and continuous CPU-hotplug
> operations, in other words, no sleeping between successive CPU-hotplug
> operations.  This set does not fix the bug involving deadlocks through
> rcutorture, kthread_stop(), and migration threads.  However, this bug
> does not affect production systems, so should not stand in the way of
> applying these patches.

Commit 63706172f332fd3f6e7458ebfb35fa6de9c21dc5, "kthreads: rework
kthread_stop()", looks like it fixes kthread_stop to work concurrently.
That may fix the issue you observed.

- Josh Triplett

