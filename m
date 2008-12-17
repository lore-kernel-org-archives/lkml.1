Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758652AbYLQLn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652AbYLQLn0 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 06:43:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbYLQLnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 06:43:16 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48111 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbYLQLnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 06:43:15 -0500
Date: Wed, 17 Dec 2008 12:42:56 +0100
From: Jiri Pirko <jpirko@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        "Oleg Nesterov" <oleg@redhat.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Michael Kerrisk" <mtk.manpages@googlemail.com>,
        linux-api@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
        jlim@sgi.com
Subject: Re: [PATCH, RESEND2] getrusage: fill ru_maxrss value
Message-ID: <20081217124256.46883fae@psychotron.englab.brq.redhat.com>
In-Reply-To: <20081217194646.F677.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081217105639.63e765eb@psychotron.englab.brq.redhat.com>
	<20081217194646.F677.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2008 19:48:44 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > (updated)
> > 
> > This patch makes ->ru_maxrss value in struct rusage filled accordingly to
> > rss hiwater mark. This struct is filled as a parameter to
> > getrusage syscall. ->ru_maxrss value is set to pages which might be correct
> > as "time" application converts it to KBs.
> 
> Why?
> if kernel convert to KB, glibc don't need any change.
Where exactly glibc is working with this as KBs? I can't find that place.

I looked into sources of time util and maxrss is showed this way:
fprintf (fp, "%lu", ptok ((UL) resp->ru.ru_maxrss));
ptok() actually does pages_to_KB conversion. If we convert to KB in
kernel, this code must be changed.
> 
> 
> 
