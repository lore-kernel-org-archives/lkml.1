Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbZAKNvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbZAKNvt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 08:51:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbZAKNvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 08:51:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41621 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbZAKNvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 08:51:40 -0500
Date: Sun, 11 Jan 2009 14:51:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@infradead.org>
Cc: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       Petr Titera <P.Titera@century.cz>, linux-kernel@vger.kernel.org
Subject: Re: Build error on latest git
Message-ID: <20090111135122.GB18299@elte.hu>
References: <4969C096.9060909@century.cz> <4969DEA0.5020301@century.cz> <3f9a31f40901110506v646bd599q863be03accbfd8b2@mail.gmail.com> <1231679335.3244.1.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231679335.3244.1.camel@jaswinder.satnam>
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


* Jaswinder Singh Rajput <jaswinder@infradead.org> wrote:

> On Sun, 2009-01-11 at 18:36 +0530, Jaswinder Singh Rajput wrote:
> > On Sun, Jan 11, 2009 at 5:27 PM, Petr Titera <P.Titera@century.cz> wrote:
> > > Going through source it seems to me (still building) that it is caused by
> > > including asm/smp.h only if build with CONFIG_SMP. This patch seems to fix
> > > this
> > >
> > > diff --git a/include/linux/smp.h b/include/linux/smp.h
> > > index b824669..fd51bb9 100644
> > > --- a/include/linux/smp.h
> > > +++ b/include/linux/smp.h
> > > @@ -11,6 +11,8 @@
> > > #include <linux/list.h>
> > > #include <linux/cpumask.h>
> > >
> > > +#include <asm/smp.h>
> > > +
> > > extern void cpu_idle(void);
> > >
> > 
> > No, this is wrong.
> > 
> > asm/smp.h should only be included when CONFIG_SMP is defined.
> > 
> > I will send fix of this.
> > 
> 
> Here is the temporary fix, later on I will remove non-smp data from
> smp.h
> 
> Subject: [PATCH] x86: mpparse.c fix compilation error
> 
> Impact: fix compilation error
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/kernel/mpparse.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

applied to tip/x86/urgent, thanks Jaswinder!

	Ingo
