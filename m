Return-Path: <linux-kernel-owner+w=401wt.eu-S1762419AbZDIVmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762419AbZDIVmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 17:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758526AbZDIVmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 17:42:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41059 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757286AbZDIVmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 17:42:08 -0400
Date: Thu, 9 Apr 2009 14:37:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: bugzilla-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       "Barry K. Nathan" <barryn@pobox.com>, stable@kernel.org
Subject: Re: [Bugme-new] [Bug 13012] New: 2.6.28.9 causes init to segfault
 on Debian etch; 2.6.28.8 OK
Message-Id: <20090409143755.96e0c62c.akpm@linux-foundation.org>
In-Reply-To: <bug-13012-10286@http.bugzilla.kernel.org/>
References: <bug-13012-10286@http.bugzilla.kernel.org/>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

-fwrapv killed Barry's gcc-4.1.2-compiled kernel in 2.6.27.x, 2.6.28.x
and presumably 2.6.29, 2.6.30.


On Sun, 5 Apr 2009 13:04:02 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=13012
> 
>            Summary: 2.6.28.9 causes init to segfault on Debian etch;
>                     2.6.28.8 OK
>            Product: Other
>            Version: 2.5
>     Kernel Version: 2.6.28.9
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: high
>           Priority: P1
>          Component: Other
>         AssignedTo: other_other@kernel-bugs.osdl.org
>         ReportedBy: barryn@pobox.com
>         Regression: Yes
> 
> 
> (I haven't had a chance to collect all that data that I wanted to collect
> before reporting this bug, but this might be the best I can do for the next few
> days, so I think it's best for me to submit what I have so far instead of
> sitting on it.)
> 
> The system in question is a Debian etch system which has a static /dev (no
> udev) and does not use an initrd or initramfs. With 2.6.28.8, it works fine.
> With 2.6.28.9, init segfaults during boot, so the system fails to finish
> booting. (Same problem happens on 2.6.27.21 and does not happen on 2.6.27.20,
> but I have not had time to investigate that version in depth.)
> 
> git bisect says "92db6956ecd01ceb7934be0252b3b184a82ebb64 is first bad commit".
> That's "Add '-fwrapv' to gcc CFLAGS". If I take 2.6.28.9 and I revert "Move
> cc-option to below arch-specific setup" and "Add '-fwrapv' to gcc CFLAGS" then
> the resulting kernel works again.
> 
> I also noticed that the problem only happens with some gcc's:
> 
> Problem occurs:
> gcc (GCC) 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)
> gcc-4.1 (GCC) 4.1.3 20080704 (prerelease) (Debian 4.1.2-25)
> 
> Problem does not occur (i.e. 2.6.28.9 works and I don't have to revert
> anything):
> gcc-4.2 (GCC) 4.2.4 (Debian 4.2.4-6)
> gcc (Debian 4.3.2-1.1) 4.3.2
> 
> (BTW, on 2.6.29, I'm having a problem where if I'm running 2.6.29 then make
> instantly blows up in a strange way, and the same pattern of working/failing
> compilers is showing up there too.)
> 
> I have not yet had a chance to try vanilla gcc 4.1.2. That's what I intend to
> try next.
> 
> I'll attach my .config within the next 24 hours, and I'll try to post serial
> console captures by sometime Tuesday or so. If there's any other information
> which would help, feel free to ask...
> 
> 
> My gut feeling is that this is truly a gcc bug rather than a kernel bug, but
> it's still disconcerting to see this kind of breakage suddenly pop up in a
> -stable series, so IMO it may be worth considering reverting the -fwrapv
> changes for 2.6.2[78].y.
> 

