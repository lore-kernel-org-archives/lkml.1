Return-Path: <linux-kernel-owner+w=401wt.eu-S1755922AbYH2QMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbYH2QMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 12:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbYH2QM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 12:12:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:48611 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbYH2QM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 12:12:29 -0400
Date: Fri, 29 Aug 2008 09:12:29 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@tglx.de,
       torvalds@linux-foundation.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [patch 0/5] Nano/Microsecond resolution for select() and poll()
Message-ID: <20080829091229.1ddfc92d@infradead.org>
In-Reply-To: <200808291754.28241.arnd@arndb.de>
References: <20080829080549.6906b744@infradead.org>
	<200808291754.28241.arnd@arndb.de>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008 17:54:27 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Friday 29 August 2008, Arjan van de Ven wrote:
> 
> > With this patch series, the internals of select() and poll()
> > interfaces are changed such that they work on the nanosecond level
> > (using hrtimers). The userspace interface for select() is in
> > microseconds, for pselect() and ppoll() this is in nanoseconds.
> 
> Nice work, seems a lot better thought through than my previous
> attempt [1], which unfortunately never saw any reactions.
>  
> > even though poll() (as opposed to ppoll()) only accepts milliseconds
> > as userspace interface, the behavior will still improve because the
> > current time no longer needs to be rounded up to the next jiffie,
> > so on average a 500 milliseconds behavior improvement.
> 
> That would be 500 microseconds I think.
> 
> > I'd like to get rid of the jiffies timeout entirely over time, and
> > only use hrtimers (makes the code a lot nicer) but that's for now
> > a separate step, first I'd like to see how this change pans out. 
> 
> You mean entirely entirely getting rid of jiffies in the kernel, or
> just with user facing interfaces like epoll_wait, rt_sigtimedwait etc?

I meant actually just in the select() and poll() code; right now it is
sort of dual-brained, I'd like to eventually be able to get rid of that
and just use hrtimers for select() and poll() always

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
