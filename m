Return-Path: <linux-kernel-owner+w=401wt.eu-S1753372AbZBDOSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbZBDOSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 09:18:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbZBDOSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 09:18:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47177 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980AbZBDOSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 09:18:31 -0500
Date: Wed, 4 Feb 2009 15:18:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>, x86@kernel.org,
       sam@ravnborg.org, hpa@zytor.com, jirislaby@gmail.com, gregkh@suse.de,
       davem@davemloft.net, xyzzy@speakeasy.org, mchehab@infradead.org,
       jens.axboe@oracle.com, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>
Subject: Re: [GIT PULL -tip] fix 22 make headers_check - 200901
Message-ID: <20090204141804.GB4411@elte.hu>
References: <20090204064307.GA18415@gondor.apana.org.au> <1233734645.3198.2.camel@localhost.localdomain> <200902041255.53264.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902041255.53264.arnd@arndb.de>
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


* Arnd Bergmann <arnd@arndb.de> wrote:

> On Wednesday 04 February 2009, Jaswinder Singh Rajput wrote:
> > On Wed, 2009-02-04 at 17:43 +1100, Herbert Xu wrote:
> > > > -#include <asm/types.h>
> > > > +#include <linux/types.h>
> > > > #include <linux/ioctl.h>
> > > 
> > > Awesome, you've just broken the userspace build of kvm as the
> > > file linux/types.h conflicts with sys/types.h.
> > > 
> > 
> > What I did is absolutely right.
> > 
> > If there is any conflict then we need to solve it in better way.
> > 
> > Can you please share what is the conflict and what you are expecting and
> > what you are getting.
> 
> I fear that the problem might be more widespread than just kvm.
> The problem is that <linux/types.h> without __KERNEL_STRICT_NAMES
> defines the standard types that glibc provides in its own <sys/types.h>,
> some of them even defined differently (e.g. the size of off_t depends
> __USE_FILE_OFFSET64).
> 
> You should be able to do
> 
> #include <sys/types.h>
> #define __KERNEL_STRICT_NAMES
> #include <linux/types.h>
> 
> or
> 
> #include <sys/types.h>
> #include <asm/types.h>
> 
> but not without the __KERNEL_STRICT_NAMES! This means that the
> mass-conversion to <linux/types.h> was flawed and should be fixed
> before 2.6.29 to avoid more trouble.

agreed.

	Ingo
