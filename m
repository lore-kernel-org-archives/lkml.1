Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbXGBRvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbXGBRvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 13:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbXGBRvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 13:51:06 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34313 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752727AbXGBRvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 13:51:05 -0400
Date: Mon, 2 Jul 2007 10:50:00 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: blink driver power saving
Message-ID: <20070702105000.73e50500@freepuppy.localdomain.hemminger.net>
In-Reply-To: <200707020159.51200.ak@suse.de>
References: <20070701125035.3f54d8b0@oldman>
	<200707012329.52918.ak@suse.de>
	<alpine.LFD.0.98.0707011511120.3323@woody.linux-foundation.org>
	<200707020159.51200.ak@suse.de>
Organization: Linux Foundation
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.13; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jul 2007 01:59:50 +0200
Andi Kleen <ak@suse.de> wrote:

> On Monday 02 July 2007 00:14, Linus Torvalds wrote:
> > On Sun, 1 Jul 2007, Andi Kleen wrote:
> > > What is so bad with it? Note it's a debugging facility and used
> > > for kcrash kernels where the video output doesn't work. But they
> > > normally only run a few minutes to dump the previous state to disk
> > > and then reboot.
> >
> > It has been a total disaster from beginning to end.
> >
> > It wastes power.
> 
> Again:
> It's not intended for normal kernels. It's a debugging feature.
> It's not intended for normal kernels. It's a debugging feature.
> It's not intended for normal kernels. It's a debugging feature.

It can be generally useful. Until/unless we get proper screen support,
how do you know hang from panic? If you can talk to some other
device it would help.

> Got it now? Power wasting or not just doesn't matter for it.
>  
> > It hangs machines when it tries to blink.
> 
> Yes, there seem to be more buggy keyboard controllers
> around than I anticipated. Very sad that IBM couldn't even
> get such a simple thing right.
> 
> Well only those that could be already hung from user space
> with setleds (that was also confirmed).  Actually I thought
> they didn't hang completely, but just stopped reacting to 
> the keyboard (which is actually pretty bad for every user
> to be able to trigger)
> 
> I guess the better way to handle those would be to find out the 
> minimum frequency of blinking that is still ok and rate limit it to that in 
> the keyboard driver. 
> 
> Anyways, Stephen's patch just doesn't make sense: 
> he clearly didn't understand the code at all. Before you
> apply it and cripple it better drop the driver completely.

The patch makes sense. You don't need to poll every jiffie to find
out if system has panic.  But I agree with Linus, it is the kind
of patch that doesn't belong in the mainline kernel.  Every developer
seems to have built up a set of crappy/fragile debug tools, but these
don't belong in the wild.



-- 
Stephen Hemminger <shemminger@linux-foundation.org>
