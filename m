Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbZLIRTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbZLIRTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 12:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbZLIRTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 12:19:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46064 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754008AbZLIRTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 12:19:47 -0500
Date: Wed, 9 Dec 2009 09:19:46 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Stern <stern@rowland.harvard.edu>
cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async resume patch (was: Re: [GIT PULL] PM updates for 2.6.33)
In-Reply-To: <Pine.LNX.4.44L0.0912091204550.4120-100000@iolanthe.rowland.org>
Message-ID: <alpine.LFD.2.00.0912090914330.3560@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912091204550.4120-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Dec 2009, Alan Stern wrote:
> 
> If audio _is_ being played when a suspend occurs, users probably don't 
> mind audible artifacts.  In fact, they probably expect some.

I'd say it's physically impossible not to get them. If you're really 
suspending your audio hardware, it _will_ be quiet ;)

I suspect somebody is draining existing queues or something, or just 
probing for an external analog part. Neither of which is really sensible 
or absolutely required in an embedded suspend/resume kind of situation.

Especially for STR, just "leave all the data structures around, and just 
stop the DMA engine" is often a perfectly fine solution - but drivers 
don't do it, exactly because we've often had the mentality that you 
re-initialize everything under the sun.

I can see _why_ a driver would do that ("we re-use the same code that we 
use on close/open or module unload/reload"), but it doesn't change the 
fact that it's stupid to do if you worry about latency. 

And yeah, turning it async might hide the problem. But the code word there 
is "hide" rather than "fix".

			Linus
