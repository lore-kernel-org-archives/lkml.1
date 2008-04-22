Return-Path: <linux-kernel-owner+w=401wt.eu-S1759735AbYDVIej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759735AbYDVIej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 04:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756822AbYDVIeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 04:34:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48977 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140AbYDVIea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 04:34:30 -0400
Date: Tue, 22 Apr 2008 10:34:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Reuben Farrelly <reuben-linuxkernel@reub.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: StackProtector Oopses - Re: 2.6.25-mm1
Message-ID: <20080422083408.GB28970@elte.hu>
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org> <48089BDE.6040100@reub.net> <20080418133645.GF31797@elte.hu> <4808B4EF.8030901@reub.net> <20080421150604.GH5474@elte.hu> <20080421184859.48efcb67@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421184859.48efcb67@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> > yeah. Arjan - any new patches to try that might fix the bootup test?
> 
> I've looked at the disassembly and compared it to mine, and the gcc is 
> doing something... rather unexpected. The only thing I can think of is 
> the patch below, it should make it a ton more robust...

> -	memset(&foo, 0, 2*sizeof(foo)); /* deliberate buffer overflow */
> +	if (current->stack_canary == *(((unsigned long *)&foo)+1))
> +		*(((unsigned long *)&foo)+1) = 0;
> +	else
> +		printk(KERN_ERR "No -ftack-protector canary found\n");

ok, i queued this up. (with the typo that Valdis noticed fixed)

but ... this bug needs to be figured out, not worked around.

	Ingo
