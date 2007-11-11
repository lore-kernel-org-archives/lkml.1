Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486AbXKKOUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbXKKOUy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 09:20:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbXKKOUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 09:20:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60916 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819AbXKKOUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 09:20:46 -0500
Date: Sun, 11 Nov 2007 15:15:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ulrich Drepper <drepper@redhat.com>, Roland McGrath <roland@redhat.com>,
       "Andrew G. Morgan" <morgan@kernel.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Chris Wright <chrisw@sous-sol.org>, James Morris <jmorris@namei.org>,
       Serge Hallyn <serue@us.ibm.com>, Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH] kernel/capability.c get_task_comm compile error (MMOTM)
Message-ID: <20071111141510.GA29126@elte.hu>
References: <200711110101.lAB110LV017867@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711110101.lAB110LV017867@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.5.16 (2007-06-09)
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


* Erez Zadok <ezk@cs.sunysb.edu> wrote:

> Small patch below fixes compile error.

> +			char name[sizeof(current->comm)];
>  			warned++;
>  			printk(KERN_INFO
>  			       "warning: process `%s' sets w/ old libcap\n",
> -			       get_task_comm(current));
> +			       get_task_comm(name, current));

that's buggy - get_task_comm() returns void.

the proper fix would be to first do a get_task_comm() then pass in 
'name' as an argument to printk.

	Ingo
