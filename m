Return-Path: <linux-kernel-owner+w=401wt.eu-S1754555AbYJaBQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbYJaBQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 21:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754723AbYJaBQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 21:16:14 -0400
Received: from mga05.intel.com ([192.55.52.89]:23313 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754646AbYJaBQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 21:16:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,519,1220252400"; 
   d="scan'208";a="633633828"
Subject: RE: cpu2000(both float and int) 13% regression with 2.6.28-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Roland McGrath <roland@redhat.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Yinghai Lu <yinghai@kernel.org>
In-Reply-To: <7E82351C108FA840AB1866AC776AEC46401F518D@orsmsx505.amr.corp.intel.com>
References: <1225175522.1685.57.camel@ymzhang>
	 <20081028080327.GB15734@elte.hu>
	 <20081028202649.GJ30573@linux-os.sc.intel.com>
	 <7E82351C108FA840AB1866AC776AEC46401F518D@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 31 Oct 2008 09:15:43 +0800
Message-Id: <1225415743.1685.87.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-10-30 at 17:32 -0700, Pallipadi, Venkatesh wrote:
> >-----Original Message-----
> >From: linux-kernel-owner@vger.kernel.org
> >[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Suresh Siddha
> >Sent: Tuesday, October 28, 2008 1:27 PM
> >To: Ingo Molnar
> >Cc: Zhang, Yanmin; LKML; H. Peter Anvin; Siddha, Suresh B;
> >Roland McGrath; Hiroshi Shimamoto; Yinghai Lu
> >Subject: Re: cpu2000(both float and int) 13% regression with 2.6.28-rc1
> >
> >On Tue, Oct 28, 2008 at 01:03:27AM -0700, Ingo Molnar wrote:
> >>
> >> * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> >>
> >> > Comparing with 2.6.27, cpu2000 (both float and int) has
> >about 13% regression
> >> > with 2.6.28-rc1 ﻿on my new-model x86-64 machine.
> >> >
> >> > I bisected down to below patch.
> >> >
> >> > commit 0afe2db21394820d32646a695eccf3fbfe6ab5c7
> >> > Merge: d847059... 43603c8...
> >> > Author: Ingo Molnar <mingo@elte.hu>
> >> > Date:   Sat Oct 11 20:23:20 2008 +0200
> >> >
> >> >     Merge branch 'x86/unify-cpu-detect' into
> >x86-v28-for-linus-phase4-D
> >> >
> >> >     Conflicts:
> >> >         arch/x86/kernel/cpu/common.c
> >> >         arch/x86/kernel/signal_64.c
> >> >         include/asm-x86/cpufeature.h
> >> >
> >> >
> >> > When I tried to revert it against 2.6.28-rc2, there are
> >many conflictions.
> >
> >Ingo, I will work with Yanmin and report our findings. It is
> >interesting to see
> >double digit regression on cpu2000 benchmark. My understanding is that
> >these benchmarks are not sensitive to signal handling. Also lmbench
> >signal handling(lat_sig) has less than 3-4% regression, because of
> >added overhead duing signal setup and restore. Context switch
> >didn't have
> >any noticeable difference, when I measure before.
> >
> 
> We figured out that this is not related to signals. But to this mismerge here
> 
> >  +#define X86_FEATURE_AMDC1E  (3*32+21) /* AMD C1E detected */
> > + #define X86_FEATURE_XTOPOLOGY       (3*32+21) /* cpu topology enum extensions */
> 
> I had earler sent a patch to fix this.
> http://marc.info/?l=linux-kernel&m=122341178202930&w=2
> 
> But, somehow I don’t see this patch either in Linus's git or in tip.
I confirm it does fix the issues. But the patch need to be ported to 2.6.28-rc2.


