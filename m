Return-Path: <linux-kernel-owner+w=401wt.eu-S1759291AbYFJJyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291AbYFJJyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 05:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758902AbYFJJyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 05:54:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39879 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079AbYFJJyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 05:54:00 -0400
Date: Tue, 10 Jun 2008 11:53:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix fail with 64g above system with numa32
Message-ID: <20080610095332.GC27706@elte.hu>
References: <200806031025.55026.yhlu.kernel@gmail.com> <200806031935.05202.yhlu.kernel@gmail.com> <200806061443.57488.yhlu.kernel@gmail.com> <200806061854.26421.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806061854.26421.yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> +++ b/arch/x86/kernel/srat_32.c	2008-06-06 17:38:38.000000000 -0700
> @@ -251,7 +251,7 @@ static int __init acpi20_parse_srat(stru
>   
>  	for_each_online_node(nid) {
>  		unsigned long start = node_start_pfn[nid];
> -		unsigned long end = node_end_pfn[nid];
> +		unsigned long end = min(node_end_pfn[nid],max_pfn);
>  
>  		memory_present(nid, start, end);

applied to tip/x86/mpparse, thanks.

	Ingo
