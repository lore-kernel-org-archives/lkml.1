Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbZBSL1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbZBSL1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 06:27:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbZBSL1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 06:27:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42147 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbZBSL1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 06:27:24 -0500
Date: Thu, 19 Feb 2009 12:27:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: i915 regression in 2.6.29-rc5
Message-ID: <20090219112708.GR2354@elte.hu>
References: <1234927467.4707.15.camel@rzhang-desktop> <86802c440902181133x320c80f6ue0dbb38880ffe267@mail.gmail.com> <1235015743.32297.53.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1235015743.32297.53.camel@rzhang-dt>
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


* Zhang Rui <rui.zhang@intel.com> wrote:

> On Thu, 2009-02-19 at 03:33 +0800, Yinghai Lu wrote:
> > On Tue, Feb 17, 2009 at 7:24 PM, ZhangRui <rui.zhang@intel.com> wrote:
> > > Hi, all,
> > >
> > > I got an i915 failure in 2.6.29-rc5.
> > >
> > > problem description: the screen doesn't come back after suspend/resume.
> > > A workaround is to boot with "nomodesetting".
> > >
> > > I got this error message during i915 driver load time,
> > > [   22.606749] mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
> > > [   22.606752] [drm] MTRR allocation failed
> > > [   22.606753] .  Graphics performance may suffer.
> > 
> > CONFIG_MTRR_SANITIZER=y
> > CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
> > CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
> > 
> > may help this one.
> > 
> hah, it helps.
> the screen is back with this, while my previous kernel option is same
> except that ﻿CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0.

Ok, great. I think we should flip the default of 
MTRR_SANITIZER_ENABLE_DEFAULT from 0 to 1 in 2.6.30,
as we now seem to a better job of sorting out MTRRs
details than X does.

Yinghai, mind sending a patch for that?

	Ingo
