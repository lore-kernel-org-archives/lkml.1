Return-Path: <linux-kernel-owner+w=401wt.eu-S1758590AbYHCRHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590AbYHCRHy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 13:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756446AbYHCRHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 13:07:46 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:49662 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756285AbYHCRHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 13:07:45 -0400
Date: Sun, 3 Aug 2008 19:07:30 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Glauber Costa <gcosta@redhat.com>,
       Pavel Machek <pavel@suse.cz>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86, acpi: temp_stack is used only when CONFIG_SMP is
 set
In-Reply-To: <20080803165210.GC5414@joi>
Message-ID: <alpine.LNX.1.10.0808031901120.7765@titan.stealer.net>
References: <20080803165210.GC5414@joi>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.5
X-Spam-Bar: --
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Sun, 03 Aug 2008 17:07:41 +0000
	Bayes: 0.0003 Tokens: new, 192; hammy, 6; neutral, 2; spammy, 0.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0003]
X-Spam-Signature: 200408c8e770f9a1febacbeb53e1e4db1ffbef7e
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Aug 2008, Marcin Slusarz wrote:

> arch/x86/kernel/acpi/sleep.c:24: warning: 'temp_stack' defined but not used
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Glauber Costa <gcosta@redhat.com>
> Cc: Pavel Machek <pavel@suse.cz>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/acpi/sleep.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
> index fa2161d..9103cb6 100644
> --- a/arch/x86/kernel/acpi/sleep.c
> +++ b/arch/x86/kernel/acpi/sleep.c
> @@ -20,7 +20,7 @@ unsigned long acpi_realmode_flags;
>  /* address in low memory of the wakeup routine. */
>  static unsigned long acpi_realmode;
>  
> -#ifdef CONFIG_64BIT
> +#ifdef CONFIG_SMP
>  static char temp_stack[10240];
>  #endif
>  

Now it still generates the warning, but on i386 with CONFIG_SMP set, 
instead of x86_64 without CONFIG_SMP. We only need temp_stack, when both 
CONFIG_64BIT and CONFIG_SMP are activated.

Sven
