Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbZCMAUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbZCMAUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 20:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbZCMAUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 20:20:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44819 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbZCMAUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 20:20:40 -0400
Date: Fri, 13 Mar 2009 01:20:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       peterz@infradead.org, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/futexes] futex: additional (get|put)_futex_key()
	fixes
Message-ID: <20090313002000.GA11780@elte.hu>
References: <20090312075545.9856.75152.stgit@Aeon> <tip-de87fcc124a5d4a171aa32707b3265608ebda6e7@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-de87fcc124a5d4a171aa32707b3265608ebda6e7@git.kernel.org>
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


* Darren Hart <dvhltc@us.ibm.com> wrote:

> @@ -1595,13 +1601,12 @@ uaddr_faulted:
>  
>  	ret = get_user(uval, uaddr);
>  	if (!ret)
> -		goto retry;
> +		goto retry_unlocked;
>  
> -	if (to)
> -		destroy_hrtimer_on_stack(&to->timer);
> -	return ret;
> +	goto out_put_key;

hm, was that destroy_hrtimer_on_stack() removal intended? It's 
not directly commented on in the changelog.

	Ingo
