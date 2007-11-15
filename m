Return-Path: <linux-kernel-owner+w=401wt.eu-S1760160AbXKOORP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760160AbXKOORP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 09:17:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756689AbXKOOQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 09:16:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50964 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173AbXKOOQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 09:16:58 -0500
Date: Thu, 15 Nov 2007 15:15:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russel <rusty@rustcorp.com.au>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Paul E McKenney <paulmck@us.ibm.com>,
       Richard Gooch <rgooch@atnf.csiro.au>,
       Tigran Aivazian <tigran@aivazian.fs.co.uk>,
       Shoahua Li <shaohua.li@linux.com>, Ralf Baechle <ralf@linux-mips.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Nathan Lynch <ntl@pobox.com>, Paul Jackson <pj@sgi.com>,
       Christoph Lameter <clameter@sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [RFC PATCH 1/3] cpu-hotplug: Refcount Based Cpu Hotplug
	implementation
Message-ID: <20071115141501.GB28857@elte.hu>
References: <20071115134924.GA15282@in.ibm.com> <20071115135108.GA15462@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071115135108.GA15462@in.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Gautham R Shenoy <ego@in.ibm.com> wrote:

>  void lock_cpu_hotplug(void)
>  {
> -	struct task_struct *tsk = current;
> -
> -	if (tsk == recursive) {
> -		static int warnings = 10;
> -		if (warnings) {
> -			printk(KERN_ERR "Lukewarm IQ detected in hotplug locking\n");
> -			WARN_ON(1);
> -			warnings--;
> -		}
> -		recursive_depth++;

i nominate it for a 2.6.24 merge due to it fixing the above regression. 
I've seen regular instances of the "Lukewarm IQ" message.

	Ingo
