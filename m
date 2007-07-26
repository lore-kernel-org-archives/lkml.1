Return-Path: <linux-kernel-owner+w=401wt.eu-S935358AbXGZWD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935358AbXGZWD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 18:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932917AbXGZWDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 18:03:49 -0400
Received: from gw.goop.org ([64.81.55.164]:45636 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765653AbXGZWDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 18:03:48 -0400
Message-ID: <46A919EB.9060102@goop.org>
Date: Thu, 26 Jul 2007 15:02:19 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, wwoods@redhat.com
Subject: Re: [PATCH] core_pattern: Add ability for core_pattern to parse arguments
 when pattern is a pipe
References: <20070726173923.GA5701@hmsreliant.homelinux.net>
In-Reply-To: <20070726173923.GA5701@hmsreliant.homelinux.net>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman wrote:
> +static void free_argv_array(char **argv)
> +{
> +	int i;
> +	if (argv != NULL) {
> +		for (i = 0; argv[i] != NULL; i++)
> +			kfree(argv[i]);
> +		kfree(argv);
> +	}
> +
> +}
>   

I've helpfully already provided free_argv() in lib/argv_split.c.

> +
> +/*
> + * format_corename_argv will inspect the corename string, 	
> + * and for every option found after the binary name
> + * it will remove the option from the string, and place it
> + * in the argv array, that can then be passed to the 
> + * usermodehelper if core_pattern is a pipe
> + * Assumes that corename is declared on the stack of the caller
> + */
> +static char **format_corename_argv(char *corename)
> +{
>   

And it looks like this could be adapted to use argv_split() with a bit
of additional processing.

    J
