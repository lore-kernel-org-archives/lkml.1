Return-Path: <linux-kernel-owner+w=401wt.eu-S1755671AbYEKLOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671AbYEKLOw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 07:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbYEKLOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 07:14:44 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:37423 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbYEKLOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 07:14:43 -0400
Date: Sun, 11 May 2008 05:14:42 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Ingo Molnar <mingo@elte.hu>, Sven Wegener <sven.wegener@stealer.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] scheduler fixes
Message-ID: <20080511111442.GA31157@parisc-linux.org>
References: <alpine.LFD.1.10.0805070817060.3024@woody.linux-foundation.org> <1210214696.3453.87.camel@ymzhang> <alpine.LFD.1.10.0805072014330.3024@woody.linux-foundation.org> <1210219729.3453.97.camel@ymzhang> <alpine.LFD.1.10.0805072115190.3024@woody.linux-foundation.org> <20080508120130.GA2860@elte.hu> <20080508122802.GA4880@elte.hu> <20080508144316.GA9869@elte.hu> <20080508151028.GA12109@elte.hu> <20080511110306.GP19219@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080511110306.GP19219@parisc-linux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 05:03:06AM -0600, Matthew Wilcox wrote:
> This might be the problem that causes the missing wakeups.  If you have a
> semaphore with n=2, and four processes calling down(), tasks A and B
> acquire the semaphore and tasks C and D go to sleep.  Task A calls up()
> and wakes up C.  Then task B calls up() and doesn't wake up anyone
> because C hasn't run yet.  I think we need another wakeup when task C

Er, I mis-wrote there.

Task A calls up() and wakes up C.  Then task B calls up() and wakes up C
again because C hasn't removed itself from the list yet.  D never
receives a wakeup.  The solution is for C to pass a wakeup along to the
next in line.  (The solution remains the same).

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
