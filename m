Return-Path: <linux-kernel-owner+w=401wt.eu-S1759137AbZDFWNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759137AbZDFWNB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 18:13:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755139AbZDFWMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 18:12:50 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:52851 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbZDFWMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 18:12:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=JfbOphe7xUpTTWGt6Wf1oJf7vvrZEDt6aZJOGugDn7a3ytRO8A1Gc6OwNwtK4xmi3x
         L4rzRlv1guQHUrzESo0TfaCtIEDARHF5ob4dETRWE29S+taXHZ+oWRnBuZLHM9j/XZdH
         6ktJunKYX+PtesEe7xJX8+b1qe3Gy6j2IjRgU=
Date: Tue, 7 Apr 2009 00:12:42 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tony Luck <tony.luck@intel.com>
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
Subject: Re: [PATCH 1/2 v2] tracing/syscalls: core infrastructure for
	syscalls tracing
Message-ID: <20090406221242.GB5936@nowhere>
References: <1236955332-10133-1-git-send-email-fweisbec@gmail.com> <1236955332-10133-2-git-send-email-fweisbec@gmail.com> <12c511ca0904061455k3f8a9cc8r25b7930f257ed922@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <12c511ca0904061455k3f8a9cc8r25b7930f257ed922@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 06, 2009 at 02:55:55PM -0700, Tony Luck wrote:
> On Fri, Mar 13, 2009 at 7:42 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> > index ab1d772..dfe2a44 100644
> > --- a/include/linux/syscalls.h
> > +++ b/include/linux/syscalls.h
> > @@ -66,6 +66,7 @@ struct perf_counter_hw_event;
> >  #include <asm/signal.h>
> >  #include <linux/quota.h>
> >  #include <linux/key.h>
> > +#include <linux/ftrace.h>
> 
> This causes some unpleasantness in the ia64 build with CONFIG_IA32_SUPPORT=y
> 
>   CC      arch/ia64/ia32/sys_ia32.o
> In file included from arch/ia64/ia32/sys_ia32.c:55:
> arch/ia64/ia32/ia32priv.h:290:1: warning: "elf_check_arch" redefined
> In file included from include/linux/elf.h:7,
>                  from include/linux/module.h:14,
>                  from include/linux/ftrace.h:8,
>                  from include/linux/syscalls.h:68,
>                  from arch/ia64/ia32/sys_ia32.c:18:
> /home/aegl/generic-smp/arch/ia64/include/asm/elf.h:19:1: warning: this
> is the location of the previous definition
> In file included from arch/ia64/ia32/sys_ia32.c:55:
> arch/ia64/ia32/ia32priv.h:295:1: warning: "ELF_CLASS" redefined
> In file included from include/linux/elf.h:7,
>                  from include/linux/module.h:14,
>                  from include/linux/ftrace.h:8,
>                  from include/linux/syscalls.h:68,
>                  from arch/ia64/ia32/sys_ia32.c:18:
> 
> and lots more like this.  Suddenly having elf.h included in a lot of
> the ia32 compat
> files is the root problem.
> 
> What does syscalls.h really need to pull in at this point ... is there
> a way for it to get it without pulling in so much extra stuff?


Ah, I see. I wondered somewhat when I included ftrace.h from syscall.h,
I didn't know why it stressed me but now I understand :-)

Though this is weird that both ia32 and ia64 definitions are allowed to be
included like that.

Anyway, I will put the syscalls tracing headers to a separate file to fix
that, thanks for reporting this!

Frederic.


> -Tony

