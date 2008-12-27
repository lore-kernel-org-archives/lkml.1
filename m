Return-Path: <linux-kernel-owner+w=401wt.eu-S1754418AbYL0Kb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbYL0Kb6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 05:31:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbYL0Kbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 05:31:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49966 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbYL0Kbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 05:31:49 -0500
Date: Sat, 27 Dec 2008 11:31:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: reboot.c declare port_cf9_safe before they get
	used
Message-ID: <20081227103141.GF14639@elte.hu>
References: <1230049288.14358.4.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230049288.14358.4.camel@jaswinder.satnam>
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


* Jaswinder Singh <jaswinder@infradead.org> wrote:

> Impact: cleanup, avoid sparse warning
> 
> Include "../pci/pci.h" for port_cf9_safe
> 
> Fixes this sparse warning:
> arch/x86/kernel/reboot.c:43:6: warning: symbol 'port_cf9_safe' was not declared. Should it be static?
> 
> Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
> ---
>  arch/x86/kernel/reboot.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

applied to tip/x86/cleanups, thanks!

btw., this is ugly now:

> --- a/arch/x86/kernel/reboot.c
> +++ b/arch/x86/kernel/reboot.c
> @@ -22,6 +22,7 @@
>  #endif
>  
>  #include <mach_ipi.h>
> +#include "../pci/pci.h"

could you send another patch that moves arch/x86/pci/pci.h to 
arch/x86/include/asm/pci_x86.h (and update all the pci.h include sites)?

	Ingo
