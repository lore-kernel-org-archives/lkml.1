Return-Path: <linux-kernel-owner+w=401wt.eu-S932619AbXCKVwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619AbXCKVwM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 17:52:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932696AbXCKVwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 17:52:12 -0400
Received: from mail16.syd.optusnet.com.au ([211.29.132.197]:52442 "EHLO
	mail16.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932619AbXCKVwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 17:52:11 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Al Boldi <a1426z@gawab.com>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler
Date: Mon, 12 Mar 2007 08:52:05 +1100
User-Agent: KMail/1.9.5
Cc: ck list <ck@vds.kolivas.org>, linux-kernel@vger.kernel.org
References: <200703042335.26785.a1426z@gawab.com> <200703061815.16702.a1426z@gawab.com> <200703112111.38415.a1426z@gawab.com>
In-Reply-To: <200703112111.38415.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703120852.05857.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 March 2007 05:11, Al Boldi wrote:
> Al Boldi wrote:
> > BTW, another way to show these hickups would be through some kind of a
> > cpu/proc timing-tracer.  Do we have something like that?
>
> Here is something like a tracer.
>
> Original idea by Chris Friesen, thanks, from this post:
> http://marc.theaimsgroup.com/?l=linux-kernel&m=117331003029329&w=4
>
> Try attached chew.c like this:
> Boot into /bin/sh.
> Run chew in one console.
> Run nice chew in another console.
> Watch timings.
>
> Console 1: ./chew

> Console 2: nice -10 ./chew

> pid 669, prio  10, out for    5 ms
> pid 669, prio  10, out for   65 ms

One full expiration

> pid 669, prio  10, out for    6 ms
> pid 669, prio  10, out for   65 ms

again

> Console 2: nice -15 ./chew
> pid 673, prio  15, out for    6 ms
> pid 673, prio  15, out for   95 ms

again and so on..

> OTOH, mainline is completely smooth, albeit huge drop-outs.

Heh. That's not much good either is it.

> Thanks!

And thank you! I think I know what's going on now. I think each rotation is 
followed by another rotation before the higher priority task is getting a 
look in in schedule() to even get quota and add it to the runqueue quota. 
I'll try a simple change to see if that helps. Patch coming up shortly.

-- 
-ck
