Return-Path: <linux-kernel-owner+w=401wt.eu-S1759347AbXHETc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759347AbXHETc4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 15:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbXHETcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 15:32:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59420 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753AbXHETcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 15:32:48 -0400
Date: Sun, 5 Aug 2007 21:32:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jakob Oestergaard <jakob@unthought.net>, Jeff Garzik <jeff@garzik.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com, richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070805193231.GA21928@elte.hu>
References: <20070804163733.GA31001@elte.hu> <alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org> <46B4C0A8.1000902@garzik.org> <20070805102021.GA4246@unthought.net> <46B5A996.5060006@garzik.org> <20070805105850.GC4246@unthought.net> <20070805124648.GA21173@elte.hu> <alpine.LFD.0.999.0708050944470.5037@woody.linux-foundation.org> <20070805190928.GA17433@elte.hu> <20070805202930.4ce62542@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070805202930.4ce62542@the-village.bc.nu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > also add the CONFIG_DEFAULT_RELATIME kernel option, which makes 
> > "norelatime" the default for all mounts without an extra kernel boot 
> > option.
> 
> Should be a mount option.

it is already a mount option too.

> > +	relatime        [FS] default to enabled relatime updates on all
> > +			filesystems.
> > +
> > +	relatime=       [FS] default to enabled/disabled relatime updates on
> > +			all filesystems.
> > +
> 
> Double patch

no - it was not a double patch, i made all the common variants valid 
boot options: "relatime", "relatime=0/1", "norelatime" and 
"norelatime=0/1". Anyway, this is mooth, in the latest (v2) version 
there's only a single boot parameter.

> > +config DEFAULT_RELATIME
> > +	bool "Mount all filesystems with relatime by default"
> > +	default y
> 
> Changes behaviour so probably should default n. Better yet it should 
> be the mount option so its flexible and strongly encouraged for 
> vendors.

relatime is a mount option already. And distros can disable it if they 
want. (they are conscious about their kernel config selections anyway.)

> > +0
> > +#endif
> > +;
> 
> This ifdef mess would go away for a mount option

i fixed that in v2.

	Ingo
