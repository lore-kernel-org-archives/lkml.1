Return-Path: <linux-kernel-owner+w=401wt.eu-S1758952AbYHUSLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952AbYHUSLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 14:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYHUSLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 14:11:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39156 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbYHUSLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 14:11:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: ftraced and suspend to ram
Date: Thu, 21 Aug 2008 20:15:04 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>, Pavel Machek <pavel@ucw.cz>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <alpine.DEB.1.10.0808211139420.3947@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0808211139420.3947@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808212015.05768.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 21 of August 2008, Steven Rostedt wrote:
> 
> In latest 2.6.27(git) enabling dynamic ftrace makes resume from a suspend 
> to ram reboot instead of resuming. Queued for 2.6.28 is a new method of 
> recording mcount callers at compile time that does not have this issue.
> 
> But the new method is still too "green" to be pulled into 27, so the old 
> ftraced (daemon method) needs to be fixed for 27.
> 
> The way dynamic ftrace works with the daemon method is this. On boot up 
> the mcount function simply returns. When ftrace is initialized, it calls 
> kstop_machine to modify the mcount function to call another function 
> called "ftrace_record_ip". This new function will record in a preallocated 
> hash (allocated by the ftrace initializer) all the callers of mcount. A 
> check is made to see if the caller has already been put into the hash, and 
> if so, it is not recorded again.
> 
> Later on a kernel thread ftraced is created. This kernel thread wakes up 
> once a second and checks to see if any new functions were added to the 
> hash. If so, it then calls kstop_machine and modifies those callers to 
> mcount into nops.
> 
> Again, this daemon method makes resume from suspend to ram reboot instead 
> of resuming. Now, I'm asking the s2r gurus, what did I miss? Do I need to 
> add a "NO_FREEZE" flag or something to the "ftraced" kernel thread?
> 
> Just asking for some advice.

If I'm not mistaken, it'll probably suffice to make it freezable, so that it
doesn't run while the system is suspending and resuming.  Would that be
acceptable?

Please tell me where exactly the ftraced source code is located.

Thanks,
Rafael
