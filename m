Return-Path: <linux-kernel-owner+w=401wt.eu-S1756135AbZA3OYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbZA3OYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 09:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbZA3OYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 09:24:07 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:45167 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbZA3OYG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 09:24:06 -0500
From: "Woodruff, Richard" <r-woodruff2@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Paul Walmsley <paul@pwsan.com>
CC: "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>
Date: Fri, 30 Jan 2009 08:23:49 -0600
Subject: RE: [PATCH E 08/14] OMAP clock: move rate recalc, propagation code
 up to plat-omap/clock.c
Thread-Topic: [PATCH E 08/14] OMAP clock: move rate recalc, propagation code
 up to plat-omap/clock.c
Thread-Index: AcmCuDqDJ3mwXH60TAqWEcbbo5mVWgAK9/mw
Message-ID: <13B9B4C6EF24D648824FF11BE89671620376DEC116@dlee02.ent.ti.com>
References: <20090128192551.29333.82943.stgit@localhost.localdomain>
 <20090128192748.29333.5856.stgit@localhost.localdomain>
 <20090129174153.GH18233@n2100.arm.linux.org.uk>
 <alpine.DEB.2.00.0901300135560.26985@utopia.booyaka.com>
 <20090130085249.GB6864@n2100.arm.linux.org.uk>
In-Reply-To: <20090130085249.GB6864@n2100.arm.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> There's one bug that your version highlights in mine - the virtual mpu
> clock in omap1 touches the DPLL and repropagates that rate.  I've
> removed that repropagation, so that needs fixing.
>
> However, this raises a question: why is the virtual mpu clock touching
> some other part of the clock tree.  I wonder whether this should be
> handled a different way, though the first thing that needs answering is
> why we have this alias for 'arm_ck' ?

At one point in time the virtual clock allowed control for a set of clocks with some dependencies.  The mpu alias provided a convenient control point.

Tukka did original omap1 in this format. I forget its exact meaning.

The original omap2 code had behavior:
        - mpu-dpll had a clock node which allowed direct mpu speed control
        - mpu-virt-clock allowed switching between sets that have fixed ratio dependency which were pegged to current mpu-dll speed.
                * This way round_rate would allow you to discover all valid OPPs.

The first pass OMAP3 code TI did followed omap2 but it wasn't strongly bound by ratio-sets given the multiple async-dplls. Paul has taken code in a bit different direction.  He can comment on current behavior here.

Regards,
Richard W.

