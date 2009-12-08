Return-Path: <linux-kernel-owner+w=401wt.eu-S966753AbZLHWT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966753AbZLHWT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 17:19:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966719AbZLHWTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 17:19:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965718AbZLHWTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 17:19:23 -0500
Date: Tue, 8 Dec 2009 14:18:57 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Stern <stern@rowland.harvard.edu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async resume patch (was: Re: [GIT PULL] PM updates for 2.6.33)
In-Reply-To: <Pine.LNX.4.44L0.0912081633540.3046-100000@iolanthe.rowland.org>
Message-ID: <alpine.LFD.2.00.0912081416470.3560@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912081633540.3046-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 Dec 2009, Alan Stern wrote:
>
> And likewise in try_wait_for_completion().  It looks like a bug.  Maybe 
> these routines were not intended to be called with interrupts disabled, 
> but that requirement doesn't seem to be documented.  And it isn't a 
> natural requirement anyway.

'complete()' is supposed to be callable from interrupts, but the waiting 
ones aren't. But 'complete()' is all you should need to call from 
interrupts, so that's fine.

So I think completions should work, if done right. That whole "make the 
parent wait for all the children to complete" is fine in that sense. And 
I'll happily take such an approach if my rwlock thing doesn't work.

		Linus
