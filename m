Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759945AbYLQMDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759945AbYLQMDt (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 07:03:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbYLQMDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 07:03:35 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39301 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbYLQMDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 07:03:34 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Jiri Pirko <jpirko@redhat.com>
Subject: Re: [PATCH, RESEND2] getrusage: fill ru_maxrss value
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        "Oleg Nesterov" <oleg@redhat.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Michael Kerrisk" <mtk.manpages@googlemail.com>,
        linux-api@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
        jlim@sgi.com
In-Reply-To: <20081217124256.46883fae@psychotron.englab.brq.redhat.com>
References: <20081217194646.F677.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081217124256.46883fae@psychotron.englab.brq.redhat.com>
Message-Id: <20081217204607.FF25.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Wed, 17 Dec 2008 21:03:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > This patch makes ->ru_maxrss value in struct rusage filled accordingly to
> > > rss hiwater mark. This struct is filled as a parameter to
> > > getrusage syscall. ->ru_maxrss value is set to pages which might be correct
> > > as "time" application converts it to KBs.
> > 
> > Why?
> > if kernel convert to KB, glibc don't need any change.
> Where exactly glibc is working with this as KBs? I can't find that place.
> 
> I looked into sources of time util and maxrss is showed this way:
> fprintf (fp, "%lu", ptok ((UL) resp->ru.ru_maxrss));
> ptok() actually does pages_to_KB conversion. If we convert to KB in
> kernel, this code must be changed.

Ah, you talked about /usr/bin/time? sorry, I misunderstood a bit.
Why time need number of pages?

In general, getrusage()::ru_maxrss is bsd compatibility feature.
as far as possible, the same syscall spec is better.
and bsd use KB unit.

if time command has reasonable reason, I can agree current design.
but is there?



