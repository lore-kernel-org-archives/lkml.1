Return-Path: <linux-kernel-owner+w=401wt.eu-S1751528AbZLaInq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbZLaInq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 03:43:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751047AbZLaInp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 03:43:45 -0500
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:64001 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750898AbZLaIno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 03:43:44 -0500
X-Trace: 314146990/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.28.176/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.28.176
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: Alpine 2.00 (LSU 1167 2008-08-23)
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApwBAFvzO0tPRRyw/2dsb2JhbAAI1ByEMQQ
X-IronPort-AV: E=Sophos;i="4.47,480,1257120000"; 
   d="scan'208";a="314146990"
Date: Thu, 31 Dec 2009 08:43:39 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Minchan Kim <minchan.kim@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 2/3 -mmotm-2009-12-10-17-19] Count zero page as
 file_rss
In-Reply-To: <28c262360912301841r3ed43d31yc677fbc3a01fe5bb@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.0912310833560.26642@sister.anvils>
References: <ceeec51bdc2be64416e05ca16da52a126b598e17.1258773030.git.minchan.kim@gmail.com>  <ae2928fe7bb3d94a7ca18d3b3274fdfeb009803a.1258773030.git.minchan.kim@gmail.com>  <4B38876F.6010204@gmail.com>  <alpine.LSU.2.00.0912301619500.3369@sister.anvils>
 <28c262360912301841r3ed43d31yc677fbc3a01fe5bb@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Dec 2009, Minchan Kim wrote:
> On Thu, Dec 31, 2009 at 1:49 AM, Hugh Dickins
> <hugh.dickins@tiscali.co.uk> wrote:
> >
> > You are right that I completely overlooked the issue of whether to
> > include the ZERO_PAGE in rss counts (now being a !vm_normal_page,
> > it was just natural to leave it out); and I overlooked the fact that
> > it used to be counted into file_rss in the old days (being !PageAnon).
> >
> > So I'm certainly at fault for that, and thank you for bringing the
> > issue to attention; but once considered, I can't actually see a good
> > reason why we should add code to count ZERO_PAGEs into file_rss now.
> > And if this patch falls, then 1/3 and 3/3 would fall also.
> >
> > And the patch below would be incomplete anyway, wouldn't it?
> > There would need to be a matching change to zap_pte_range(),
> > but I don't see that.
> 
> Thanks.
> If we think this patch is need, I will repost path with fix it.
> 
> What do you think?

If someone comes up with a convincing case in which their system
is behaving significantly worse because the zero page is not being
counted in rss now, then we shall probably want your patch.

But I still don't yet see a reason to add code just to keep the
anon_rss+file_rss number looking the same as it was before, in this
exceptional case where there's a significant number of zero pages.

Hugh
