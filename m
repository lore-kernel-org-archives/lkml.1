Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbYE3Un2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbYE3Un2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 16:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbYE3UnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 16:43:18 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1032 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752879AbYE3UnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 16:43:17 -0400
Date: Fri, 30 May 2008 22:43:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Hugh Dickins <hugh@veritas.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: sync_file_range(SYNC_FILE_RANGE_WRITE) blocks?
Message-ID: <20080530204307.GA4978@ucw.cz>
References: <20080530102619.GA2468@elf.ucw.cz> <Pine.LNX.4.64.0805301451020.19914@blonde.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805301451020.19914@blonde.site>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > sync_file_range(SYNC_FILE_RANGE_WRITE) blocks ... which makes problem
> > for s2disk: there we want to start writeout as early as possible
> > (system is going to shut down after write, and we need the data on
> > disk).
> > 
> > Unfortuantely, sync_file_range(SYNC_FILE_RANGE_WRITE) blocks, which
> > does not work for us. Is there non-blocking variant? "Start writeout
> > on this fd, but don't block me"?
> 
> I guess there are lots of reasons why it may block (get rescheduled)
> briefly, but why would that matter to you?  Are you saying that its
> whole design has got broken somehow, and now SYNC_FILE_RANGE_WRITE
> is behaving as if SYNC_FILE_RANGE_WAIT_AFTER had been supplied too?

It appears to me like it includes WAIT_AFTER, yes.

I was not sure what the expected behaviour was... lets say we have a
lot of dirty data (like 40MB) and system with enough free memory. Is
it reasonable to expect SYNC_FILE_RANGE_WRITE to return pretty much
immediately? (like in less than 10msec)? Because it seems to take more
like a second here...

(Underlying 'file' is actually /dev/sda1 -- aka my swap partition, but
that should not matter --right?)
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
