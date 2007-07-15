Return-Path: <linux-kernel-owner+w=401wt.eu-S1757970AbXGOVlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970AbXGOVlU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 17:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbXGOVlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 17:41:10 -0400
Received: from gate.crashing.org ([63.228.1.57]:40046 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533AbXGOVlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 17:41:09 -0400
Subject: Re: [PATCH] the wrong variable checked after request_irq()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <E1IAAFp-00053g-Ti@ZenIV.linux.org.uk>
References: <E1IAAFp-00053g-Ti@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Mon, 16 Jul 2007 07:40:38 +1000
Message-Id: <1184535638.25235.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-15 at 20:59 +0100, Al Viro wrote:
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Out of curiosity, how did you pick it up ? You have some automated tool
to catch that (or sparse changes) or you just did -lots- of code
inspection ?

Cheers,
Ben.

> ---
>  arch/powerpc/platforms/pseries/setup.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
> index 470db6e..a031d99 100644
> --- a/arch/powerpc/platforms/pseries/setup.c
> +++ b/arch/powerpc/platforms/pseries/setup.c
> @@ -176,7 +176,7 @@ static void __init pseries_mpic_init_IRQ(void)
>  		return;
>  
>  	cascade_irq = irq_of_parse_and_map(cascade, 0);
> -	if (cascade == NO_IRQ) {
> +	if (cascade_irq == NO_IRQ) {
>  		printk(KERN_ERR "mpic: failed to map cascade interrupt");
>  		return;
>  	}

