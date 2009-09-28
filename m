Return-Path: <linux-kernel-owner+w=401wt.eu-S1752304AbZI1JPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbZI1JPP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 05:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbZI1JPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 05:15:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:45371 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbZI1JPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 05:15:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,465,1249282800"; 
   d="scan'208";a="497520923"
Subject: Re: [BUGFIX -v2] x86, mce, inject: Make injected mce valid only
 during faked handler call
From: Huang Ying <ying.huang@intel.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4AC07AE4.7010203@jp.fujitsu.com>
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com>
	 <4AC05A57.1080505@jp.fujitsu.com>
	 <1254121753.15717.1373.camel@yhuang-dev.sh.intel.com>
	 <4AC06D96.4000508@jp.fujitsu.com>
	 <1254126457.15717.1405.camel@yhuang-dev.sh.intel.com>
	 <4AC07AE4.7010203@jp.fujitsu.com>
Content-Type: text/plain
Date: Mon, 28 Sep 2009 17:15:16 +0800
Message-Id: <1254129316.15717.1418.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-28 at 16:59 +0800, Hidetoshi Seto wrote:
[snip] 
> >>>> I believe what you want to do here is "make mce_rdmsrl()/mce_wrmsrl()
> >>>> to refer faked data only during faked handler call."
> >>>> Then what we have to do is making a flag to indicate that "now
> >>>> in faked handler call," for an example:
> >>>>
> >>>>     309         if (__get_cpu_var(mce_fake_in_progress)) {
> >>>>
> >>>> and:
> >>>> 	local_irq_save(flags);
> >>>> 	__get_cpu_var(mce_fake_in_progress) = 1;
> >>>> 	machine_check_poll(0, &b);
> >>>> 	__get_cpu_var(mce_fake_in_progress) = 0;
> >>>> 	local_irq_restore(flags);
> >>> I don't think this method is better than the original one. They are just
> >>> equivalent. 
> >> No, you changed usage of .finished, and transfer the functionality of the
> >> flag to newly introduced MCJ_LOADED.
> >> We can keep .finished as is, and introduce one new flag for this.
> > 
> > You just use .finished as MCJ_LOADED and mce_fake_in_progress
> > as .finished.
> 
> I just recommends you to keep .finished as a flag indicates "loading finished."

.finished can be "injecting finished, ready to be consumed". So I don't
think there is much difference.

> > Use a per-CPU variable mce_fake_in_progress make it hard to add support
> > to inject multiple MCEs in one CPU.
> 
> Why?  I think it can with such per-cpu flag.

Oh. It works too.

Best Regards,
Huang Ying


