Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbYHTHYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbYHTHYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 03:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752452AbYHTHYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 03:24:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49548 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbYHTHYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 03:24:43 -0400
Subject: Re: [PATCH] sched: disable hrtick implementation
From: Peter Zijlstra <peterz@infradead.org>
To: Justin Madru <jdm64@gawab.com>
Cc: Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       Michal Januszewski <spock@gentoo.org>,
       Antonino Daplas <adaplas@gmail.com>, Rafael Wysocki <rjw@sisk.pl>,
       Romano Giannetti <romano.giannetti@gmail.com>,
       Adrian Bunk <bunk@kernel.org>,
       Jeremy Nickurak <kernel-bugs@atrus.rifetech.com>
In-Reply-To: <48AB4F2B.9070405@gawab.com>
References: <48A9BDC0.9070800@gawab.com> <20080819003110.GH9914@elte.hu>
	 <1219127296.10800.357.camel@twins> <20080819092543.GD28713@elte.hu>
	 <1219138380.10800.376.camel@twins> <20080819182222.GA25576@suse.de>
	 <48AB1F49.6040207@gawab.com> <20080819194428.GA9997@suse.de>
	 <48AB4F2B.9070405@gawab.com>
Content-Type: text/plain
Date: Wed, 20 Aug 2008 09:24:51 +0200
Message-Id: <1219217091.10800.395.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-19 at 15:54 -0700, Justin Madru wrote:
> The hrtick implementation in 2.6.25 and .26 has been known to cause boot
> problems with at least Intel GMA cards. see:
> 
>  https://bugs.freedesktop.org/show_bug.cgi?id=15602
>  http://bugzilla.kernel.org/show_bug.cgi?id=10892
> 
> A full fix to hrtick went into 2.6.27 
> (31656519e132f6612584815f128c83976a9aaaef),
> but that fix is too intrusive to backport. Henceforth, we default to 
> disable hrtick.

Thing is, I'm still not understanding how, or if, the old code is wrong.

That said, this will paper over the problem just fine, and as its old
kernels we're talking about I don't particularly care.

Just occured to me that a Kconfig change that always makes
CONFIG_SCHED_HRTICK not set will also do.

> Signed-off-by: Justin Madru <jdm64@gawab.com>
> Tested-by: Justin Madru <jdm64@gawab.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> 
> --- a/kernel/sched_features.h
> +++ b/kernel/sched_features.h
> @@ -4,7 +4,7 @@
>  SCHED_FEAT(AFFINE_WAKEUPS, 1)
>  SCHED_FEAT(CACHE_HOT_BUDDY, 1)
>  SCHED_FEAT(SYNC_WAKEUPS, 1)
> -SCHED_FEAT(HRTICK, 1)
> +SCHED_FEAT(HRTICK, 0)
>  SCHED_FEAT(DOUBLE_TICK, 0)
>  SCHED_FEAT(NORMALIZED_SLEEPER, 1)
>  SCHED_FEAT(DEADLINE, 1)
> 

