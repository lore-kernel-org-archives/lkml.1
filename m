Return-Path: <linux-kernel-owner+w=401wt.eu-S1763693AbYCDHdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763693AbYCDHdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 02:33:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbYCDHdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 02:33:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50279 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbYCDHdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 02:33:19 -0500
Date: Tue, 4 Mar 2008 08:32:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       Alexey Starikovskiy <aystarik@gmail.com>, lenb@kernel.org,
       astarikovskiy@suse.de, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] x86: phase out forced inlining
Message-ID: <20080304073248.GA2947@elte.hu>
References: <20080301183550.GC25835@cs181133002.pp.htv.fi> <20080303085720.GD15943@elte.hu> <20080303091314.GC4457@cs181133002.pp.htv.fi> <20080303091714.GA18250@elte.hu> <20080303093103.GA23651@uranus.ravnborg.org> <20080303103933.GC21190@elte.hu> <20080303113451.GF4457@cs181133002.pp.htv.fi> <20080303114533.GA4183@elte.hu> <20080303121335.GA15381@elte.hu> <20080303224231.86c22ed0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303224231.86c22ed0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> urgh.  This will cause whatever problem 
> 4507a6a59cfc6997e532cd812a8bd244181e6205 fixed five years ago to 
> resurface for incautious gcc-3.x users.

hm, commit 4507a6a59cfc6997e532cd812a8bd244181e6205 does not exist:

  fatal: bad object 4507a6a59cfc6997e532cd812a8bd244181e6205

but i suspect it must be something along the lines of the known problem 
of really old gcc versions creating huge stackframes? Those pristine gcc 
versions were practically unusable for distro kernels anyway (and were 
patched by distros) - but i have no problem with restricting this 
feature to gcc4x. gcc4x creates more compact -Os code too, so it's 
recommended for smaller image sizes.

> I'd suggest that this
> 
> > +#ifndef CONFIG_OPTIMIZE_INLINING
> 
> become something along the lines of
> 
> > +#ifndef CONFIG_OPTIMIZE_INLINING && (__GNUC__ > 3)

good point, fixed that.

> It would be nice to be able to feed the gcc version into the Kconfig 
> logic, really..

yeah, instead of littering our include files with those quirks.

	Ingo
