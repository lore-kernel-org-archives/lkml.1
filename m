Return-Path: <linux-kernel-owner+w=401wt.eu-S1757600AbYJWQbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600AbYJWQbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 12:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbYJWQb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 12:31:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:2142 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728AbYJWQbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 12:31:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jt/+3R4qmYrEjJZHiP86Nyv0OXAitdixNuf8XzzjvTRoZdtn7uCujnKdbr3ZOWs/dk
         nLHHOqbj0USe0g65n85v6kPVzZdRNUV/JXso64n5tyTewTsXxl2GTepS1ITQ+7WNZs2w
         rUH1mYnksqfuAJZF1pxKSqnqm78djm/3wivv8=
Date: Thu, 23 Oct 2008 20:34:33 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Geert Uytterhoeven <geert@linux-m68k.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] tracing: fix a build error on alpha and m68k
Message-ID: <20081023163433.GA3160@x200.localdomain>
References: <20081023213637.eff9b414.sfr@canb.auug.org.au> <20081023121145.GB27984@x200.localdomain> <c62985530810230548t1b569f61g34d1900bb94fde83@mail.gmail.com> <c62985530810230615s3252a54ao6488e763d72dc939@mail.gmail.com> <49008D12.5090204@gmail.com> <Pine.LNX.4.64.0810231635440.18978@anakin> <c62985530810230757r411b4e3dj4ecec649cf8cf0b3@mail.gmail.com> <Pine.LNX.4.64.0810231727430.18978@anakin> <4900B414.7090002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4900B414.7090002@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 07:27:48PM +0200, Frederic Weisbecker wrote:
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

Sure, except it doesn't fix anything.
