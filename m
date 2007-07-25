Return-Path: <linux-kernel-owner+w=401wt.eu-S1759982AbXGYItr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759982AbXGYItr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 04:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbXGYItj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 04:49:39 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33713 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752340AbXGYIti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 04:49:38 -0400
Date: Wed, 25 Jul 2007 01:49:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch] fix the softlockup watchdog to actually work
Message-Id: <20070725014912.35c7e325.akpm@linux-foundation.org>
In-Reply-To: <20070717154934.GA24231@elte.hu>
References: <20070717114453.GA8212@elte.hu>
	<469CCF8F.4010107@goop.org>
	<20070717154934.GA24231@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007 17:49:34 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> this Xen related commit:
> 
>    commit 966812dc98e6a7fcdf759cbfa0efab77500a8868
>    Author: Jeremy Fitzhardinge <jeremy@goop.org>
>    Date:   Tue May 8 00:28:02 2007 -0700
> 
>        Ignore stolen time in the softlockup watchdog
> 
> broke the softlockup watchdog to never report any lockups. (!)
> 
> print_timestamp defaults to 0, this makes the following condition
> always true:
> 
> 	if (print_timestamp < (touch_timestamp + 1) ||
> 
> and we'll in essence never report soft lockups.
> 
> apparently the functionality of the soft lockup watchdog was never
> actually tested with that patch applied ...
> 
> [this is -stable material too.]

Still isn't working.  I'm getting random meaningless softlockup trippings
coming out for no apparent reason.

I guess softlockup is otherwise busted and this patch enables that
bustedness to be seen.

One possibility is that sched_clock() is bollixed and (say) it's returning
a 32-bit value.  That'll cause the softlockup logic to get a bit sick when
time wraps.

This machine (yes it's the Vaio) has marked the TSC unstable but afaict
that's OK.

So I'll shelve this patch for now.


I'm pretty heartily tired of the softlockup thing btw - it's been way more
trouble than benefit.  Which is strange, for such a simple thing.
