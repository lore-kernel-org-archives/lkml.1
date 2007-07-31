Return-Path: <linux-kernel-owner+w=401wt.eu-S933458AbXGaQ4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933458AbXGaQ4u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765429AbXGaQ4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:56:38 -0400
Received: from gw.goop.org ([64.81.55.164]:38323 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761181AbXGaQ4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:56:37 -0400
Message-ID: <46AF69C3.1040900@goop.org>
Date: Tue, 31 Jul 2007 09:56:35 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] argv_split: allow argv_split to handle NULL pointer in
 argcp parameter gracefully
References: <20070731164608.GB28333@hmsreliant.homelinux.net>
In-Reply-To: <20070731164608.GB28333@hmsreliant.homelinux.net>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman wrote:
> As Jeremy and I had discussed in a previous thread, it would be nice if the
> argv_split library function could gracefully handle a NULL pointer in the argcp
> parameter, so as to allow functions using it that did not care about the value
> of argc to not have to declare a useless variable.  This patch accomplishes
> that.  Tested by me, with successful results.
>   

Oh, one other thing.  Could you do a patch to clean up the use in the
usermodehelper code?

    J
> Thanks & Regards
> Neil
>
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
>
>
>  argv_split.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
>
> diff --git a/lib/argv_split.c b/lib/argv_split.c
> index 4096ed4..fad6ce4 100644
> --- a/lib/argv_split.c
> +++ b/lib/argv_split.c
> @@ -75,7 +75,9 @@ char **argv_split(gfp_t gfp, const char *str, int *argcp)
>  	if (argv == NULL)
>  		goto out;
>  
> -	*argcp = argc;
> +	if (argcp)
> +		*argcp = argc;
> +
>  	argvp = argv;
>  
>  	while (*str) {
>   

