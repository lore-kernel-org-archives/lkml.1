Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbYJWNPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbYJWNPU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 09:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbYJWNPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 09:15:05 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:40486 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbYJWNPE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 09:15:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MWF+Cn2XP+FMwy6rcVYrdwEaiEdZNI6YDuPZSnmds5CECPuGwDuZLHQxs6sVrwBzf8
         Qw6X6HnxIK2yZwzC0yotueP+blo8cNxq+31J+ZGoNzUPb51TfxfY8b0XSRpbUC835jEO
         +Vv1joXkfjIHcZs00wfqvNz+SUw8HFG5wN5BE=
Message-ID: <c62985530810230615s3252a54ao6488e763d72dc939@mail.gmail.com>
Date: Thu, 23 Oct 2008 15:15:01 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: linux-next: kernel/trace/trace.c:658: error:
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <c62985530810230548t1b569f61g34d1900bb94fde83@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20081023213637.eff9b414.sfr@canb.auug.org.au>
	 <20081023121145.GB27984@x200.localdomain>
	 <c62985530810230548t1b569f61g34d1900bb94fde83@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/23 Frédéric Weisbecker <fweisbec@gmail.com>:
> 2008/10/23 Alexey Dobriyan <adobriyan@gmail.com>:
>> On alpha-smp-n-debug-y:
>>
>> kernel/trace/trace.c: In function 'tracing_generic_entry_update':
>> kernel/trace/trace.c:658: error: implicit declaration of function 'irqs_disabled_flags'
>> kernel/trace/trace.c: In function 'tracing_cpumask_write':
>> kernel/trace/trace.c:2145: error: implicit declaration of function 'raw_local_irq_disable'
>> kernel/trace/trace.c:2162: error: implicit declaration of function 'raw_local_irq_enable'
>> kernel/trace/trace.c: In function 'trace_die_handler':
>> kernel/trace/trace.c:3039: error: 'DIE_OOPS' undeclared (first use in this function)
>>
>> This has something with config dependencies, because adding include doesn't fix it.
>>
>
> A lot of arch have an asm/irqflags.h but not alpha.
> In linux/irqflags, raw_local_irq_* functions are defined to be
> local_irq_* function if they don't support
> CONFIG_TRACE_IRQFLAGS_SUPPORT.
> It seems the error is here, alpha may turn this option off.
>

Hmm no actually your CONFIG_TRACE_IRFLAGS_SUPPORT is not set.
So that's because the linux/irqflags.h is not included in the
asm/system.h on alpha (other archs do).
