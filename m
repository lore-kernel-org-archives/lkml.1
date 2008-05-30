Return-Path: <linux-kernel-owner+w=401wt.eu-S1753679AbYE3QYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbYE3QYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 12:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbYE3QYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 12:24:43 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:36451 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752988AbYE3QYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 12:24:43 -0400
Date: Fri, 30 May 2008 12:24:42 -0400
To: Jordan Crouse <jordan.crouse@amd.com>
Cc: David Brigada <brigad@rpi.edu>, Ingo Molnar <mingo@elte.hu>,
       Wim Van Sebroeck <wim@iguana.be>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Samuel Tardieu <sam@rfc1149.net>,
       Mike Frysinger <vapier.adi@gmail.com>, Mingarelli@infomag.amd.com
Subject: Re: drivers/watchdog/geodewdt.c: build fix
Message-ID: <20080530162442.GB16164@csclub.uwaterloo.ca>
References: <20080525100944.GA4084@infomag.infomag.iguana.be> <20080530150250.GA21945@elte.hu> <20080530153919.GC12123@cosmic.amd.com> <48402334.3000809@rpi.edu> <20080530160505.GA12722@cosmic.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080530160505.GA12722@cosmic.amd.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2008 at 10:05:05AM -0600, Jordan Crouse wrote:
> I think the hamster dropping code is queued for 2.6.27, so at least we're
> up to mammals.
> 
> The story here is that in an unfortunate instance of bad planning the
> MFGPT timers can only be configured once, so a module can't allocate a
> timer at init and release it when it is done.  The original object of this
> code was to try give the timer back to a module if it happened to go away
> and come back, but that is clearly a more complex process then just simply
> storing the module name, and this code fell into bitrot.

It is a bit unfortunate that someone decided to design 'configure once'
hardware.  What were they thinking?

I run a watchdog using the mfgpt, and I simply tore out the code that
prevents reuse of the timers, and I decided which timers I am going to
use for which purpose and never reuse them for anything else, so the
parts of the configuration in the hardware that is fixed isn't an issue
then.  I start the watchdog from grub, so I had to override the check
when the kernel takes over the timer watchdog management after all.

> So its not so much that we need to drop module support, rather it needs to
> be understood that if you remove and insert your module on a regular basis
> you will run out of timers, and deprive others of the timers too. I think
> that is a reasonable restriction to impose, given the limited usefulness 
> of these timers for general purpose use.

They are useful timers, but yes perhaps not for general purpose.  As a
source of interrupts at certain intervals or as a watchdog they are not
too bad.

-- 
Len Sorensen
