Return-Path: <linux-kernel-owner+w=401wt.eu-S1752713AbYKLK0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbYKLK0E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 05:26:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbYKLKZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 05:25:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55192 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822AbYKLKZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 05:25:53 -0500
Date: Wed, 12 Nov 2008 11:25:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/2] ring-buffer: fix deadlock from reader_lock in
	read_start
Message-ID: <20081112102518.GC24482@elte.hu>
References: <20081112050125.654925304@goodmis.org> <20081112050218.952245378@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112050218.952245378@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Impact: deadlock fix in ring_buffer_read_start
> 
> The ring_buffer_iter_reset was called from ring_buffer_read_start
> where both grabbed the reader_lock.
> 
> This patch separates out the internals of ring_buffer_iter_reset
> to its own function so that both APIs may grab the reader_lock.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/trace/ring_buffer.c |   29 +++++++++++++++++------------
>  1 files changed, 17 insertions(+), 12 deletions(-)

applied to tip/tracing/ring-buffer, thanks Steve!

	Ingo
