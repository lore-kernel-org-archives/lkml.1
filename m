Return-Path: <linux-kernel-owner+w=401wt.eu-S1755818AbZFGOV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbZFGOV3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 10:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbZFGOVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 10:21:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45728 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184AbZFGOVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 10:21:21 -0400
Date: Sun, 7 Jun 2009 16:21:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Figo.zhang" <figo1802@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND]X86:microcode: fix vfree()
Message-ID: <20090607142118.GB21340@elte.hu>
References: <1244351929.3355.13.camel@myhost> <20090607140113.GI12088@elte.hu> <1244384315.3402.5.camel@myhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244384315.3402.5.camel@myhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Note: it's not a 'resend', it's v2 of the patch)

* Figo.zhang <figo1802@gmail.com> wrote:

> vfree() does its own 'NULL' check, so no need for check before
> calling it.
> 
> Signed-off-by: Figo.zhang <figo1802@gmail.com>
> ---   
> arch/x86/kernel/microcode_amd.c |   13 +++++--------
>  1 files changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
> index 453b579..8f52cf4 100644
> --- a/arch/x86/kernel/microcode_amd.c
> +++ b/arch/x86/kernel/microcode_amd.c
> @@ -257,10 +257,9 @@ static int install_equiv_cpu_table(const u8 *buf)
>  
>  static void free_equiv_cpu_table(void)
>  {
> -	if (equiv_cpu_table) {
> -		vfree(equiv_cpu_table);
> -		equiv_cpu_table = NULL;
> -	}
> +	vfree(equiv_cpu_table);
> +	equiv_cpu_table = NULL;
> +

you fixed the tab but you didnt remove the stray newline :)

	Ingo
