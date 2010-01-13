Return-Path: <linux-kernel-owner+w=401wt.eu-S1750835Ab0AMFA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750835Ab0AMFA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 00:00:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750727Ab0AMFA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 00:00:27 -0500
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:60315 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750715Ab0AMFA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 00:00:27 -0500
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier (v5)
From: Nicholas Miell <nmiell@comcast.net>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
In-Reply-To: <20100113013757.GA29314@Krystal>
References: <20100113013757.GA29314@Krystal>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jan 2010 21:00:23 -0800
Message-ID: <1263358823.3874.10.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-12 at 20:37 -0500, Mathieu Desnoyers wrote:
> + * sys_membarrier - issue memory barrier on current process running threads
> + * @expedited: (0) Lowest overhead. Few milliseconds latency.
> + *             (1) Few microseconds latency.
> + *

Alternate ABI proposal, keeping the possibility of future expansion in
mind:

/*
Mandatory flags to the membarrier system call that the kernel must
understand are in the high 16 bits.
*/
#define MEMBARRIER_MANDATORY_MASK 0xFFFF0000

/*
Optional hints that the kernel can ignore are in the low 16 bits.
*/
#define MEMBARRIER_OPTIONAL_MASK 0x0000FFFF

#define MEMBARRIER_EXPEDITED 1

extern int membarrier(unsigned int flags);

And then add to the system call itself:

if ((flags & MEMBARRIER_MANDATORY_MASK) != 0)
	return -EINVAL;


-- 
Nicholas Miell <nmiell@comcast.net>

