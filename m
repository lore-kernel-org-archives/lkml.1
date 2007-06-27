Return-Path: <linux-kernel-owner+w=401wt.eu-S1761650AbXF0Sdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761650AbXF0Sdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 14:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757259AbXF0SdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 14:33:23 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:48828 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbXF0SdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 14:33:23 -0400
Date: Wed, 27 Jun 2007 19:32:47 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Davide Libenzi <davidel@xmailserver.org>
cc: Ulrich Drepper <drepper@gmail.com>, blaisorblade@yahoo.it,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/3] MAP_NOZERO - implement sys_brk2()
In-Reply-To: <Pine.LNX.4.64.0706271111040.32731@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0706271921280.29060@blonde.wat.veritas.com>
References: <send-serie.davidel@xmailserver.org.29496.1182912260.2> 
 <a36005b50706262048y5eb8ba80kb0d852d649d1ac10@mail.gmail.com> 
 <Pine.LNX.4.64.0706262052060.26540@alien.or.mcafeemobile.com> 
 <a36005b50706262202w4aaa4494qc2322e49c71d8d7c@mail.gmail.com> 
 <Pine.LNX.4.64.0706271309500.26951@blonde.wat.veritas.com>
 <a36005b50706271001o191f3e24n83b25988739429fb@mail.gmail.com>
 <Pine.LNX.4.64.0706271807330.22337@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706271111040.32731@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABGluYm94AGJsYWlzb3JibGFkZUB5YWhvby5pdABkYXZpZGVsQHhtYWlsc2VydmVyLm9yZwBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnAGRyZXBwZXJAZ21haWwuY29tAA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007, Davide Libenzi wrote:
> On Wed, 27 Jun 2007, Hugh Dickins wrote:
> 
> > In honesty, I should add that I dislike and distrust Davide's
> > MAP_NOZERO very much indeed!  Would much rather leave my cpus
> > spending a little time in clear_page().  A uid in struct page
> > (though I'm sure we could find somewhere to tuck it away) -
> > the horror, the horror!  But I've so far failed to find a killer
> > argument against it, and am hoping for someone else to do so.
> 
> Little time? Please, do not trust me. Start oprofile and run a kernel 
> build. Look, I'm not even talking about som micro benchmark explicitly 
> built to exploit the thing. A kernel build.
> You will find clear_page to be the *1st* kernel entry after cc1 and as.
> That is bad for two reasons. The time it spends in there, and the cache it 
> blows.

I don't doubt that it shows real benefits; but dangerously cutting
corners usually shows benefits too.  Relying on a uid at this level
feels very wrong to me - but as I said, I've not found a killer
argument against it.

And we both know that clear_page features so high in part because
it's bringing cachelines in from the cold, which are about to be
accessed again by userspace; so it's often not so bad as it appears.

Though I probably wouldn't be citing that argument if we were
talking about offloading clear_page to another engine.

Hugh
