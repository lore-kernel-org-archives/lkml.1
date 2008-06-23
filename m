Return-Path: <linux-kernel-owner+w=401wt.eu-S1760080AbYFWQJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760080AbYFWQJM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 12:09:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754848AbYFWQJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 12:09:00 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:47590 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771AbYFWQI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 12:08:59 -0400
Date: Mon, 23 Jun 2008 17:04:54 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oleg Nesterov <oleg@tv-sign.ru>, Nick Piggin <npiggin@suse.de>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>
Subject: Re: [patch 2/5] Reinstate ZERO_PAGE optimization in get_user_pages()
 and fix XIP
In-Reply-To: <b6a2187b0806230832j10e8be28vc0b05fea233437fa@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0806231650190.13651@blonde.site>
References: <20080622185327.348377223@mini.kroah.org>  <20080622190140.GD20141@suse.de>
  <alpine.LFD.1.10.0806221220530.2926@woody.linux-foundation.org> 
 <20080622202950.GB20800@suse.de> <b6a2187b0806230832j10e8be28vc0b05fea233437fa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2008, Jeff Chua wrote:
> On Mon, Jun 23, 2008 at 4:29 AM, Greg KH <gregkh@suse.de> wrote:
> > On Sun, Jun 22, 2008 at 12:22:47PM -0700, Linus Torvalds wrote:
> >> Let's wait for the vmware breakage report to sort out first.
> >>       http://lkml.org/lkml/2008/6/22/10
> >> before moving it to -stable.
> >
> > Sure, thanks for pointing that out to me, I'll track it as well.
> 
> I can confirm that the 2nd patch from Linus fixed the problem.
> 
>                http://lkml.org/lkml/2008/6/22/107
> 
> Sorry it took so long. Traveling.

Long?!  That was very quick, thanks for reporting back.

But I'm afraid you've pushed me into taking another look at that
patch, and I see a problem with it.  To be honest, I've lost the
plot on this issue, and didn't really get what your problem is,
nor how Linus expected to be fixing it.

The problem is that "insane" VM_LOCKED test which he has removed.
I've remembered now what that's about: it's for make_pages_present.
We do want mlocking a readonly area to make its pages present, even
if they're not at this moment writable: we don't want the ZERO_PAGE
substitution in that case.

So I think Linus needs to factor that into the final patch,
whilst at the same time solving whatever is the vmware breakage.

Hugh
