Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbXFLOlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbXFLOlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 10:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbXFLOlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 10:41:14 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1305 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753262AbXFLOlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 10:41:14 -0400
Date: Sun, 10 Jun 2007 18:31:48 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Mark Lord <lkml@rtr.ca>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Tweedie <sct@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ext3fs: umount+sync not enough to guarantee metadata-on-disk
Message-ID: <20070610183148.GB4272@ucw.cz>
References: <46680BB8.50404@rtr.ca> <20070607084142.42583639.akpm@linux-foundation.org> <46682E4E.1070303@redhat.com> <46687C05.1080408@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46687C05.1080408@rtr.ca>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>Did this succeed?  If the application is still 
> >>truncating that file, the
> >>umount should have failed.
> >
> >Shouldn't sync should wait for truncate to finish?
> 
> The part that gets me here, and that others might be 
> missing,
> is that we are not waiting for ftruncate at this point.
> 
> We're waiting for unlink.  The application that was 
> doing ftruncate
> in tiny little doses has been sent a kill-9 signal, so 
> what should
> be happening now (confirmed by disk activity LEDs) is 
> the file should
> just be getting deleted the same as if we did "rm 
> bigfile" on it.

Well, AFAICT kill-9 signal delivery can take time. It still might be
doing ftruncate.

It would be interesting to know when in that sequence mythtv dies...
or perhaps put loop 'while killall -9 mythtv returns success, sleep 1'
into shutdown scripts?
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
