Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbYECVtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbYECVtW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 17:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbYECVst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 17:48:49 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:60968 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbYECVss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 17:48:48 -0400
Date: Sun, 4 May 2008 00:47:50 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Ingo Molnar <mingo@elte.hu>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Ingo, no more kconfig patches
Message-ID: <20080503214750.GU5838@cs181133002.pp.htv.fi>
References: <20080430200340.GA13757@elte.hu> <20080430170125.ZZRA012@mailhub.coreip.homeip.net> <20080430211317.GA24633@elte.hu> <20080430230100.GK29330@cs181133002.pp.htv.fi> <20080501025234.GE27574@elte.hu> <20080501115923.GX29330@cs181133002.pp.htv.fi> <20080503191445.GF5292@elte.hu> <20080503202416.GR5838@cs181133002.pp.htv.fi> <m37ieb84ve.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <m37ieb84ve.fsf@maximus.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2008 at 11:17:09PM +0200, Krzysztof Halasa wrote:
> Adrian Bunk <bunk@kernel.org> writes:
> 
> > I'm not even sure the semantics of "select follows dependencies" 
> > would actually be better than what we have today.
> 
> I think it would. But how would that actually work? By displaying all
> relevant dependency chains and asking the user to select one?

Let's look at the problem this thread is about:

menuconfig NEW_LEDS
        bool "LED Support"

config LEDS_CLASS
        tristate "LED Class Support"
	depends on NEW_LEDS              # actually an "if", but that's 
                                           just syntactical sugar

config X86_RDC321X
        bool "RDC R-321x SoC"
        select LEDS_CLASS


If you select LEDS_CLASS "select follows dependencies" would let inherit 
X86_RDC321X the dependencies of LEDS_CLASS, IOW treat it as:

config X86_RDC321X
        bool "RDC R-321x SoC"
        select LEDS_CLASS
	depends on NEW_LEDS


That might make the randconfig crowd happy.

But from an UI perspective it's not an improvement.


And regarding "displaying all relevant dependency chains" to the user - 
I can't see how that would work in the more complicated cases.


> Krzysztof Halasa

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

