Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbYECWNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbYECWNk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 18:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbYECWNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 18:13:33 -0400
Received: from OSB1387.piap.pl ([195.187.100.11]:58484 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848AbYECWNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 18:13:32 -0400
To: Adrian Bunk <bunk@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Ingo, no more kconfig patches
References: <20080430200340.GA13757@elte.hu>
	<20080430170125.ZZRA012@mailhub.coreip.homeip.net>
	<20080430211317.GA24633@elte.hu>
	<20080430230100.GK29330@cs181133002.pp.htv.fi>
	<20080501025234.GE27574@elte.hu>
	<20080501115923.GX29330@cs181133002.pp.htv.fi>
	<20080503191445.GF5292@elte.hu>
	<20080503202416.GR5838@cs181133002.pp.htv.fi>
	<m37ieb84ve.fsf@maximus.localdomain>
	<20080503214750.GU5838@cs181133002.pp.htv.fi>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 04 May 2008 00:13:29 +0200
In-Reply-To: <20080503214750.GU5838@cs181133002.pp.htv.fi> (Adrian Bunk's message of "Sun\, 4 May 2008 00\:47\:50 +0300")
Message-ID: <m3wsmb6np2.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> writes:

> If you select LEDS_CLASS "select follows dependencies" would let inherit 
> X86_RDC321X the dependencies of LEDS_CLASS,

I see, "follows" the other way around. That fixes the breakage but I
guess it's not exactly what the people doing make menuconfig want.
Though in absence of the following it would IMHO make sense anyway.

> And regarding "displaying all relevant dependency chains" to the user - 
> I can't see how that would work in the more complicated cases.

I fear it too but perhaps there is some sane way? I don't know,
asking (recursively?) interactively?

Like:
QWERTY requires at least one, select (Y/M):
- ARCH_X86 && NET_ETHERNET, or
- USB4_0 && !SMP, or
- XXX

then:
NET_ETHERNET requires at lest one, select (Y/M):
- PCI128
- ISA256

then (info):
PCI128 requires PCI and it's selected automatically.

I don't know. It could be useful even with a single dependency when
configuring as the module, the user could select Y or M for dependency
interactively (people may want to have E1000E=m and TULIP=m but MII=y).

Not sure if still on the same planet, though :-)
-- 
Krzysztof Halasa
