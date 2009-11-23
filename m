Return-Path: <linux-kernel-owner+w=401wt.eu-S1752734AbZKWRHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbZKWRHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 12:07:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbZKWRHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 12:07:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52234 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbZKWRHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 12:07:39 -0500
Date: Mon, 23 Nov 2009 18:07:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, eranian@gmail.com,
       a.p.zijlstra@chello.nl, paulus@samba.org,
       perfmon2-devel@lists.sourceforge.net
Subject: Re: [PATCH] perf_events: fix bogus copy_to_user() in
 perf_event_read_group()
Message-ID: <20091123170734.GB6209@elte.hu>
References: <4b0ab8b1.1c07d00a.4859.5f71@mx.google.com>
 <bd4cb8900911230836na261658udd82f5c20630ffba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd4cb8900911230836na261658udd82f5c20630ffba@mail.gmail.com>
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


* Stephane Eranian <eranian@google.com> wrote:

> ?? ?? ?? ??When using an event group, the value and id for non leaders events were
> ?? ?? ?? ??wrong due to invalid offset into the outgoing buffer.
> 
> ?? ?? ?? ??Signed-off-by: Stephane Eranian <eranian@google.com>
> 
> ---
> ??perf_event.c | ?? ??2 +-
> ??1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 0b0d5f7..8306127 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -1826,7 +1826,7 @@ static int perf_event_read_group(struct perf_event *event,
> 
> ?? ?? ?? ?? ?? ?? ?? ??size = n * sizeof(u64);
> 
> - ?? ?? ?? ?? ?? ?? ?? if (copy_to_user(buf + size, values, size)) {
> + ?? ?? ?? ?? ?? ?? ?? if (copy_to_user(buf + ret, values, size)) {
> ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ??ret = -EFAULT;
> ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ??goto unlock;
> ?? ?? ?? ?? ?? ?? ?? ??}

hm, patch is seriously garbled - mind sending it according to 
Documentation/email-clients.txt?

Thanks,

	Ingo
