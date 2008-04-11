Return-Path: <linux-kernel-owner+w=401wt.eu-S1759171AbYDKHrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759171AbYDKHrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 03:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757475AbYDKHq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 03:46:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52312 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757394AbYDKHq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 03:46:58 -0400
Date: Fri, 11 Apr 2008 09:46:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, mingo <mingo@redhat.com>,
       tglx <tglx@linutronix.de>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 10 (arch/x86)
Message-ID: <20080411074631.GB6410@elte.hu>
References: <20080410181404.b76939a6.sfr@canb.auug.org.au> <20080410150950.5913b16a.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080410150950.5913b16a.randy.dunlap@oracle.com>
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


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> Fix printk formats in x86/mm/ioremap.c:
> 
> next-20080410/arch/x86/mm/ioremap.c:137: warning: format '%llx' expects type 'long long unsigned int', but argument 2 has type 'resource_size_t'
> next-20080410/arch/x86/mm/ioremap.c:188: warning: format '%llx' expects type 'long long unsigned int', but argument 2 has type 'resource_size_t'
> next-20080410/arch/x86/mm/ioremap.c:188: warning: format '%llx' expects type 'long long unsigned int', but argument 3 has type 'long unsigned int'

thanks, applied.

>  	if (!phys_addr_valid(phys_addr)) {
>  		printk(KERN_WARNING "ioremap: invalid physical address %llx\n",
> -		       phys_addr);
> +		       (unsigned long long)phys_addr);

is there really no way to solve this more cleanly than a forced cast? It 
is a totally uninteresting warning that we pass in a narrower type to 
printk(). It cannot ever cause any bugs or problems. Why does gcc warn 
about it?

	Ingo
