Return-Path: <linux-kernel-owner+w=401wt.eu-S1758174AbZGRLk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174AbZGRLk6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 07:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758146AbZGRLk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 07:40:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42953 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447AbZGRLk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 07:40:57 -0400
Date: Sat, 18 Jul 2009 13:39:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Fisher <bug-track@fisher-privat.net>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: ykzhao <yakui.zhao@intel.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] Lowmemory corruption. Quirk for Intel DG45ID board.
Message-ID: <20090718113953.GG27287@elte.hu>
References: <1247660169-4503-1-git-send-email-bug-track@fisher-privat.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247660169-4503-1-git-send-email-bug-track@fisher-privat.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Fisher <bug-track@fisher-privat.net> wrote:

> AMI BIOS with lowmemory corruption was found on Intel DG45ID board
> (Bug 13710). It hase differnt DMI_BIOS_VENDOR = "Intel Corp.", for
> now we will match only DMI_BOARD_NAME.
> 
> Signed-off-by: Alexey Fisher <bug-track@fisher-privat.net>
> ---
>  arch/x86/kernel/setup.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index de2cab1..4bacb68 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -672,6 +672,19 @@ static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
>  			DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies"),
>  		},
>  	},
> +	{
> +	/*
> +	 * AMI BIOS with lowmemory corruption was found on Intel DG45ID board.
> +	 * It hase differnt DMI_BIOS_VENDOR = "Intel Corp.", for now we will

FYI, i did: s/differnt/different

and a few other minor edits.

> +	 * match only DMI_BOARD_NAME and see if there is more bad products
> +	 * with this vendor.
> +	 */
> +		.callback = dmi_low_memory_corruption,
> +		.ident = "AMI BIOS",
> +		.matches = {
> +			DMI_MATCH(DMI_BOARD_NAME, "DG45ID"),
> +		},
> +	},
>  #endif

Applied to tip:x86/urgent, thanks Alexey!

	Ingo
