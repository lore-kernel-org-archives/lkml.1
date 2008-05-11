Return-Path: <linux-kernel-owner+w=401wt.eu-S1756780AbYEKOS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780AbYEKOS3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 10:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbYEKOSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 10:18:20 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:43457 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbYEKOSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 10:18:20 -0400
Date: Sun, 11 May 2008 08:18:18 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sven Wegener <sven.wegener@stealer.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] scheduler fixes
Message-ID: <20080511141818.GT19219@parisc-linux.org>
References: <20080508122802.GA4880@elte.hu> <20080508144316.GA9869@elte.hu> <20080508151028.GA12109@elte.hu> <20080511110306.GP19219@parisc-linux.org> <20080511114803.GA8289@parisc-linux.org> <20080511125049.GA22513@elte.hu> <20080511125216.GA25040@elte.hu> <20080511130226.GR19219@parisc-linux.org> <20080511132636.GA22878@parisc-linux.org> <20080511140017.GA2457@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080511140017.GA2457@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 04:00:17PM +0200, Ingo Molnar wrote:
> * Matthew Wilcox <matthew@wil.cx> wrote:
> 
> > Current XFS CVS has a fix from myself and Christoph that gets rid of 
> > the l_flushsema and replaces it with a staggered wakeup of each task 
> > that's waiting as the previously woken task clears the critical 
> > section.
> 
> the solution is to reduce semaphore usage by converting them to mutexes. 
> Is anyone working on removing legacy semaphore use from XFS?

This race is completely irrelevant to converting semaphores to mutexes.
It can only occur for semaphores which /can't/ be converted to mutexes.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
