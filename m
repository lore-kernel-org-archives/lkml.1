Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbYJWMsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbYJWMsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 08:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbYJWMsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 08:48:20 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:27392 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbYJWMsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 08:48:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=crpJUGSA6elR6/chzrr2qmDfW/GWpLU/EaEpRqHDnuevr6GjLumYv6D9vPQibVijDV
         sVvUt941oEfMPjtplzs2DH/tyQjC7wdGwnnhkaT3Jo6Zz9E/29MLP2XUqi/WSI2ROqf4
         l3eup0rVSX/iSP2S/YtP5Je90OzeyBTiq1x6c=
Message-ID: <c62985530810230548t1b569f61g34d1900bb94fde83@mail.gmail.com>
Date: Thu, 23 Oct 2008 14:48:15 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: linux-next: kernel/trace/trace.c:658: error:
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081023121145.GB27984@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081023213637.eff9b414.sfr@canb.auug.org.au>
	 <20081023121145.GB27984@x200.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/23 Alexey Dobriyan <adobriyan@gmail.com>:
> On alpha-smp-n-debug-y:
>
> kernel/trace/trace.c: In function 'tracing_generic_entry_update':
> kernel/trace/trace.c:658: error: implicit declaration of function 'irqs_disabled_flags'
> kernel/trace/trace.c: In function 'tracing_cpumask_write':
> kernel/trace/trace.c:2145: error: implicit declaration of function 'raw_local_irq_disable'
> kernel/trace/trace.c:2162: error: implicit declaration of function 'raw_local_irq_enable'
> kernel/trace/trace.c: In function 'trace_die_handler':
> kernel/trace/trace.c:3039: error: 'DIE_OOPS' undeclared (first use in this function)
>
> This has something with config dependencies, because adding include doesn't fix it.
>

A lot of arch have an asm/irqflags.h but not alpha.
In linux/irqflags, raw_local_irq_* functions are defined to be
local_irq_* function if they don't support
CONFIG_TRACE_IRQFLAGS_SUPPORT.
It seems the error is here, alpha may turn this option off.
