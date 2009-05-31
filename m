Return-Path: <linux-kernel-owner+w=401wt.eu-S1759793AbZEaRCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759793AbZEaRCG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 13:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757200AbZEaRB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 13:01:56 -0400
Received: from waste.org ([66.93.16.53]:35708 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754750AbZEaRB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 13:01:56 -0400
Subject: Re: [PATCH] TXx9: Add TX4939 RNG support
From: Matt Mackall <mpm@selenic.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au
In-Reply-To: <20090601.015755.21367568.anemo@mba.ocn.ne.jp>
References: <1243350141-883-2-git-send-email-anemo@mba.ocn.ne.jp>
	 <20090601.015755.21367568.anemo@mba.ocn.ne.jp>
Content-Type: text/plain
Date: Sun, 31 May 2009 12:01:29 -0500
Message-Id: <1243789289.22069.25.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-01 at 01:57 +0900, Atsushi Nemoto wrote:
> : This is a reply for comments from Matt Mackall via mm-commit mail.
> 
> On Fri, 29 May 2009 19:21:22 -0500, Matt Mackall <mpm@selenic.com> wrote:
> > > +++ a/arch/mips/txx9/generic/setup_tx4939.c
> > > @@ -494,6 +494,24 @@ void __init tx4939_aclc_init(void)
> > >  			       TXX9_IRQ_BASE + TX4939_IR_ACLC, 1, 0, 1);
> > >  }
> > >  
> > > +#define TX4939_RNG_REG	((TX4939_CRYPTO_REG & 0xfffffffffULL) + 0xb0)
> > 
> > This isn't the best place for this define?
> 
> Well, I can move it to include/asm/txx9/tx4939.h.
> 
> > > +++ a/arch/mips/txx9/rbtx4939/setup.c
> > > @@ -501,6 +501,7 @@ static void __init rbtx4939_device_init(
> > >  	tx4939_dmac_init(0, 2);
> > >  	tx4939_aclc_init();
> > >  	platform_device_register_simple("txx9aclc-generic", -1, NULL, 0);
> > > +	tx4939_rng_init();
> > >  }
> > >  
> > >  static void __init rbtx4939_setup(void)
> > 
> > Not clear to me how this works when this is a module?
> 
> This patch add a registration of a platform device for RNG to vmlinux.
> And the other patch add a driver module for the RNG.  This strategy is
> fairly common for SoCs or embedded platforms.

If your driver is built as a module (which your patch allows), the above
won't work, right?

-- 
http://selenic.com : development and support for Mercurial and Linux


