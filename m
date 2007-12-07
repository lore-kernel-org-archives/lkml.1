Return-Path: <linux-kernel-owner+w=401wt.eu-S1755974AbXLGPGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbXLGPGd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 10:06:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbXLGPGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 10:06:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34493 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbXLGPGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 10:06:22 -0500
Date: Fri, 7 Dec 2007 16:05:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Bob Tracy <rct@frus.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mcree@orcon.net.nz,
       linux-kernel@vger.kernel.org, rjw@sisk.pl, rth@twiddle.net,
       ink@jurassic.park.msu.ru, linux-scsi@vger.kernel.org,
       kay.sievers@vrfy.org, greg@kroah.com
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
Message-ID: <20071207150549.GA24254@elte.hu>
References: <20071207022646.373c92f5.akpm@linux-foundation.org> <20071207145526.B561CDBA2@gherkin.frus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071207145526.B561CDBA2@gherkin.frus.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.3 required=5.9 tests=BAYES_00,SUBJECT_FUZZY_TION autolearn=no SpamAssassin version=3.2.3
	0.2 SUBJECT_FUZZY_TION     Attempt to obfuscate words in Subject:
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bob Tracy <rct@frus.com> wrote:

> > Current state of the source tree is the 6f37ac... version, so I'll 
> > start backing out the above diffs in related groups and continue 
> > until I've got a working kernel.  For lack of an obvious target, 
> > I'll start with the seemingly innocuous change to sysctl_check.c.  
> > I'll report back when I've got something.
> 
> That was quick :-).  Backing out the sysctl_check.c diff gives me a 
> working kernel.  Beats the #$%@! out of me how/why, though.
> 
> Michael Cree: could you try backing out the diff below from your 
> 2.6.24-rc3 tree and see if things are now working for you?
> 
> Here's "uname -a", just to confirm (maybe) I'm running on what I say 
> works:
> 
> Linux smirkin 2.6.24-rc2-g6f37ac79-dirty #2 Fri Dec 7 08:03:12 CST 2007 alpha
> 
> Here's the diff I backed out (patch -R).  It's short...
> 
> diff --git a/kernel/sysctl_check.c b/kernel/sysctl_check.c
> index 5a2f2b2..4abc6d2 100644
> --- a/kernel/sysctl_check.c
> +++ b/kernel/sysctl_check.c
> @@ -738,7 +738,7 @@ static struct trans_ctl_table trans_net_table[] = {
>  	{ NET_ROSE,		"rose",		trans_net_rose_table },
>  	{ NET_IPV6,		"ipv6",		trans_net_ipv6_table },
>  	{ NET_X25,		"x25",		trans_net_x25_table },
> -	{ NET_TR,		"tr",		trans_net_tr_table },
> +	{ NET_TR,		"token-ring",	trans_net_tr_table },
>  	{ NET_DECNET,		"decnet",	trans_net_decnet_table },
>  	/*  NET_ECONET not used */
>  	{ NET_SCTP,		"sctp",		trans_net_sctp_table },

reverting this makes the kernel image shorter by 8 bytes - so perhaps 
some alignment issue somewhere? Or something gets overflown? Does any of 
this get actually used by your bootup?

	Ingo
