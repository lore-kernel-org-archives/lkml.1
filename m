Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbZEKPma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbZEKPma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754430AbZEKPmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:42:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43437 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205AbZEKPmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:42:18 -0400
Date: Mon, 11 May 2009 17:42:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/xen] x86: use flush_tlb_others to implement
	flush_tlb_all, fix
Message-ID: <20090511154202.GA31655@elte.hu>
References: <1241797927.15972.51.camel@zakaz.uk.xensource.com> <tip-636afdbe85d50d9b88f5283b5e6d0f8518431aac@git.kernel.org> <20090511131230.GA32693@elte.hu> <1242054041.29990.88.camel@zakaz.uk.xensource.com> <20090511151151.GA3267@elte.hu> <1242056394.29990.94.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242056394.29990.94.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ian Campbell <Ian.Campbell@eu.citrix.com> wrote:

> in any case I would guess that the fix is:
> 
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -87,6 +87,7 @@
>  #include <asm/cacheflush.h>
>  #include <asm/processor.h>
>  #include <asm/bugs.h>
> +#include <asm/tlbflush.h>
>  
>  #include <asm/system.h>
>  #include <asm/vsyscall.h>

Guessing is not enough - please review the prototype position. Is it 
available on all configs? It is not ...

But even the proper fix runs into that smp_processor_id() bug i just 
posted.

	Ingo
