Return-Path: <linux-kernel-owner+w=401wt.eu-S1759079AbZEaQ6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759079AbZEaQ6D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 12:58:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756009AbZEaQ5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 12:57:55 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:60935 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753466AbZEaQ5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 12:57:54 -0400
Date: Mon, 01 Jun 2009 01:57:55 +0900 (JST)
Message-Id: <20090601.015755.21367568.anemo@mba.ocn.ne.jp>
To: mpm@selenic.com
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au
Subject: Re: [PATCH] TXx9: Add TX4939 RNG support
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <1243350141-883-2-git-send-email-anemo@mba.ocn.ne.jp>
	<1243642882.8020.9.camel@calx>
References: <1243350141-883-2-git-send-email-anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

: This is a reply for comments from Matt Mackall via mm-commit mail.

On Fri, 29 May 2009 19:21:22 -0500, Matt Mackall <mpm@selenic.com> wrote:
> > +++ a/arch/mips/txx9/generic/setup_tx4939.c
> > @@ -494,6 +494,24 @@ void __init tx4939_aclc_init(void)
> >  			       TXX9_IRQ_BASE + TX4939_IR_ACLC, 1, 0, 1);
> >  }
> >  
> > +#define TX4939_RNG_REG	((TX4939_CRYPTO_REG & 0xfffffffffULL) + 0xb0)
> 
> This isn't the best place for this define?

Well, I can move it to include/asm/txx9/tx4939.h.

> > +++ a/arch/mips/txx9/rbtx4939/setup.c
> > @@ -501,6 +501,7 @@ static void __init rbtx4939_device_init(
> >  	tx4939_dmac_init(0, 2);
> >  	tx4939_aclc_init();
> >  	platform_device_register_simple("txx9aclc-generic", -1, NULL, 0);
> > +	tx4939_rng_init();
> >  }
> >  
> >  static void __init rbtx4939_setup(void)
> 
> Not clear to me how this works when this is a module?

This patch add a registration of a platform device for RNG to vmlinux.
And the other patch add a driver module for the RNG.  This strategy is
fairly common for SoCs or embedded platforms.

---
Atsushi Nemoto
