Return-Path: <linux-kernel-owner+w=401wt.eu-S1759886AbYAKG1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759886AbYAKG1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 01:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbYAKG1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 01:27:10 -0500
Received: from cantor.suse.de ([195.135.220.2]:34291 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbYAKG1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 01:27:09 -0500
To: Roland McGrath <roland@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64 early_idt_handler improvements
From: Andi Kleen <andi@firstfloor.org>
References: <20080111060705.9EAF126F9A9@magilla.localdomain>
Date: Fri, 11 Jan 2008 07:27:07 +0100
In-Reply-To: <20080111060705.9EAF126F9A9@magilla.localdomain> (Roland McGrath's message of "Thu\, 10 Jan 2008 22\:07\:05 -0800 \(PST\)")
Message-ID: <p73k5mgnah0.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath <roland@redhat.com> writes:

> It's not too pretty, but I found this made the "PANIC: early exception"
> messages become much more reliably useful: 1. print the vector number,
> 2. print the %cs value, 3. handle error-code-pushing vs non-pushing vectors.

For what do you need cs? It should be always the same for early boot.

>
> Signed-off-by: Roland McGrath <roland@redhat.com>
> ---
>  arch/x86/kernel/head64.c  |    6 ++++--
>  arch/x86/kernel/head_64.S |   34 ++++++++++++++++++++++++++++++----
>  2 files changed, 34 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
> index 4a1c135..0000000 100644  
> --- a/arch/x86/kernel/head64.c
> +++ b/arch/x86/kernel/head64.c
> @@ -48,6 +48,8 @@ static void __init copy_bootdata(char *r
>  	}
>  }
>  
> +extern const char early_idt_handlers[IDT_ENTRIES][10];

I don't think that minor improvement is worth that much memory
(several KB for the array and some more for all the handlers)

Also in my experience it is not that difficult to work out from
which vector the exception came from. There are not that many variants
anyways; it's near always #GP or #PF.

-Andi
