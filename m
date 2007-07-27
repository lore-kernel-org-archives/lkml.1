Return-Path: <linux-kernel-owner+w=401wt.eu-S1764339AbXG0Qmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764339AbXG0Qmk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 12:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbXG0Qmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 12:42:32 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:15321 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbXG0Qmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 12:42:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=bhJ2k1gA2hS0IwM8XQDKSh4pe8oeepPjNE9Q+wFTTG2wk/B6QnuWoipBD2Ja73trzvyi7Ee1So2H5gw72RvtPpSBKWPvLQh33xMXDikFMItD/DHM+lIxPgIjYz8AqhlFrQ7Btc+4WNyyheqlNIptKNGYx9j2yBsV/YwUN5FtpmY=
Message-ID: <2c0942db0707270942k784890a2ld44d1312dde02379@mail.gmail.com>
Date: Fri, 27 Jul 2007 09:42:27 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Douglas J Hunley" <doug@hunley.homeip.net>
Subject: Re: solving(?) the updatedb problem w/ the kernel cache
Cc: slocate@trakker.ca, linux-kernel@vger.kernel.org
In-Reply-To: <200707270855.26997.doug@hunley.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707270855.26997.doug@hunley.homeip.net>
X-Google-Sender-Auth: 0843426387fe8a43
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/27/07, Douglas J Hunley <doug@hunley.homeip.net> wrote:
> I've been following lkml for a little while (not understanding it all, but
> following nonetheless <g>) and I've noticed that in a lot of the talks about
> schedulers, elevators, and performance, the issue of running updatedb and its
> effects on the kernel's fs cache seems to recur. I've also yet to see anyone
> present a solution that others think is worth pursuing. I'm curious why we're
> trying to solve the problem, when we can simply avoid the problem to begin
> with by making use of inotify and introducing a new user-space
> daemon, 'located'.

inotify doesn't scale for lots of directories. I have about 18,000
directories under ~ on my laptop, and that's with a few source trees
that I use infrequently tarballed up.

But yes, if we had a full filesystem events notifier, then we could
just toss updatedb aside and have the benefit of a live index into the
system. It's been suggested before, at least by me. Other projects
want this as well, such as an on-demand virus scanner, or a live
backup to another site, or beagle/tracker who would like to index
documents on the fly. beagled already uses inotify, I think, but as it
takes over my system (in a bad way) whenever I tried to run it, I had
no choice but to remove it.

Perhaps it was choking on the 18k subdirectories, dunno.

Ray
