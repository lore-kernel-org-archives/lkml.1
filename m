Return-Path: <linux-kernel-owner+w=401wt.eu-S1757359AbXD0Vpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbXD0Vpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 17:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757358AbXD0Vpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 17:45:51 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757359AbXD0Vpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 17:45:46 -0400
Date: Fri, 27 Apr 2007 14:44:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Cc: "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       lee-in-berlin@web.de, Truxton Fulton <trux@truxton.com>
Subject: Re: [Bugme-new] [Bug 8378] New: Averatec 3156X laptop doesn't
 reboot with kernels > 2.6.13.5 (responsible commit found)
Message-Id: <20070427144434.970de79f.akpm@linux-foundation.org>
In-Reply-To: <200704271742.l3RHgPTH019561@fire-2.osdl.org>
References: <200704271742.l3RHgPTH019561@fire-2.osdl.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 10:42:25 -0700
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=8378
> 
>            Summary: Averatec 3156X laptop doesn't reboot with kernels >
>                     2.6.13.5 (responsible commit found)
>     Kernel Version: 2.6.14 till 2.6.21
>             Status: NEW
>           Severity: normal
>              Owner: power-management_other@kernel-bugs.osdl.org
>          Submitter: lee-in-berlin@web.de
> 
> 
> Most recent kernel where this bug did *NOT* occur: 2.6.13.5
> 
> Distribution: Debian
> Hardware Environment: Averatec 3156X (seemingly identical to the american model
> 3150P)
> Software Environment:?
> Problem Description:
> I noticed that with recent kernels my laptop would reboot when I do an 'init 6',
> but hang at the end of the init run. The last working vanilla kernel is
> 2.6.13.5. With some trying and a bit of guessing I found a change to
> include/asm-i386/mach-default/mach_reboot.h in 2.6.14 to be the culprit. It can
> be found at:
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.14.y.git;a=commitdiff;h=59f4e7d572980a521b7bdba74ab71b21f5995538
> 
> On a 2.6.21 source tree I can revert this patch, and then rebooting works.
> 
> Steps to reproduce:
> 1) On a Averatec 3156X (or 3150p?) boot to your default runlevel.
> 2) as root, type "init 6".
> 3) instead of rebooting, the system will hang at the end with a blank screen.
> 

Oh dear.  We have an ugly i386 snafu here.  Thanks for doing the bisection
- it helps enormously.

Could some brave person please pick it up and see if we can get both
Truxton and Lee's machines working?

