Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbYIYOew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbYIYOew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 10:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbYIYOeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 10:34:44 -0400
Received: from qb-out-0506.google.com ([72.14.204.238]:12097 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbYIYOen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 10:34:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=k9vyE0jtZZlnBVE9PZJa+XWJWyqyexknFu89wFuY5o4J7VvrnqmGknsL9gH7TVc5Di
         UEaodl4HTPsYpr9AE07p6BH2tGeiPPpDG+80ZDtavJiLaXly41r6y847ei1VL01Ji0bI
         FtaRt7JmglvDlQkc5nJtT/JJdQ+A2UZSJqpKY=
Date: Thu, 25 Sep 2008 17:34:35 +0300
From: Pekka Paalanen <pq@iki.fi>
To: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Patch -tip 3/3] Tracing/ftrace: Don't consume entries
 unhandled by mmiotrace
Message-ID: <20080925173435.5f525557@daedalus.pq.iki.fi>
In-Reply-To: <48DB8408.7080408@gmail.com>
References: <48DB8408.7080408@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2008 13:28:56 +0100
Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> When mmiotrace can't handle an entry output, it returns 1.
> It should return 0 to relay on other output functions.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
> diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
> index a108c32..6fe1315 100644
> --- a/kernel/trace/trace_mmiotrace.c
> +++ b/kernel/trace/trace_mmiotrace.c
> @@ -277,7 +277,8 @@ static int mmio_print_line(struct trace_iterator *iter)
>  	case TRACE_PRINT:
>  		return mmio_print_mark(iter);
>  	default:
> -		return 1; /* ignore unknown entries */
> +		return 0; /* ignore unknown entries whithout consuming */
>  	}
>  }

NACK.

mmiotrace's log output is stricly specified, the standard/default
printing functions may NOT be used. The output is supposed to be
machine readable in addition to human readable.

The ftrace infrastructure assumes there is only one active tracer
at a time, therefore destroying unhandled entries is not a problem.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
