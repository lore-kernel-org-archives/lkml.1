Return-Path: <linux-kernel-owner+w=401wt.eu-S1756078AbZEFI2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbZEFI2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 04:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbZEFI22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 04:28:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48948 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbZEFI21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 04:28:27 -0400
Date: Wed, 6 May 2009 10:28:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 03/11] tracing: export stats of ring buffers to
	userspace
Message-ID: <20090506082814.GB28675@elte.hu>
References: <20090506042101.231470089@goodmis.org> <20090506042333.402933098@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506042333.402933098@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <srostedt@redhat.com>
> 
> This patch adds stats to the ftrace ring buffers:
> 
>  # cat /debugfs/tracing/per_cpu/cpu0/stats
>  entries: 42360
>  overrun: 30509326
>  commit overrun: 0
>  nmi dropped: 0
> 
> Where entries are the total number of data entries in the buffer.
> 
> overrun is the number of entries not consumed and were overwritten by
> the writer.
> 
> commit overrun is the number of entries dropped due to nested writers
> wrapping the buffer before the initial writer finished the commit.
> 
> nmi dropped is the number of entries dropped due to the ring buffer
> lock being held when an nmi was going to write to the ring buffer.
> Note, this field will be meaningless and will go away when the ring
> buffer becomes lockless.
> 
> [ Impact: let userspace know what is happening in the ring buffers ]

nice! I was always wondering about these properties - Frederic 
reported that we drop a lot of trace entries when filtering is 
enabled, due to the rather stupid:

	reserve-buffer
	put-stuff-into-buffer
	drop-buffer-if-filter-false

common sequence we do on heavily filtered input.

	Ingo
