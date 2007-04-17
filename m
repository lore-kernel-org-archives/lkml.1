Return-Path: <linux-kernel-owner+w=401wt.eu-S1030919AbXDQXbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030919AbXDQXbF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 19:31:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbXDQXbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 19:31:05 -0400
Received: from mail.windriver.com ([147.11.1.11]:53840 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689AbXDQXbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 19:31:04 -0400
X-Greylist: delayed 7504 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Apr 2007 19:31:04 EDT
Message-ID: <46253B9F.4010907@windriver.com>
Date: Tue, 17 Apr 2007 16:26:55 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Permanent Kgdb integration into the kernel - lets get with it.
References: <7.469046093@selenic.com> <461C81C0.9040003@yahoo.com.au> <20070417204557.GL11115@waste.org>
In-Reply-To: <20070417204557.GL11115@waste.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Apr 2007 21:25:54.0474 (UTC) FILETIME=[FB1FF0A0:01C78136]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> > Is there any movement on this?
>
> I'm open to reasonable patches for the hooks at least. If that is done
> then the actual kgdb code can be reviewed and considered eventually too. 
>
> But just having the hooks in would make it easy enough to use anyways 
> (no patching, just dropping in of new files, or even loading of it as a
> module into any kernel)
>
> When I did the original x86-64 kgdb port this worked nicely --
> kgdb could work with just the standard die notifiers and a simple
> change in the serial console code.
>
> The recent kgdb seems to need much more changes again though.
>
> However every time when I suggested this (fixing the hooks first
> and submitting the really needed changes piece by piece)
> there didn't seem to be any interest from the various kgdb maintainers.
>
> So my impression currently is that they're not interested in merging.
>
> Another problem is that kgdb is moving more and more away from
> mainline by adding various weird hacks and workarounds in random
> code that just make  merging harder.
>
> Before anything could be considered for merging that all would
> need to be cleaned up.
>
> -Andi
>   
Andi,

I too am open to having a API, for KGDB, but it does need more than just 
the trap vectors and the serial driver as hook points. There are a 
number of patches to fix problems randing from the NET_POLL API, NMI 
handling, and saving a bit more information when loading kernel modules.

If you have an API, that you would like to contribute or suggest, I for 
one am interested. I have long thought it would be nice to be able to 
choose between kernel debug tools KDB, KGDB, KEXEC etc... much like you 
can dynamically load I/O modules in KGDB and choose either RS232 or 
Ethernet after the kernel has booted.

At the current time, I am most certainly trying to consolidate the 
source forge KGDB patches, Tom Rini's branch, as well as my own 
development branch and hopefully Sergei's development branch as well. 
Perhaps after the code stream is stable you we can take a further look 
at what it takes to abstract a generic kernel debug interface. In the 
mean time if you have code or skeleton API proposal, I am definitely 
listening. It would be nice to have an in kernel soft single step API as 
an example, which could be leveraged by KGDB and utrace/ptrace, but that 
is a bit forward looking at this point.

Jason.
