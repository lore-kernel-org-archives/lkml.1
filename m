Return-Path: <linux-kernel-owner+w=401wt.eu-S1755273AbYINPm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbYINPm7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 11:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbYINPmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 11:42:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32780 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbYINPmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 11:42:51 -0400
Date: Sun, 14 Sep 2008 17:42:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dean Nelson <dcn@sgi.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Alan Mayer <ajm@sgi.com>,
       jeremy@goop.org, rusty@rustcorp.com.au, suresh.b.siddha@intel.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <Yinghai.lu@amd.com>
Subject: Re: [RFC 4/4] switch non-standard SYSCALL_VECTOR allocation to use
	vector_irq[]
Message-ID: <20080914154225.GM29290@elte.hu>
References: <489C6844.9050902@sgi.com> <20080811165930.GI4524@elte.hu> <48A0737F.9010207@sgi.com> <m1y733mjdh.fsf@frodo.ebiederm.org> <20080911152304.GA13655@sgi.com> <20080911152940.GE13655@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080911152940.GE13655@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0011]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dean Nelson <dcn@sgi.com> wrote:

> +		ret = __grab_irq_vector(NON_IRQ_DESC, syscall_vector,
> +					&cpu_possible_map);
> +		spin_unlock_irqrestore(&vector_lock, flags);
> +		if (ret == false) {
> +			printk("lg: couldn't reserve syscall %u\n",
> +			       syscall_vector);
> +			return -EBUSY;
> +		}

please use __grab_irq_vector() to standard return type: -EINVAL (or 
-EBUSY) on failure, vector on success. That will get rid of the 'ret == 
false' ugliness too.

	Ingo
