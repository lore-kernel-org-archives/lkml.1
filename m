Return-Path: <linux-kernel-owner+w=401wt.eu-S1752230AbZGROOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbZGROOb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 10:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbZGROO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 10:14:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57945 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbZGROO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 10:14:28 -0400
Date: Sat, 18 Jul 2009 16:13:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Subrata Modak <subrata@linux.vnet.ibm.com>
Cc: linux-laptop@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@redhat.com>, David Howells <dhowells@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/06] Fix compilation warning for
	arch/x86/kernel/apm_32.c
Message-ID: <20090718141322.GI32618@elte.hu>
References: <20090715022038.4374.74212.sendpatchset@subratamodak.linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090715022038.4374.74212.sendpatchset@subratamodak.linux.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Subrata Modak <subrata@linux.vnet.ibm.com> wrote:

> Following fix is inspired by David Howells fix few days back:
> http://lkml.org/lkml/2009/7/9/109,
> 
> Signed-off-by: Subrata Modak<subrata@linux.vnet.ibm.com>,
> ---
> 
> --- a/arch/x86/kernel/apm_32.c	2009-06-15 07:50:51.000000000 +0530
> +++ b/arch/x86/kernel/apm_32.c	2009-07-15 06:43:59.000000000 +0530
> @@ -811,7 +811,7 @@ static int apm_do_idle(void)
>  	u8 ret = 0;
>  	int idled = 0;
>  	int polling;
> -	int err;
> +	int uninitialized_var(err);

Please dont use uninitialized_var() as it's dangerous - in something 
as performance-uncritical as this we should initialize it to 0 and 
mention it in the changelog that this works around a GCC false 
positive warning.

Thanks,

	Ingo
