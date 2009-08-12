Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbZHLSm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbZHLSm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 14:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbZHLSm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 14:42:28 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:35506 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816AbZHLSm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 14:42:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xcjlnvNHjsT3mUcI9n1GaVTlUupCdE8G2CY4EiA9TVMzMjutsEBk9AgBJNHAas9P6z
         VXgeFYc1meGPQSVUZnwnIhofqsggXWepj3KzG+JB027zJv8EOlKb0yLgjD9tFflrC3/Y
         Gdaj/ySIFPIIL4c6LQbdeIlZ1dg+jAoGxCDsw=
Date: Wed, 12 Aug 2009 20:42:24 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip 1/1] perf list: use the pager
Message-ID: <20090812184221.GA5974@nowhere>
References: <20090811192211.GG18061@ghostprotocols.net> <20090811200436.GA3478@ghostprotocols.net> <20090812174459.GB3495@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090812174459.GB3495@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 02:44:59PM -0300, Arnaldo Carvalho de Melo wrote:
> When /sys/kernel/debug is mounted the list is imense, so use the pager
> like the other tools.
> 
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>


Ah, the integration of syscalls tracepoints made the list huge
and I tried to figure out a way to set something like that.

I didn't know it was so simple :-)


> 
> diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
> index f990fa8..d88c696 100644
> --- a/tools/perf/builtin-list.c
> +++ b/tools/perf/builtin-list.c
> @@ -10,11 +10,12 @@
>  
>  #include "perf.h"
>  
> -#include "util/parse-options.h"
>  #include "util/parse-events.h"
> +#include "util/cache.h"
>  
>  int cmd_list(int argc __used, const char **argv __used, const char *prefix __used)
>  {
> +	setup_pager();
>  	print_events();
>  	return 0;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

