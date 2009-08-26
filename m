Return-Path: <linux-kernel-owner+w=401wt.eu-S1756788AbZHZGJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788AbZHZGJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756772AbZHZGJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:09:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35851 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756760AbZHZGJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:09:37 -0400
Date: Wed, 26 Aug 2009 08:09:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: jeremy@xensource.com, chrisw@sous-sol.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] XEN: enlighten, use uninitialized_var(cx)
Message-ID: <20090826060925.GA6194@elte.hu>
References: <1251234044-6943-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251234044-6943-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Jiri Slaby <jirislaby@gmail.com> wrote:

> To avoid a wrong compiler warning, use unitialized_var(cx) in
> xen_init_cpuid_mask.
> 
> cx needn't be initialized for cpuid when ax is 1.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
> Cc: Chris Wright <chrisw@sous-sol.org>
> ---
>  arch/x86/xen/enlighten.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index e90540a..5ab75e2 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -202,7 +202,7 @@ static void xen_cpuid(unsigned int *ax, unsigned int *bx,
>  
>  static __init void xen_init_cpuid_mask(void)
>  {
> -	unsigned int ax, bx, cx, dx;
> +	unsigned int ax, bx, uninitialized_var(cx), dx;

Please dont use uninitialized_var(), it's an unreliable facility: if 
this variable ever grows a real used-without-initialization bug in 
the future, the compiler warning is turned off permanently. It's 
rare but might happen. We are better off with initializing it to 
zero.

	Ingo
