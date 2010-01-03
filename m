Return-Path: <linux-kernel-owner+w=401wt.eu-S1752250Ab0ACXrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab0ACXrI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 18:47:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837Ab0ACXrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 18:47:06 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54255 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab0ACXrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 18:47:03 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 4 Jan 2010 08:43:47 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 2/3 -mmotm-2009-12-10-17-19] Count zero page as file_rss
Message-Id: <20100104084347.c36d9855.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.LSU.2.00.0912301619500.3369@sister.anvils>
References: <ceeec51bdc2be64416e05ca16da52a126b598e17.1258773030.git.minchan.kim@gmail.com>
	<ae2928fe7bb3d94a7ca18d3b3274fdfeb009803a.1258773030.git.minchan.kim@gmail.com>
	<4B38876F.6010204@gmail.com>
	<alpine.LSU.2.00.0912301619500.3369@sister.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Dec 2009 16:49:52 +0000 (GMT)
Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:

> > > 
> > > Kame reported following as
> > > "Before starting zero-page works, I checked "questions" in lkml and
> > > found some reports that some applications start to go OOM after zero-page
> > > removal.
> > > 
> > > For me, I know one of my customer's application depends on behavior of
> > > zero page (on RHEL5). So, I tried to add again it before RHEL6 because
> > > I think removal of zero-page corrupts compatibility."
> > > 
> > > So how about adding zero page as file_rss again for compatibility?
> 
> I think not.
> 
> KAMEZAWA-san can correct me (when he returns in the New Year) if I'm
> wrong, but I don't think his customer's OOMs had anything to do with
> whether the ZERO_PAGE was counted in file_rss or not: the OOMs came
> from the fact that many pages were being used up where just the one
> ZERO_PAGE had been good before.  Wouldn't he have complained if the
> zero_pfn patches hadn't solved that problem?
> 
> You are right that I completely overlooked the issue of whether to
> include the ZERO_PAGE in rss counts (now being a !vm_normal_page,
> it was just natural to leave it out); and I overlooked the fact that
> it used to be counted into file_rss in the old days (being !PageAnon).
> 
> So I'm certainly at fault for that, and thank you for bringing the
> issue to attention; but once considered, I can't actually see a good
> reason why we should add code to count ZERO_PAGEs into file_rss now.
> And if this patch falls, then 1/3 and 3/3 would fall also.
> 
> And the patch below would be incomplete anyway, wouldn't it?
> There would need to be a matching change to zap_pte_range(),
> but I don't see that.
> 
> We really don't want to be adding more and more ZERO_PAGE/zero_pfn
> tests around the place if we can avoid them: KOSAKI-san has a strong
> argument for adding such a test in kernel/futex.c, but I don't the
> argument here.
> 

I agree that ZERO_PAGE shouldn't be counted as rss. Now, I feel that old
counting method(in old zero-page implementation) was bad.

Minchan-san, I'm sorry for noise.

Thanks,
-Kame



