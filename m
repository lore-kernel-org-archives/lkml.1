Return-Path: <linux-kernel-owner+w=401wt.eu-S1752677AbYADNBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbYADNBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 08:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbYADNBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 08:01:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37859 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbYADNBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 08:01:43 -0500
Date: Fri, 4 Jan 2008 13:54:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Improve hackbench
Message-ID: <20080104125420.GA20981@elte.hu>
References: <1199426786.3298.64.camel@ymzhang> <20080104081043.GA23046@elte.hu> <477E1DC3.5020803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <477E1DC3.5020803@gmail.com>
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


* Török Edwin <edwintorok@gmail.com> wrote:

> On x86-64 there's a bug [*], that causes hackbench to segfault when
> compiled with optimizations:
> in reap_worker():
>     int status;
> ...
>     pthread_join(id, (void **)(void *)&status);
> 
> That is not correct, sizeof(void*) > sizeof(int) on x86-64.
> Something gets overwritten on the stack, I tried with gcc
> -fstack-protector, but it doesn't detect it !?
> After applying the patch, it no longer segfaults.
> 
> This patch fixes it:
> --- hackbench.c 2008-01-04 10:08:26.000000000 +0200
> +++ ../hackbench.c      2008-01-04 13:45:22.000000000 +0200
> @@ -241,8 +241,10 @@
>                 wait(&status);
>                 if (!WIFEXITED(status))
>                         exit(1);
> -       } else
> -               pthread_join(id, (void **)(void *)&status);
> +       } else {
> +               void* status;
> +               pthread_join(id, (void **)&status);
> +       }
>  }

thanks, applied & updated the file.

	Ingo
