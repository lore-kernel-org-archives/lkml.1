Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753838AbYLRCuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbYLRCuh (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 21:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbYLRCuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 21:50:20 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44174 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643AbYLRCuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 21:50:18 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Jiri Pirko <jpirko@redhat.com>
Subject: Re: [PATCH, RESEND2] getrusage: fill ru_maxrss value
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        "Oleg Nesterov" <oleg@redhat.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Michael Kerrisk" <mtk.manpages@googlemail.com>,
        linux-api@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
        jlim@sgi.com
In-Reply-To: <20081217155239.77e58da0@psychotron.englab.brq.redhat.com>
References: <20081217204607.FF25.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081217155239.77e58da0@psychotron.englab.brq.redhat.com>
Message-Id: <20081218111608.615F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu, 18 Dec 2008 11:50:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Ah, you talked about /usr/bin/time? sorry, I misunderstood a bit.
> > Why time need number of pages?
> > 
> > In general, getrusage()::ru_maxrss is bsd compatibility feature.
> > as far as possible, the same syscall spec is better.
> > and bsd use KB unit.
> Oh you are right. Now I searched it in FreeBSD kernel. They goes like this:
> rss = pgtok(vmspace_resident_count(vm));
> if (ru->ru_maxrss < rss)
> 	ru->ru_maxrss = rss;
> 
> Seems pretty reasonable to stick with the same behavior. Then I really
> do not understand why /usr/bin/time does the conversion.

me too ;-)

> FreeBSD /usr/bin/time is very different and much simpler and (of
> course) does not do this conversion.
> 
> So I suggest to change the patch to fill KB instead of pages and
> change /usr/bin/time to not do the conversion. What do you think?

Makes really much sense. thanks!!


