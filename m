Return-Path: <linux-kernel-owner+w=401wt.eu-S934510AbXFGRWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934510AbXFGRWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 13:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933982AbXFGRWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 13:22:15 -0400
Received: from il.qumranet.com ([82.166.9.18]:44107 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933651AbXFGRWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 13:22:14 -0400
Message-ID: <46683EC4.4030604@qumranet.com>
Date: Thu, 07 Jun 2007 20:22:12 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Jan Glauber <jan.glauber@de.ibm.com>,
       David Miller <davem@davemloft.net>, akpm@osdl.org, mingo@elte.hu,
       ak@suse.de, schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org,
       Alan Cox <alan@redhat.com>
Subject: Re: [patch] i386/x86_64: smp_call_function locking inconsistency
References: <20070208203210.GB9798@osiris.ibm.com>	 <20070208.124328.88477956.davem@davemloft.net>	 <20070209084221.GA8259@osiris.boeblingen.de.ibm.com>	 <1171025838.5349.14.camel@localhost.localdomain>	 <a781481a0706070707j301ba886h10f4607fd6a6e8de@mail.gmail.com>	 <20070607162743.GA9433@osiris.ibm.com>	 <a781481a0706070954l636d752am82ef7ca9703788aa@mail.gmail.com> <a781481a0706071018t26e75c84jba5314dde3fc6019@mail.gmail.com>
In-Reply-To: <a781481a0706071018t26e75c84jba5314dde3fc6019@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Thu, 07 Jun 2007 20:22:12 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
>
> Oh wait, the on_one_cpu() patch proposes on UP:
>
> +static inline int on_one_cpu(int cpu, void (*func)(void *info), void
> *info,
> +                 int retry, int wait)
> +{
>
> /* this needs a if (cpu == 0) check here, IMO */
>
> +    local_irq_disable();
> +    func(info);
> +    local_irq_enable();
> +    return 0;
>
> /* else WARN and return -EINVAL; */
>
> +}
>
> which is broken without the suggested additions, IMHO
> (this is what got me into this in the first place). There
> _is_ a difference between on_each_cpu() and the
> smp_call_function* semantics (as discussed on the other
> thread -- gargh! my mistake for opening this discussion up
> on so many threads), and in its current form on_one_cpu()
> has quite confused semantics, trying to mix the two. I guess
> on_one_cpu() would be better off simply being just an
> atomic wrapper over smp_processor_id() and
> smp_call_function_single() (which is the *real* issue that
> needs solving in the first place), and do it well.
>

This is on UP, so (cpu == 0) is trivially true.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

