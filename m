Return-Path: <linux-kernel-owner+w=401wt.eu-S1751758AbZLIQ6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758AbZLIQ6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 11:58:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbZLIQ6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 11:58:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43985 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750856AbZLIQ6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 11:58:21 -0500
Date: Wed, 9 Dec 2009 08:57:32 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async resume patch (was: Re: [GIT PULL] PM updates for 2.6.33)
In-Reply-To: <20091209164653.GI9018@sirena.org.uk>
Message-ID: <alpine.LFD.2.00.0912090851540.3560@localhost.localdomain>
References: <20091209160256.GA3229@rakim.wolfsonmicro.main> <Pine.LNX.4.44L0.0912091117080.4120-100000@iolanthe.rowland.org> <20091209164653.GI9018@sirena.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Dec 2009, Mark Brown wrote:

> > How long does it take to bring down the entire embedded audio 
> > subsystem?  And how critical is the timing for typical systems?
> 
> Worst case is about a second for both resume and suspend which means two
> seconds total but it's very hardware dependant.  

I would seriously suggest just looking at the code itself.

Maybe the code is just plain sh*t? If we're talking embedded audio, we're 
generally talking SoC chips (maybe some external audio daughtercard), and 
quite frankly, it sounds to me like you're just wasting your own time. 
There is no way that kind of hardware really needs that much time.

We should not design the device infrastructure for crap coding. 

Now, I can easily see one-second delays in code that simply has never been 
thought about or cared about it. We used to have things like that in the 
serial code where just probing for non-existent serial ports took half a 
second per port because there was a timeout. 

But christ, using that as an argument for "we should do things 
asynchronously" sounds like a crazy idea. Why not just take a hard look at 
the driver in question, asking hard questions like "does it really need to 
do something horrible like that"?

Because bad coding is much more likely to be the real reason.

			Linus
