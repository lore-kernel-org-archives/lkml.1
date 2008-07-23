Return-Path: <linux-kernel-owner+w=401wt.eu-S1754448AbYGWOH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbYGWOH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 10:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbYGWOHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 10:07:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34973 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbYGWOHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 10:07:48 -0400
Date: Wed, 23 Jul 2008 07:03:12 -0700
From: Greg KH <greg@kroah.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <gregkh@suse.de>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, ak@linux.intel.com, tiwai@suse.de,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-next@vger.kernel.org
Subject: Re: [PATCH 72/79] sysdev: Pass the attribute to the low level
	sysdev show/store function
Message-ID: <20080723140312.GA15537@kroah.com>
References: <20080722051805.GA17373@suse.de> <1216703983-21448-72-git-send-email-gregkh@suse.de> <20080722134045.7f09ff29.akpm@linux-foundation.org> <20080722204939.GA3028@suse.de> <20080722140301.2a334f8c.akpm@linux-foundation.org> <20080722211919.GA5669@suse.de> <20080723130435.7a79f7e4.sfr@canb.auug.org.au> <20080723042218.GA6784@suse.de> <20080723090310.GA13534@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723090310.GA13534@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 11:03:10AM +0200, Ingo Molnar wrote:
> ok, lemme do a bit of merge window flaming here, in defense of Andrew.
> 
> This commit history:
> 
>   commit 4a0b2b4dbe1335b8b9886ba3dc85a145d5d938ed
>   Author:     Andi Kleen <andi@firstfloor.org>
>   AuthorDate: Tue Jul 1 18:48:41 2008 +0200
>   Commit:     Greg Kroah-Hartman <gregkh@suse.de>
>   CommitDate: Mon Jul 21 21:55:02 2008 -0700
> 
>     sysdev: Pass the attribute to the low level sysdev show/store function
> 
>   [...]
> 
>     I converted all users in tree to the new show/store prototype. It's 
>     a single huge patch to avoid unbisectable sections.
> 
>     Runtime tested: x86-32, x86-64
>     Compiled only: ia64, powerpc
>     Not compile tested/only grep converted: sh, arm, avr32
> 
> covers a relatively trivial patch that we'd normally not notice, but it 
> is ... a ... misrepresentation of the true situation on several levels:
> 
> 1) The changelog. The updated patch Andi sent did not declare the other
>    incremental changes (to sched.c) it also included freshly.

Andi's original patch that he sent me _did_ declare that he had updated
the patch, I didn't change the changelog as it didn't make sense to do
so.

> 2) The date. This patch did not originate on Jul 1 - if Andi sent a 
>    material update yesterday it should say Jul 21, not Jul 1.

Again, my fault, I kept the original email headers and just updated the
patch portion.  It's easier for me to do that using quilt, hence the
lack of the date change.

> 3) The justification. Huge atomic patches are fine and can indeed be 
>    much simpler than a gradual switchover, _iff_ they are done 
>    perfectly. If there's any doubt then they are by far not the only 
>    option to pursue - we've done finegrained API changeovers for years.

This kind of API change is atomic, sorry.  It was tiny enough that it
didn't justify a big rework (like I did on the recent device_create()
stuff for example) to get it modified.

> ... which all we still wouldnt worry much about (the whole change is 
> relatively trivial), if it had been done more carefully without wrecking 
> Andrew's workflow in the middle of the merge window.

I understand, and I apologize.

thanks,

greg k-h
