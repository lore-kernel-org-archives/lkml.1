Return-Path: <linux-kernel-owner+w=401wt.eu-S1761249AbZDFWCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761249AbZDFWCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 18:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760636AbZDFV4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:56:16 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:53235 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757278AbZDFV4O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:56:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=QindeIVsCGy1dpgVMjpDByQbLWUoHEhNn39bs4ysBIsXOiYaFQh1ZaE9rlICRt5Ztf
         9p75uYEzYgMM1X+Nful/IykF46o87xpLTnKZPvnUuDjjOnOJ6e3L55Rew7j+ACMbNuol
         UbKmzcSNzaDbFb8QBYtDQuvAv2LekpzbyIEvc=
MIME-Version: 1.0
In-Reply-To: <1236955332-10133-2-git-send-email-fweisbec@gmail.com>
References: <1236955332-10133-1-git-send-email-fweisbec@gmail.com>
	 <1236955332-10133-2-git-send-email-fweisbec@gmail.com>
Date: Mon, 6 Apr 2009 14:55:55 -0700
X-Google-Sender-Auth: d074d0747fab30f3
Message-ID: <12c511ca0904061455k3f8a9cc8r25b7930f257ed922@mail.gmail.com>
Subject: Re: [PATCH 1/2 v2] tracing/syscalls: core infrastructure for syscalls 
	tracing
From: Tony Luck <tony.luck@intel.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, tglx@linutronix.de,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>, Michael Davidson <md@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 7:42 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index ab1d772..dfe2a44 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -66,6 +66,7 @@ struct perf_counter_hw_event;
>  #include <asm/signal.h>
>  #include <linux/quota.h>
>  #include <linux/key.h>
> +#include <linux/ftrace.h>

This causes some unpleasantness in the ia64 build with CONFIG_IA32_SUPPORT=y

  CC      arch/ia64/ia32/sys_ia32.o
In file included from arch/ia64/ia32/sys_ia32.c:55:
arch/ia64/ia32/ia32priv.h:290:1: warning: "elf_check_arch" redefined
In file included from include/linux/elf.h:7,
                 from include/linux/module.h:14,
                 from include/linux/ftrace.h:8,
                 from include/linux/syscalls.h:68,
                 from arch/ia64/ia32/sys_ia32.c:18:
/home/aegl/generic-smp/arch/ia64/include/asm/elf.h:19:1: warning: this
is the location of the previous definition
In file included from arch/ia64/ia32/sys_ia32.c:55:
arch/ia64/ia32/ia32priv.h:295:1: warning: "ELF_CLASS" redefined
In file included from include/linux/elf.h:7,
                 from include/linux/module.h:14,
                 from include/linux/ftrace.h:8,
                 from include/linux/syscalls.h:68,
                 from arch/ia64/ia32/sys_ia32.c:18:

and lots more like this.  Suddenly having elf.h included in a lot of
the ia32 compat
files is the root problem.

What does syscalls.h really need to pull in at this point ... is there
a way for it to get it without pulling in so much extra stuff?

-Tony
