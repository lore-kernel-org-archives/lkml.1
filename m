Return-Path: <linux-kernel-owner+w=401wt.eu-S1754916AbZCKBZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbZCKBZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 21:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbZCKBZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 21:25:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:47301 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbZCKBZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 21:25:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,338,1233561600"; 
   d="scan'208";a="118940513"
Date: Wed, 11 Mar 2009 09:23:58 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "stable@kernel.org" <stable@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] proc: fix kflags to uflags copying in /proc/kpageflags
Message-ID: <20090311012358.GA9011@localhost>
References: <20090311010004.GA8237@localhost> <20090311101612.A7FD.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311101612.A7FD.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 03:17:58AM +0200, KOSAKI Motohiro wrote:
> > Fix kpf_copy_bit(src,dst) to be kpf_copy_bit(dst,src) to match the
> > actual call patterns, e.g. kpf_copy_bit(kflags, KPF_LOCKED, PG_locked).
> > 
> > This misplacement of src/dst only affected reporting of PG_writeback,
> > PG_reclaim and PG_buddy. For others kflags==uflags so not affected.
> > 
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > ---
> > 
> > This is a tested and trivial no-side-effect fix.
> > I'd suggest it for 2.6.29-rc7 and 2.6.28.X kernels.
> > 
> > diff --git a/fs/proc/page.c b/fs/proc/page.c
> > index 2d13451..e998383 100644
> > --- a/fs/proc/page.c
> > +++ b/fs/proc/page.c
> > @@ -80,7 +80,7 @@ static const struct file_operations proc_kpagecount_operations = {
> >  #define KPF_RECLAIM    9
> >  #define KPF_BUDDY     10
> >  
> > -#define kpf_copy_bit(flags, srcpos, dstpos) (((flags >> srcpos) & 1) << dstpos)
> > +#define kpf_copy_bit(flags, dstpos, srcpos) (((flags >> srcpos) & 1) << dstpos)
> 
> Good catch! :)
> 	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Thank you :)

> 
> but don't worry. the number of this interface user is very few.

Yeah, so few users that I have to write the tools by myself ;-)

Thanks,
Fengguang

