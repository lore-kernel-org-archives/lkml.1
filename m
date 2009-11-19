Return-Path: <linux-kernel-owner+w=401wt.eu-S932362AbZKSDC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362AbZKSDC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 22:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932298AbZKSDC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 22:02:58 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:58920 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295AbZKSDC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 22:02:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oB2OxbPpLCeYefoxNtUyJFxiKBaid+77dsvEKXBM1aMCBzvM8inLLeFSSpZdn5QxhW
         gDwO6JEuwMQXoU1EqAt4OoSNzy0HdnfIDOibiR69cDc+UeQHrotncn6wkpmM63HhO7wX
         iaPud4Pe4QBNMPuJq6syAyz3VJWsSge3SP4tI=
Date: Thu, 19 Nov 2009 04:03:03 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Aristeu Rozanski <aris@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: build ftrace.o when CONFIG_FTRACE_SYSCALLS is
	set for s390
Message-ID: <20091119030302.GB4970@nowhere>
References: <20091118204044.GR3441@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091118204044.GR3441@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 03:40:44PM -0500, Aristeu Rozanski wrote:
> Trying to build a s390x kernel with CONFIG_FTRACE_SYSCALLS will fail
> because ftrace.o is not built/linked.
> 
> Signed-off-by: Aristeu Rozanski <aris@redhat.com>
> 
> ---
>  arch/s390/kernel/Makefile |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linus-2.6.orig/arch/s390/kernel/Makefile	2009-10-30 17:49:10.000000000 -0400
> +++ linus-2.6/arch/s390/kernel/Makefile	2009-11-18 15:39:52.000000000 -0500
> @@ -44,6 +44,7 @@ obj-$(CONFIG_KPROBES)		+= kprobes.o
>  obj-$(CONFIG_FUNCTION_TRACER)	+= $(if $(CONFIG_64BIT),mcount64.o,mcount.o)
>  obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
>  obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += ftrace.o
> +obj-$(CONFIG_FTRACE_SYSCALLS)	+= ftrace.o
>  
>  # Kexec part
>  S390_KEXEC_OBJS := machine_kexec.o crash.o
> 


Thanks!

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

We probably want this patch for .32
Not sure in which tree it best fits though, -tip or s390?
(Adding more people in Cc).

