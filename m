Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048AbZGHVFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbZGHVFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 17:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbZGHVF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 17:05:26 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:59247 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754551AbZGHVFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 17:05:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjkFAHGiVEpMQWU3/2dsb2JhbACBUdAghAgF
Date: Wed, 8 Jul 2009 17:05:22 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3] ring-buffer: make lockless
Message-ID: <20090708210522.GA17430@Krystal>
References: <20090708201312.222046866@goodmis.org> <20090708201445.696220393@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090708201445.696220393@goodmis.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:22:28 up 130 days, 16:48,  4 users,  load average: 0.89, 0.98,
	0.77
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> This patch converts the ring buffers into a completely lockless
> buffer recording system. The read side still takes locks since
> we still serialize readers. But the writers are the ones that
> must be lockless (those can happen in NMIs).

Hi Steven,

Have you started modeling this scheme with Promela as I previously
discussed with you ? Paul McKenney did a lot of nice papers on the
topic, and given the complexity level of this lockless buffering
algorithm, I'd be much more comfortable if it was formally verified. The
idea here is to make sure we don't start an endless bug-chasing hunt as
trace buffers gets more exposure to various workloads.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
