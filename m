Return-Path: <linux-kernel-owner+w=401wt.eu-S1751691AbZLBFvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbZLBFvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 00:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbZLBFvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 00:51:17 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:41918 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbZLBFvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 00:51:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nKsZ5FEh1jo8KrrJXZdWqj5H7uc7KmxBNN8dxRtooOl3bX8LIwv6ukyQNPHlEffwqn
         EtOTzN/dPiM3RNvbUefKqB/YySWP8YPXoNCjTEbS60GFo16cgWRiYx/dyTVQyWmtiasN
         1aCVFm7mdLe45XuOCl3v8KkL13zqKKQmiAhEc=
Date: Wed, 2 Dec 2009 06:51:21 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Wang Liming <liming.wang@windriver.com>
Cc: mingo@redhat.com, peterz@infradead.org, mhiramat@redhat.com,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org, jbaron@redhat.com,
       fche@redhat.com, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com
Subject: Re: [tip:perf/core] perf probe: Add argv_split() from
	lib/argv_split.c
Message-ID: <20091202055119.GA5719@nowhere>
References: <20091201002005.10235.55602.stgit@harusame> <tip-e1c01d61a98703fcc80d15b8068ec36d5a215f7e@git.kernel.org> <4B15FED8.2080108@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B15FED8.2080108@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 01:44:56PM +0800, Wang Liming wrote:
> When I compiled "perf", I encountered following error:
>
>     CC util/string.o
> cc1: warnings being treated as errors
> util/string.c: In function 'argv_split':
> util/string.c:216: warning: implicit declaration of function 'strndup'
> util/string.c:216: warning: incompatible implicit declaration of built-in 
> function 'strndup'
> make: *** [util/string.o] Error 1
>
> Do we need to define _GNU_SOURCE in the head? Or maybe I used rather old 
> glibc version.
>
> diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
> index 0977cf4..ea3eb39 100644
> --- a/tools/perf/util/string.c
> +++ b/tools/perf/util/string.c
> @@ -1,5 +1,8 @@
> +#define _GNU_SOURCE
>  #include <string.h>
>  #include <stdlib.h>
> +
> +#undef _GNU_SOURCE
>  #include "string.h"
>  #include "util.h"



Right, strndup is a GNU extension.
Could you please resend this patch with your signed-off-by
and a proper changelog?

Thanks!

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

