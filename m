Return-Path: <linux-kernel-owner+w=401wt.eu-S1758577AbYJWSbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577AbYJWSbl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 14:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756411AbYJWSbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 14:31:33 -0400
Received: from qb-out-0506.google.com ([72.14.204.236]:38810 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287AbYJWSbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 14:31:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oFYmalqOLZFKbtcCXf9vF0K/1DiB6zWOkZY555KpQ0LCu723XlAX8jxezcCz50nnAr
         oXuMgPjpK7go9II4H3t37AuCDfHKZAiO1NqMBEoU22ggxb7JJ46TLnlr/eYahhfjdfY7
         blyYqNYmHBhw2RrnyrCOURG9YyHpXEKwqrXMc=
Message-ID: <c62985530810230924q7f5bd48es3353428766ee49eb@mail.gmail.com>
Date: Thu, 23 Oct 2008 18:24:14 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] tracing: fix a build error on alpha and m68k
Cc: "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Steven Rostedt" <rostedt@goodmis.org>
In-Reply-To: <4900B414.7090002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081023213637.eff9b414.sfr@canb.auug.org.au>
	 <20081023121145.GB27984@x200.localdomain>
	 <c62985530810230548t1b569f61g34d1900bb94fde83@mail.gmail.com>
	 <c62985530810230615s3252a54ao6488e763d72dc939@mail.gmail.com>
	 <49008D12.5090204@gmail.com>
	 <Pine.LNX.4.64.0810231635440.18978@anakin>
	 <c62985530810230757r411b4e3dj4ecec649cf8cf0b3@mail.gmail.com>
	 <Pine.LNX.4.64.0810231727430.18978@anakin>
	 <4900B414.7090002@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/23 Frederic Weisbecker <fweisbec@gmail.com>:
> When tracing is enabled, some arch have included <linux/irqflags.h>
> on their <asm/system.h> but others like alpha or m68k don't.
>
> Build error on alpha:
>
> kernel/trace/trace.c: In function 'tracing_generic_entry_update':
> kernel/trace/trace.c:658: error: implicit declaration of function 'irqs_disabled_flags'
> kernel/trace/trace.c: In function 'tracing_cpumask_write':
> kernel/trace/trace.c:2145: error: implicit declaration of function 'raw_local_irq_disable'
> kernel/trace/trace.c:2162: error: implicit declaration of function 'raw_local_irq_enable'
> kernel/trace/trace.c: In function 'trace_die_handler':
> kernel/trace/trace.c:3039: error: 'DIE_OOPS' undeclared (first use in this function)
>
> Build error on m68k:
> http://kisskb.ellerman.id.au/kisskb/buildresult/50641/
>
>
> Include it on kernel/trace/trace.c
>
> Reported-by: Alexey Dobriyan <adobriyan@gmail.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 78d5661..deb9684 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -34,6 +34,7 @@
>
>  #include <linux/stacktrace.h>
>  #include <linux/ring_buffer.h>
> +#include <linux/irqflags.h>
>
>  #include "trace.h"
>
>

And one other "reported by" for the m68k error:

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
