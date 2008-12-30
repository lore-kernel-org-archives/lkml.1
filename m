Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbYL3SM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbYL3SM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 13:12:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbYL3SMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 13:12:05 -0500
Received: from gate.crashing.org ([63.228.1.57]:41838 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561AbYL3SME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 13:12:04 -0500
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Message-Id: <3A41A734-8709-4AC6-ADFD-430D3C1E5DC8@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Julia Lawall <julia@diku.dk>
In-Reply-To: <Pine.LNX.4.64.0812212154240.3635@ask.diku.dk>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [PATCH 2/2] arch/powerpc/platforms/85xx: Add local_irq_restore in error handling code
Date: Tue, 30 Dec 2008 12:11:51 -0600
References: <Pine.LNX.4.64.0812212154240.3635@ask.diku.dk>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 21, 2008, at 2:54 PM, Julia Lawall wrote:

> From: Julia Lawall <julia@diku.dk>
>
> There is a call to local_irq_restore in the normal exit case, so it  
> would
> seem that there should be one on an error return as well.
>
> The semantic patch that makes this change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
>
> // <smpl>
> @@
> expression l;
> expression E,E1,E2;
> @@
>
> local_irq_save(l);
> ... when != local_irq_restore(l)
>    when != spin_unlock_irqrestore(E,l)
>    when any
>    when strict
> (
> if (...) { ... when != local_irq_restore(l)
>               when != spin_unlock_irqrestore(E1,l)
> +   local_irq_restore(l);
>    return ...;
> }
> |
> if (...)
> +   {local_irq_restore(l);
>    return ...;
> +   }
> |
> spin_unlock_irqrestore(E2,l);
> |
> local_irq_restore(l);
> )
> // </smpl>
>
> Signed-off-by: Julia Lawall <julia@diku.dk>
>
> ---
> arch/powerpc/platforms/85xx/smp.c |    1 +
> 1 file changed, 1 insertion(+)

applied.

- k
