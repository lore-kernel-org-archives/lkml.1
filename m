Return-Path: <linux-kernel-owner+w=401wt.eu-S1422669AbXCGJmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422669AbXCGJmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 04:42:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422682AbXCGJmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 04:42:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35104 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422669AbXCGJmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 04:42:31 -0500
Date: Wed, 7 Mar 2007 09:42:29 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Deepak Saxena <dsaxena@plexity.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix building kernel under Solaris
Message-ID: <20070307094229.GG14863@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Deepak Saxena <dsaxena@plexity.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070306180940.GA3240@plexity.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306180940.GA3240@plexity.net>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2007 at 10:09:40AM -0800, Deepak Saxena wrote:
> @@ -16,8 +16,10 @@
>  #include <sys/time.h>
>  #include <sys/ioctl.h>
>  #include <sys/types.h>
> +#ifndef __sun__
>  #include <asm/types.h>
>  #endif
> +#endif

So if solaris doesn't need it, why do we need it on Linux?

> +/*
> + * Solaris does not strsep
> + */
> +#ifndef __sun__
>  	while ((fname = strsep(&sources, " ")) != NULL) {
>  		if (!*fname)
>  			continue;
> +#else
> +	for (fname = strtok(sources, " "); fname; fname = strtok(NULL, " ")) {
> +#endif
>  		if (!parse_source_files(fname, &md))
>  			goto release;
>  	}

Please either provide a strsep for solaris, or use strtok unconditionally.
ut this ifdef mess is not acceptable.

>
