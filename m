Return-Path: <linux-kernel-owner+w=401wt.eu-S1759430AbYCSTt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430AbYCSTt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbYCSTc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:32:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34817 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752219AbYCSTcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:32:55 -0400
Date: Wed, 19 Mar 2008 07:42:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: suspend slow in 2.6.25-rc6 (was Re: Suspend and hibernation
 patchset against -rc6)
In-Reply-To: <20080319101947.GA2963@elf.ucw.cz>
Message-ID: <alpine.LFD.1.00.0803190741490.3020@woody.linux-foundation.org>
References: <200803120129.25585.rjw@sisk.pl> <200803172317.33745.rjw@sisk.pl> <20080318130642.GA1609@elf.ucw.cz> <20080318130710.GB1609@elf.ucw.cz> <alpine.LFD.1.00.0803181028400.3020@woody.linux-foundation.org> <20080318225201.GA2115@elf.ucw.cz>
 <alpine.LFD.1.00.0803181736340.3020@woody.linux-foundation.org> <20080319101947.GA2963@elf.ucw.cz>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 19 Mar 2008, Pavel Machek wrote:
>
> > > It will take a while. My .git directory is 7G, and I'd like to do a
> > > backup before playing with git.
> > 
> > Ouch, what have you done? It should be about 200MB, not 7GB.
> 
> And 10 minutes later, .git directory is 200MB. Thanks!

It strikes me that the only way I can think of that you could have gotten 
a 7GB .git directory without really working at it is if you use one of the 
so-called "dumb" git protocols that just copy whole packfiles from 
kernel.org when you pull.

So do you happen to perhaps use http:// or rsync:// when you fetch git 
data? That would not only be horribly slow occasionally (you'd fetch 
all-new packs and re-download about 200MB of data when I repack the kernel 
repo on kernel.org, which happens about once or twice every release 
cycle), but it would also explain how it ballooned to 7GB for you (because 
you have all these duplicate packs!).

Usign the native git:// protocol would be much faster and avoid the issue 
in the future.

		Linus
