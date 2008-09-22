Return-Path: <linux-kernel-owner+w=401wt.eu-S1752585AbYIVK0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbYIVK0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 06:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbYIVK0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 06:26:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53507 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbYIVKZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 06:25:59 -0400
Date: Mon, 22 Sep 2008 12:25:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: robert.richter@amd.com, akpm@linux-foundation.org,
       oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] oprofile: BUG: using smp_processor_id() in
	preemptible code
Message-ID: <20080922102524.GB30137@elte.hu>
References: <1221908320-7183-1-git-send-email-righi.andrea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221908320-7183-1-git-send-email-righi.andrea@gmail.com>
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


* Andrea Righi <righi.andrea@gmail.com> wrote:

> Add local_irq_save() / local_irq_restore() before setting per cpu 
> variable switch_index, to avoid the following BUG:

that just papers over the bug:

> +	local_irq_save(flags);
>  	__get_cpu_var(switch_index) = 0;
> +	local_irq_restore(flags);

either use __raw_get_cpu_var() if we are for sure not preemptible here, 
or fix the preemption status of this codepath.

	Ingo
