Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbYICSi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbYICSi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 14:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755969AbYICSiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 14:38:05 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:55700 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605AbYICSiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 14:38:03 -0400
X-IronPort-AV: E=Sophos;i="4.32,320,1217808000"; 
   d="scan'208";a="152017565"
From: Roland Dreier <rdreier@cisco.com>
To: Mike Isely <isely@pobox.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, LKML <linux-kernel@vger.kernel.org>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>
Subject: Re: CodingStyle question: multiple statements on a single line
References: <200809030021.00122.hverkuil@xs4all.nl>
	<ada7i9ufa7x.fsf@cisco.com>
	<Pine.LNX.4.64.0809021830400.17907@cnc.isely.net>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 03 Sep 2008 11:38:01 -0700
In-Reply-To: <Pine.LNX.4.64.0809021830400.17907@cnc.isely.net> (Mike Isely's
	message of "Tue, 2 Sep 2008 18:50:44 -0500 (CDT)")
Message-ID: <adaskshvzw6.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 03 Sep 2008 18:38:01.0943 (UTC) FILETIME=[32096E70:01C90DF4]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > <quote>
 > Don't put multiple statements on a single line unless you have
 > something to hide:
 > </quote>
 > 
 > Then what does "unless you have something to hide" refer to exactly?

I think it's a tongue-in-cheek way of saying "unless you're trying to
make your code hard to read."  In other words, don't do it.

 > So by that reasoning "if (a) b;" - provided it stays under 80 columns - 
 > should be even better.  It occupies less space so that more code can fit 
 > on the screen.

But it is visually hard to distinguish between the condition (a) and the
statement (b) that follows it.  And the arbitrary kernel rule is that we
don't use that style.

 > > And uniformity counts for a lot: most coding style rules are completely
 > > arbitrary, but having a uniform kernel style makes reading kernel code
 > > much easier.

 > What about drivers?  The statement has been made by others that there is 
 > a strong desire for outside drivers to be brought into mainline rather 
 > than being out-of-tree.  So must every chunk of code brought in this way 
 > be sanitized to this level of detail?  In many cases that can be a large 
 > (and some might say arbitrary) hurdle.

Of course having a uniform coding style is important for drivers too.
There are many cases where someone other than the original author is
debugging a driver and needs to read and understand the code, or where
someone is updating all in-tree drivers to cope with an API change and
must read and correctly change lots of driver code.

In general we are pretty lenient about driver code, as long as it pretty
much looks like kernel code.  But really, how much work is it to make a
one-time sweep over a driver and change

	if (a) {
		b;
	}

to

	if (a)
		b;

especially when you have an automated tool (checkpatch.pl) that can help
you find the places that would change?

 > That's great.  How does one reconcile this statement with subsystem 
 > maintainers who treat checkpatch.pl - which is the epitome of 
 > "mechanical rule" and has no notion of common sense - as the gatekeeper 
 > for all incoming changesets?

I don't know of any such maintainers.  In general if someone submitted a
patch that only triggered a few checkpatch warnings and gave a rationale
about why the remaining warnings shouldn't be worried about, then that
would be fine with me.

 - R.
