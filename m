Return-Path: <linux-kernel-owner+w=401wt.eu-S1754071AbYKRVWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbYKRVWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 16:22:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbYKRVWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 16:22:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58997 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837AbYKRVWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 16:22:15 -0500
Date: Tue, 18 Nov 2008 22:21:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steve Conklin <sconklin@canonical.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com
Subject: Re: [PATCH] Quirk for reboot stalls on a Dell Optiplex 330
Message-ID: <20081118212158.GB19150@elte.hu>
References: <alpine.DEB.2.00.0811140051000.13353@T41>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0811140051000.13353@T41>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steve Conklin <sconklin@canonical.com> wrote:

> >From 6269c416487b41576107ef6f535639d3177daa43 Mon Sep 17 00:00:00 2001
> From: Leann Ogasawara <leann.ogasawara@canonical.com>
> Date: Wed, 12 Nov 2008 17:01:54 -0600
> Subject: [PATCH] Quirk for reboot stalls on a Dell Optiplex 330
> 
> Dell Optiplex 330 appears to hang on reboot. This is resolved by adding
> a quirk to set bios reboot.
> 
> Signed-off-by: Leann Ogasawara <leann.ogasawara@canonical.com>
> Signed-off-by: Steve Conklin <steve.conklin@canonical.com>
> ---
>  arch/x86/kernel/reboot.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)

applied to tip/x86/quirks, thanks Steve!

> +	{   /* Handle problems with rebooting on Dell Optiplex 330 with 0KP561 */
> +		.callback = set_bios_reboot,
> +		.ident = "Dell OptiPlex 330",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 330"),
> +			DMI_MATCH(DMI_BOARD_NAME, "0KP561"),

is the board filter really necessary? It might unnecessarily filter 
out small variations in board names.

	Ingo
