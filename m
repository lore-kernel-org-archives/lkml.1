Return-Path: <linux-kernel-owner+w=401wt.eu-S1756761AbYFWKnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbYFWKnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 06:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbYFWKnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 06:43:15 -0400
Received: from gate.crashing.org ([63.228.1.57]:34028 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507AbYFWKnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 06:43:14 -0400
Subject: Re: [patch] x86 supports NO_IRQ convention
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, hpa@zytor.com
In-Reply-To: <200806221953.18849.david-b@pacbell.net>
References: <200806221953.18849.david-b@pacbell.net>
Content-Type: text/plain
Date: Mon, 23 Jun 2008 20:42:31 +1000
Message-Id: <1214217751.8011.262.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-06-22 at 19:53 -0700, David Brownell wrote:
> Hmm, x86 doesn't seem to support the NO_IRQ convention.  This means
> that portable code can't use it.  Which in turn means that there's
> no portable way for drivers to know whether they have been handed a
> valid IRQ number (zero usually being valid).  Double-plus ungood.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
> I suspect this has been discussed before, but I can't find any
> written resolution ...
> 
>  include/asm-x86/irq.h |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> --- a/include/asm-x86/irq.h	2008-06-22 16:36:43.000000000 -0700
> +++ b/include/asm-x86/irq.h	2008-06-22 16:37:06.000000000 -0700
> @@ -3,3 +3,7 @@
>  #else
>  # include "irq_64.h"
>  #endif
> +
> +#ifndef NO_IRQ
> +#define NO_IRQ	((unsigned int)(-1))
> +#endif

NO_IRQ on x86 is 0

In fact, we explicitely changed powerpc to do the same :-) (It became
easy after I made all linux irqs be virtual, and dynamically mapped to
physical numbers).

I think Linus wants everybody to follow...

Cheers,
Ben.

