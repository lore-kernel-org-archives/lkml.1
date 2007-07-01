Return-Path: <linux-kernel-owner+w=401wt.eu-S1758544AbXGBAAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544AbXGBAAY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 20:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbXGBAAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 20:00:10 -0400
Received: from ns.suse.de ([195.135.220.2]:37913 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754342AbXGBAAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 20:00:09 -0400
From: Andi Kleen <ak@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: blink driver power saving
Date: Mon, 2 Jul 2007 01:59:50 +0200
User-Agent: KMail/1.9.1
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20070701125035.3f54d8b0@oldman> <200707012329.52918.ak@suse.de> <alpine.LFD.0.98.0707011511120.3323@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0707011511120.3323@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707020159.51200.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 July 2007 00:14, Linus Torvalds wrote:
> On Sun, 1 Jul 2007, Andi Kleen wrote:
> > What is so bad with it? Note it's a debugging facility and used
> > for kcrash kernels where the video output doesn't work. But they
> > normally only run a few minutes to dump the previous state to disk
> > and then reboot.
>
> It has been a total disaster from beginning to end.
>
> It wastes power.

Again:
It's not intended for normal kernels. It's a debugging feature.
It's not intended for normal kernels. It's a debugging feature.
It's not intended for normal kernels. It's a debugging feature.

Got it now? Power wasting or not just doesn't matter for it.
 
> It hangs machines when it tries to blink.

Yes, there seem to be more buggy keyboard controllers
around than I anticipated. Very sad that IBM couldn't even
get such a simple thing right.

Well only those that could be already hung from user space
with setleds (that was also confirmed).  Actually I thought
they didn't hang completely, but just stopped reacting to 
the keyboard (which is actually pretty bad for every user
to be able to trigger)

I guess the better way to handle those would be to find out the 
minimum frequency of blinking that is still ok and rate limit it to that in 
the keyboard driver. 

Anyways, Stephen's patch just doesn't make sense: 
he clearly didn't understand the code at all. Before you
apply it and cripple it better drop the driver completely.

-Andi
