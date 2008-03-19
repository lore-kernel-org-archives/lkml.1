Return-Path: <linux-kernel-owner+w=401wt.eu-S1762045AbYCSUqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762045AbYCSUqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755486AbYCSToZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:44:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757775AbYCSTlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:41:31 -0400
Date: Tue, 18 Mar 2008 17:40:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@suse.cz>
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
In-Reply-To: <20080318225201.GA2115@elf.ucw.cz>
Message-ID: <alpine.LFD.1.00.0803181736340.3020@woody.linux-foundation.org>
References: <200803120129.25585.rjw@sisk.pl> <200803172317.33745.rjw@sisk.pl> <20080318130642.GA1609@elf.ucw.cz> <20080318130710.GB1609@elf.ucw.cz> <alpine.LFD.1.00.0803181028400.3020@woody.linux-foundation.org> <20080318225201.GA2115@elf.ucw.cz>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 Mar 2008, Pavel Machek wrote:
> 
> It will take a while. My .git directory is 7G, and I'd like to do a
> backup before playing with git.

Ouch, what have you done? It should be about 200MB, not 7GB.

> git gc does not exist here, so I guess I need to update git, too :-(.

Well, even with old git you can just do 

	git repack -a -d

and in your case you'll probably have to leave it running overnight, 
because it's going to take hours since you've clearly not ever repacked it 
before and as a result it's going to do lots and lots of IO (all that 7GB 
and then read much of it twice).

But yeah, upgrading git first is probably a good idea regardless.

> commit 7c0ea45be4f114d85ee35caeead8e1660699c46f
> 
>     ACPI: Ignore _BQC object when registering backlight device
> 
> when did this go in? Pretty recently, right?

Yes:

	[torvalds@woody linux]$ git describe 7c0ea45be4f114d85ee35caeead8e1660699c46f
	v2.6.25-rc5-89-g7c0ea45

so it happened after -rc5.

> And that means that ACPI backlight driver is now used on machines where 
> it was not used before...?

Somebody more into ACPI needs to judge how likely this is to be an issue..

		Linus
