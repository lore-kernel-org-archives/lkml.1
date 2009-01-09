Return-Path: <linux-kernel-owner+w=401wt.eu-S1756064AbZAIUMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbZAIUMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 15:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754683AbZAIUMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 15:12:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754556AbZAIUML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 15:12:11 -0500
Date: Fri, 9 Jan 2009 12:12:02 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Len Brown <lenb@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org,
       Linux Power Management List <linux-pm@lists.osdl.org>
Subject: Re: [git pull] ACPI & Suspend patches for 2.6.29-rc0
In-Reply-To: <alpine.LFD.2.00.0901090550590.4091@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0901091200150.6528@localhost.localdomain>
References: <alpine.LFD.2.00.0901090550590.4091@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Jan 2009, Len Brown wrote:
> 
> ps. git diff is confused about hwregs.c vs hwxface.c below
>         both got moved.  I'm running git version 1.6.1.76.gc123b,
> 	and I use "git diff -M --stat --summary linus..$RELEASE"

No, "both" didn't get moved. "hwxface.c" is a totally new file when you 
look at the big picture. Yes, it got moved in one commit, but if you look 
at the whole history, the _history_ is actually:

 - Move public interfaces from hwregs.c to new file, hwxface.c

 - rename hwxface.c to another directory

and so git - for the merge statistics - ends up showing this as

>  .../acpi/{hardware/hwregs.c => acpica/hwxface.c}   |  744 +++++++-------------

which is actually correct.

Of course, it would _also_ have been correct to show it as the 
"{hardware/hwregs.c => acpica/hwregs.c}" move that you apparently 
expected, but what git did was just a more interesting thing.

So my point is that the "movement history" is actually different in a 
small view than it is in a big one. If you do "git log -C --stat", you'll 
see the output you expect at each point:

	commit ecfbbc7b46f74ca48b9f42132739114c9e70f8e4
	Author: Bob Moore <robert.moore@intel.com>
	Date:   Tue Dec 30 11:04:48 2008 +0800
	
	    ACPICA: Move all public H/W interfaces to new hwxface
	    
	 drivers/acpi/hardware/hwregs.c  |  498 +----------------------------------
	 drivers/acpi/hardware/hwxface.c |  555 +++++++++++++++++++++++++++++++++++++++

and

	commit 95b482a8d31116f3f5c2a5089569393234d06385
	Author: Len Brown <len.brown@intel.com>
	Date:   Fri Jan 9 00:13:17 2009 -0500
	
	    ACPICA: create acpica/ directory
	
	 drivers/acpi/{hardware => acpica}/hwregs.c     |    0

but when taken all-together, git decided that the bulk of the data (even 
if not the _lines_) actally moved from

	drivers/acpi/{hardware/hwregs.c => acpica/hwxface.c}

which is thus what git shows for the merge diff (which is taken over the 
whole history).

As usual, git is actually smarter and get things more correct than people 
realize. What you found "surprising" is actually a "profound truth". 

Git is like a great indian mystic. It sees past the veil of the trivial, 
to find the true connections in life.

Or at least in source code.

			Linus
