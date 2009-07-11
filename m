Return-Path: <linux-kernel-owner+w=401wt.eu-S1754083AbZGLLo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbZGLLo7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 07:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbZGLLot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 07:44:49 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47433 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbZGLLot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 07:44:49 -0400
Date: Sun, 12 Jul 2009 00:10:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jeremy Maitin-Shepard <jeremy@jeremyms.com>
Cc: Nigel Cunningham <ncunningham@crca.org.au>,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org,
       Rafael Wysocki <rjw@sisk.pl>
Subject: Re: [TuxOnIce-devel] RFC: Suspend-to-ram cold boot protection by
	encrypting page cache
Message-ID: <20090711221039.GC1670@ucw.cz>
References: <87hbxx0wcp.fsf@jeremyms.com> <4A4B0125.2090502@crca.org.au> <87d48k2992.fsf@jeremyms.com> <4A4B27D0.8020906@crca.org.au> <20090704024432.GB1345@ucw.cz> <87hbxn78o6.fsf@jeremyms.com> <20090704025755.GA1500@ucw.cz> <87d48b77nu.fsf@jeremyms.com> <20090709101433.GG10937@elf.ucw.cz> <87hbxl587g.fsf@jeremyms.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hbxl587g.fsf@jeremyms.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-07-10 00:05:23, Jeremy Maitin-Shepard wrote:
> Pavel Machek <pavel@ucw.cz> writes:
> 
> > On Wed 2009-07-08 04:09:41, Jeremy Maitin-Shepard wrote:
> >> Pavel Machek <pavel@ucw.cz> writes:
> >> 
> >> > On Wed 2009-07-08 03:47:53, Jeremy Maitin-Shepard wrote:
> >> >> Pavel Machek <pavel@ucw.cz> writes:
> >> >> 
> >> >> [snip]
> >> >> 
> >> >> > I believe uswsusp could be used rather easily. Just modify s2disk to
> >> >> > encrypt image in ram without writing it out, then decrypt it from ram
> >> >> > and resume... it should be interesting hack.
> >> >> 
> >> >> As far as I understand, that would be completely useless since the image
> >> >> that would be encrypted would just be a copy of what would still remain
> >> >> in memory.
> >> 
> >> > Yes... so next step would be kernel call that would erase all the
> >> > pagecache and anonymous pages. You would still leave some data in
> >> > kernel structures, but that would be quite hard to fix. 
> >> 
> >> Okay.  (This does still require the same assumption as TuxOnIce
> >> regarding the page cache, though.)
> 
> > (Not sure; clearing the page cache could be done atomically, from
> > interrupts disabled. But I'm no mm expert.)
> 
> But surely it wouldn't work to leave interrupts disabled after that
> until the page cache is restored.  After the page cache (and other
> sensitive memory) is encrypted, after possibly entering and resuming
> from S3, the page cache needs to be decrypted.  Userspace will be
> doing

I see no need for that. You'd do something like 'kill -9 -1; echo 3 >
drop_caches' after snapshot, then scrub free ram. At that point you
should have no sensitive data in the memory, and encrypted image you
can restore.

(Now, kill -9 -1 with frozen tasks may be tricky to implement....)
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
