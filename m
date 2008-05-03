Return-Path: <linux-kernel-owner+w=401wt.eu-S1754772AbYECWat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbYECWat (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 18:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbYECWam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 18:30:42 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:33983 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbYECWal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 18:30:41 -0400
Date: Sun, 4 May 2008 01:29:43 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Ingo Molnar <mingo@elte.hu>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Ingo, no more kconfig patches
Message-ID: <20080503222943.GX5838@cs181133002.pp.htv.fi>
References: <20080430170125.ZZRA012@mailhub.coreip.homeip.net> <20080430211317.GA24633@elte.hu> <20080430230100.GK29330@cs181133002.pp.htv.fi> <20080501025234.GE27574@elte.hu> <20080501115923.GX29330@cs181133002.pp.htv.fi> <20080503191445.GF5292@elte.hu> <20080503202416.GR5838@cs181133002.pp.htv.fi> <m37ieb84ve.fsf@maximus.localdomain> <20080503214750.GU5838@cs181133002.pp.htv.fi> <m3wsmb6np2.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <m3wsmb6np2.fsf@maximus.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2008 at 12:13:29AM +0200, Krzysztof Halasa wrote:
> Adrian Bunk <bunk@kernel.org> writes:
> 
> > If you select LEDS_CLASS "select follows dependencies" would let inherit 
> > X86_RDC321X the dependencies of LEDS_CLASS,
> 
> I see, "follows" the other way around. That fixes the breakage but I
> guess it's not exactly what the people doing make menuconfig want.
> Though in absence of the following it would IMHO make sense anyway.

Kconfig is an interface for users.

>From a developer perspective if might be the easiest to simply remove 
the "select" syntax, but from an UI perspective it would be horrible.

> > And regarding "displaying all relevant dependency chains" to the user - 
> > I can't see how that would work in the more complicated cases.
> 
> I fear it too but perhaps there is some sane way? I don't know,
> asking (recursively?) interactively?
> 
> Like:
> QWERTY requires at least one, select (Y/M):
> - ARCH_X86 && NET_ETHERNET, or
> - USB4_0 && !SMP, or
> - XXX
> 
> then:
> NET_ETHERNET requires at lest one, select (Y/M):
> - PCI128
> - ISA256
> 
> then (info):
> PCI128 requires PCI and it's selected automatically.

FB_SGIVW requires X86_VISWS and it's selected automatically.

(which is not good if you want a kernel that runs on a PC)

> I don't know. It could be useful even with a single dependency when
> configuring as the module, the user could select Y or M for dependency
> interactively (people may want to have E1000E=m and TULIP=m but MII=y).

Why do we have to bother users with the MII option at all?

"E1000E=m and TULIP=m but MII=y" works, but it doesn't really make 
sense.

> Not sure if still on the same planet, though :-)
> -- 
> Krzysztof Halasa

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

