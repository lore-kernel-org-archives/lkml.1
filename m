Return-Path: <linux-kernel-owner+w=401wt.eu-S1757710AbZFVPet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710AbZFVPet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbZFVPej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:34:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49419 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbZFVPei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:34:38 -0400
Date: Mon, 22 Jun 2009 17:34:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roel Kluin <roel.kluin@gmail.com>, git@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] tools: fread does not return negative on error
Message-ID: <20090622153431.GA18466@elte.hu>
References: <4A3FB09D.9050903@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A3FB09D.9050903@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0300]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Roel Kluin <roel.kluin@gmail.com> wrote:

> size_t res cannot be less than 0. fread returns 0 on error.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Is this correct? please review.
> 
> diff --git a/tools/perf/util/strbuf.c b/tools/perf/util/strbuf.c
> index eaba093..376a337 100644
> --- a/tools/perf/util/strbuf.c
> +++ b/tools/perf/util/strbuf.c
> @@ -259,7 +259,7 @@ size_t strbuf_fread(struct strbuf *sb, size_t size, FILE *f)
>  	res = fread(sb->buf + sb->len, 1, size, f);
>  	if (res > 0)
>  		strbuf_setlen(sb, sb->len + res);
> -	else if (res < 0 && oldalloc == 0)
> +	else if (res == 0 && oldalloc == 0)
>  		strbuf_release(sb);
>  	return res;

This comes straight from Git's strbuf.c so i've Cc:-ed the Git list.

Roel, did you get some compiler warning that made you look at this 
code?

	Ingo
