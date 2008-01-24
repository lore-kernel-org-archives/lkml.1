Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbYAXRua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbYAXRua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 12:50:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbYAXRuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 12:50:23 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40861 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752642AbYAXRuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 12:50:22 -0500
Date: Thu, 24 Jan 2008 18:50:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH 1/2] Extend sys_clone and sys_unshare system calls API
Message-ID: <20080124175033.GB4473@elf.ucw.cz>
References: <478DFF8F.9030006@openvz.org> <20080123205930.GA5233@ucw.cz> <4798C664.1040409@fr.ibm.com> <1201195474.8329.38.camel@nimitz.home.sr71.net> <20080124173708.GA4473@elf.ucw.cz> <1201196817.8329.44.camel@nimitz.home.sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201196817.8329.44.camel@nimitz.home.sr71.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-01-24 09:46:57, Dave Hansen wrote:
> On Thu, 2008-01-24 at 18:37 +0100, Pavel Machek wrote:
> > > Did we decide not to do something with a variable number of
> > arguments?
> > > 
> > >       sys_clonefoo(unsigned long *flags, int len);
> > 
> > That is evil, because that means strace can no longer reliably print
> > flags being used (for example).
> 
> Ahhh.  Just like it can't print strings for "buf"?
> 
> 	write(int fd, char *buf, size_t len)
> 
> Man, strace is stupid! ;)

I said _reliably_.

Guess what happens on smp when one process will periodically overwrite
buf, and second will do the syscall?

It sucks for write, but it would suck much more for clone, where flags
drastically change the behaviour.

(Yep, it is possible to do reliably, see subterfugue, but it is a lot
of work and lot of overhead).

> If that's *really* a concern, why don't we just pass, say 4 or 5 longs
> in:
> 
> 	sys_clonebig(unsigned long flags0, unsigned long flags1,
> 		     unsigned long flags2, unsigned long flags3);

Works for me.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
