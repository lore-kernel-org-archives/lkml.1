Return-Path: <linux-kernel-owner+w=401wt.eu-S1753527AbZI2HZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbZI2HZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 03:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbZI2HZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 03:25:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56912 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420AbZI2HZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 03:25:05 -0400
Date: Tue, 29 Sep 2009 09:24:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, clemens@ladisch.de,
       venkatesh.pallipadi@intel.com, gregkh@suse.de
Subject: Re: [2.6.31-git17] WARNING: at kernel/hrtimer.c:648
	hres_timers_resume+0x40/0x50()/WARNING: at drivers/base/sys.c:353
	__sysdev_resume+0xc3/0xe0()
Message-ID: <20090929072454.GA11414@elte.hu>
References: <8db1092f0909270105x4b49daf8k268e453d2379020c@mail.gmail.com> <2674af740909270127s464a3cb2xef5e7f4cd61b0eb7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2674af740909270127s464a3cb2xef5e7f4cd61b0eb7@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yong Zhang <yong.zhang0@gmail.com> wrote:

> On Sun, Sep 27, 2009 at 4:05 PM, Maciej Rutecki
> <maciej.rutecki@gmail.com> wrote:
> > Kernel: 2.6.31-git17
> >
> > During suspend to disk & resume I got it in dmesg:
> >
> > [  587.940010] ------------[ cut here ]------------
> > [  587.940010] WARNING: at kernel/hrtimer.c:648 hres_timers_resume+0x40/0x50()
> > [  587.940010] Hardware name: HP Compaq nx6310 (EY501ES#AKD)
> > [  587.940010] hres_timers_resume() called with IRQs enabled!
> > [  587.940010] Modules linked in: btusb i915 drm_kms_helper drm

Could you try this with .32-rc1? This commit should have fixed the 
message above:

89133f9: clocksource: Resume clocksource without taking the clocksource mutex

	Ingo
