Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbYBYLz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbYBYLz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 06:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbYBYLzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 06:55:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54093 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753099AbYBYLzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 06:55:16 -0500
Date: Mon, 25 Feb 2008 12:54:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Florian Fainelli <florian.fainelli@telecomint.eu>,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Add rdc321x defconfig file
Message-ID: <20080225115448.GB16376@elte.hu>
References: <200802251058.30188.florian.fainelli@telecomint.eu> <20080225105110.GA5648@elte.hu> <20080225111733.GB32450@cs181133002.pp.htv.fi> <200802251227.37435.florian.fainelli@telecomint.eu> <20080225114547.GD32450@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080225114547.GD32450@cs181133002.pp.htv.fi>
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


* Adrian Bunk <bunk@kernel.org> wrote:

> On Mon, Feb 25, 2008 at 12:27:34PM +0100, Florian Fainelli wrote:
> > Le lundi 25 février 2008, Adrian Bunk a écrit :
> > > Booting it might fine, but CLOCK_TICK_RATE will be wrong...
> > 
> > PIT_TICK_RATE is overriden specificaly for R321x in 
> > include/asm-x86/timex.h, just like for AMD Elan.
> 
> Not when you try CONFIG_X86_GENERICARCH=y as Ingo suggested.

good point.

The clean solution would be to make PIT_TICK_RATE/CLOCK_TICK_RATE a 
variable that defaults to 1193182 on x86, and which an early quirk would 
set to 1189200 on AMD Elan and to 1041667 on RDC321X.

likewise, other subarch details should be turned into specific drivers 
or specific quirks as well.

	Ingo
