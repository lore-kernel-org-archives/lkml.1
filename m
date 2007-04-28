Return-Path: <linux-kernel-owner+w=401wt.eu-S1030726AbXD1V0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030726AbXD1V0H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 17:26:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030862AbXD1V0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 17:26:07 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47922 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030726AbXD1V0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 17:26:04 -0400
Date: Sat, 28 Apr 2007 14:25:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pavel Machek <pavel@ucw.cz>, Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: Back to the future.
In-Reply-To: <200704281950.30405.rjw@sisk.pl>
Message-ID: <alpine.LFD.0.98.0704281421140.9964@woody.linux-foundation.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net>
 <20070428085000.GA3293@elf.ucw.cz> <alpine.LFD.0.98.0704280926140.9964@woody.linux-foundation.org>
 <200704281950.30405.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 28 Apr 2007, Rafael J. Wysocki wrote:
> > 
> > The freezer has *caused* those deadlocks (eg by stopping threads that were 
> > needed for the suspend writeouts to succeed!), not solved them.
> 
> I can't remember anything like this, but I believe you have a specific test
> case in mind.

Ehh.. Why do you thik we _have_ that PF_NOFREEZE thing in the first place?

Rafael, you really don't know what you're talking about, do you?

Just _look_ at them. It's the IO threads etc that shouldn't be frozen, 
exactly *because* they do IO. You claim that kernel threads shouldn't do 
IO, but that's the point: if you cannot do IO when snapshotting to disk, 
here's a damn big clue for you: how do you think that snapshot is going to 
get written?

I *guarantee* you that we've had a lot more problems with threads that 
should *not* have been frozen than with those hypothetical threads that 
you think should have been frozen.

			Linus
