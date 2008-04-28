Return-Path: <linux-kernel-owner+w=401wt.eu-S935749AbYD1PxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935749AbYD1PxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765183AbYD1PxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:53:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41574 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753723AbYD1PxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:53:06 -0400
Date: Mon, 28 Apr 2008 17:52:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] x86: Modify Kconfig to allow up to 4096 cpus
Message-ID: <20080428155251.GI18776@elte.hu>
References: <20080426001548.829332000@polaris-admin.engr.sgi.com> <20080426001549.014201000@polaris-admin.engr.sgi.com> <20080427103933.GA5168@ucw.cz> <20080428133806.GC3973@elte.hu> <20080428135459.GA3704@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428135459.GA3704@atrey.karlin.mff.cuni.cz>
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


* Pavel Machek <pavel@ucw.cz> wrote:

> > > Why is redundant option 'maxsmp' a good idea?
> > 
> > because this way randconfig can trigger it and can configure all the 
> > otherwise randconfig-invisible [or just plain unlikely] numerics and 
> > options up to their max.
> > 
> > I found 2-3 "large box" bugs via that way already.
> 
> Should we improve randconfig to select numeric values when range is 
> given, too?

definitely - but often there are constraints on the numeric value that 
are not spelled out in the Kconfig language. (alignment, granularity, 
etc.)

MAXSMP is still useful, as it would still be rather unlikely for all 
numeric values to go to the max at once. The other idea is that with it 
'make allyesconfig' really puts all build-time limits up to the max.

	Ingo
