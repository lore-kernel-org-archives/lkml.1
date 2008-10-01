Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbYJAICH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbYJAICH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 04:02:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843AbYJAIBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 04:01:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34517 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbYJAIBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 04:01:55 -0400
Date: Wed, 1 Oct 2008 10:01:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Noonan <steven@uplinklabs.net>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH -tip] drivers/serial/8250.c: 'i' may be used
	uninitialized
Message-ID: <20081001080150.GC25832@elte.hu>
References: <1222847847-7127-1-git-send-email-steven@uplinklabs.net> <1222847847-7127-2-git-send-email-steven@uplinklabs.net> <1222847847-7127-3-git-send-email-steven@uplinklabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222847847-7127-3-git-send-email-steven@uplinklabs.net>
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


( Alan Cc:-ed. Seems like gcc bogosity - so your solution of using
  uninitialized_var() is the correct way to annotate this. )

* Steven Noonan <steven@uplinklabs.net> wrote:

> Signed-off-by: Steven Noonan <steven@uplinklabs.net>
> ---
>  drivers/serial/8250.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
> index 356c2a2..b51e91e 100644
> --- a/drivers/serial/8250.c
> +++ b/drivers/serial/8250.c
> @@ -1599,7 +1599,7 @@ static int serial_link_irq_chain(struct uart_8250_port *up)
>  
>  static void serial_unlink_irq_chain(struct uart_8250_port *up)
>  {
> -	struct irq_info *i;
> +	struct irq_info *uninitialized_var(i);
>  	struct hlist_node *n;
>  	struct hlist_head *h;
>  
> -- 
> 1.6.0.2
