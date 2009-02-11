Return-Path: <linux-kernel-owner+w=401wt.eu-S1757556AbZBKUZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556AbZBKUZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 15:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756511AbZBKUZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 15:25:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38021 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756030AbZBKUZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 15:25:29 -0500
Date: Wed, 11 Feb 2009 21:25:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Dean Nelson <dcn@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       Tejun Heo <tj@kernel.org>, linux-ia64 <linux-ia64@vger.kernel.org>,
       linux-next <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SGI IA64 UV: fix ia64 build error in the linux-next tree
Message-ID: <20090211202512.GB8283@elte.hu>
References: <20090209162520.GA4882@sgi.com> <20090210132555.be1c1462.akpm@linux-foundation.org> <20090211150103.GA15814@sgi.com> <20090211150536.GE10525@elte.hu> <57C9024A16AD2D4C97DC78E552063EA361689D7D@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA361689D7D@orsmsx505.amr.corp.intel.com>
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


* Luck, Tony <tony.luck@intel.com> wrote:

> > What question was that? Folding back across that distance is not possible
> > in a Git workflow. I do regular cross-builds - the build bug did not trigger
> > with the ia64 defconfig.
> 
> I'm confused by this, as it definitely triggered for me.  Perhaps
> my build scripts do things a bit differently.  Essentially I do:
> 
>         $ for c in `ls arch/ia64/configs`
>         > do
>         >       cp arch/ia64/configs/$i .config
>         >       yes '' | make oldconfig
>         >       make
>         > done
> 
> Which takes the default answer for any new questions that crop
> up.  This enabled the GRU driver in the case of the generic_defconfig,
> and so the build failed because of the lack of asm/uv.h

hm, my build scripts do (in essence):

 make mrproper
 make ARCH=ia64 defconfig

hm, GRU is enabled as a module. I generally build the =y items, i.e. the
vmlinux. There's around 20 thousand modules enabled in various defconfigs,
that's a _lot_ of time to build.

	Ingo
