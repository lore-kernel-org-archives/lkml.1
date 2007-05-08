Return-Path: <linux-kernel-owner+w=401wt.eu-S968247AbXEHV5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968247AbXEHV5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032037AbXEHV5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:57:44 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:11768 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966726AbXEHV5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:57:43 -0400
Date: Tue, 8 May 2007 14:59:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch 2/4] add argv_split()
Message-Id: <20070508145902.fec4884d.randy.dunlap@oracle.com>
In-Reply-To: <20070508205517.142888645@goop.org>
References: <20070508205129.064843364@goop.org>
	<20070508205517.142888645@goop.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 May 2007 13:51:31 -0700 Jeremy Fitzhardinge wrote:

> --- /dev/null
> +++ b/lib/argv_split.c
> @@ -0,0 +1,160 @@
> +
> +static const char *skip_sep(const char *cp)
> +{
> +	while(*cp && isspace(*cp))

Kernel style is space after "while", "for", "if"...

> +		cp++;
> +
> +	return cp;
> +}
> +
> +static const char *skip_arg(const char *cp)
> +{
> +	while(*cp && !isspace(*cp))
> +		cp++;
> +
> +	return cp;
> +}
> +
> +static int count_argc(const char *str)
> +{
> +	int count = 0;
> +
> +	while(*str) {
> +		str = skip_sep(str);
> +		if (*str) {
> +			count++;
> +			str = skip_arg(str);
> +		}
> +	}
> +
> +	return count;
> +}
> +
> +/**
> + * argv_free - free an argv
> + *

no blank "*" line.

> + * @argv - the argument vector to be freed

    * @argv: the argument vector to be freed


> + *
> + * Frees an argv and the strings it points to.
> + */
> +void argv_free(char **argv)
> +{
> +	char **p;
> +	for(p = argv; *p; p++)
> +		kfree(*p);
> +
> +	kfree(argv);
> +}
> +EXPORT_SYMBOL(argv_free);


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
