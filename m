Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807AbZELF57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbZELF57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 01:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbZELF5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 01:57:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60399 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbZELF5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 01:57:49 -0400
Subject: Re: [RFC][PATCH] Multimedia scheduling class, take 2
From: Peter Zijlstra <peterz@infradead.org>
To: Jussi Laako <jussi@sonarnerd.net>
Cc: James Courtier-Dutton <James@superbug.co.uk>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, d.faggioli@sssup.it
In-Reply-To: <4A07E044.8040807@sonarnerd.net>
References: <4959198A.3020209@sonarnerd.net>
	 <1230622925.16718.26.camel@twins>  <4959DE51.2020605@sonarnerd.net>
	 <1231756114.19771.6.camel@laptop> <496C6294.2040707@sonarnerd.net>
	 <4971D3D5.6040801@superbug.co.uk>  <497CF128.2060903@sonarnerd.net>
	 <1232954745.4863.4.camel@laptop>  <4A07E044.8040807@sonarnerd.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 12 May 2009 07:57:39 +0200
Message-Id: <1242107859.11251.301.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-11 at 11:22 +0300, Jussi Laako wrote:
> Hi,
> 
> Peter Zijlstra wrote:
> > Right, and I think the solution to this problem is twofold, 1)
> > application writers should start writing (soft) realtime applications if
> > they want (soft) realtime behaviour -- there's just no way around that.
> 
> Just to avoid need for reviewing and reworking ~800 klocs of user space
> code in just gstreamer, here's a second take on patches. This time
> splitting things into smaller pieces. Attached patch exposes 40
> priorities ~ nice values as something accessible through
> sched_()/pthreads API in order to control priorities of individual
> threads. Current Linux implementation of SCHED_OTHER is broken in a way,
> that it exposes only one single priority level - 0. Thus no possibility
> to properly control priorities of threads through pthread API. This is
> patch is against 2.6.29.2 and not tested, but builds. I can also send
> rest of the changes as separate small feature patches as needed.
> However, before doing any more work I would like to hear opinions on
> this and especially what is wrong with the code or idea...
> 
> > And 2), the kernel can help by providing a deadline based scheduler,
> > which should make the above easier and less likely to mess up the rest
> > of the system. ie. a deadline scheduled application will not exceed its
> > allotted budget, unlike a FIFO scheduled app.
> 
> Any news on this one?

Utter lack of time on my side to work on any of the problems there.

As to the patch, I still think its an exceedingly bad idea to create
such a horridly ill defined scheduler class. There's nothing that keeps
people from stuffing everything in there and either generating DoS
issues or still generating bad interactivity.

I certainly don't think the current situation is bad enough to warrant
things like that, media on my machines works peachy (*cheer* for XV on
R600).

I happen to know that Dario (CC'ed) has been working on a userspace
framework to ease the use of writing soft-realtime (soft as in media
based applications) in C, mitigating a lot of the risks of using
SCHED_FIFO and the like.

Perhaps he's willing to expand on that.
