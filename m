Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933602Ab0BYUD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 15:03:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48024 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933525Ab0BYUDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 15:03:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Subject: Re: s2disk hang update
Date: Thu, 25 Feb 2010 21:04:51 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rjw; KDE/4.3.5; x86_64; ; )
Cc: Mel Gorman <mel@csn.ul.ie>, hugh.dickins@tiscali.co.uk,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Linux MM <linux-mm@kvack.org>
References: <9b2b86521001020703v23152d0cy3ba2c08df88c0a79@mail.gmail.com> <201002242152.55408.rjw@sisk.pl> <9b2b86521002250510m75c8b314o37388a04b53a2b67@mail.gmail.com>
In-Reply-To: <9b2b86521002250510m75c8b314o37388a04b53a2b67@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002252104.51187.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 February 2010, Alan Jenkins wrote:
> On 2/24/10, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Wednesday 24 February 2010, Alan Jenkins wrote:
...
> 
> > -	while (to_free_normal > 0 && to_free_highmem > 0) {
> > +	while (to_free_normal > 0 || to_free_highmem > 0) {
> 
> Yes, that seems to do it.  No more hangs so far (and I can still
> reproduce the hang with too many applications if I un-apply the
> patch).

OK, great.  Is this with or without the NOIO-enforcing patch?

> I did see a non-fatal allocation failure though, so I'm still not sure
> that the current implementation is strictly correct.
> 
> This is without the patch to increase "to_free_normal".  If I get the
> allocation failure again, should I try testing the "free 20% extra"
> patch?

Either that or try to increase SPARE_PAGES.  That should actually work with
the last patch applied. :-)

Rafael
