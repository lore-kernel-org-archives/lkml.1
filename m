Return-Path: <linux-kernel-owner+w=401wt.eu-S933001AbYETOdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001AbYETOdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 10:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760447AbYETOdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 10:33:33 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:38506 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbYETOdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 10:33:32 -0400
Date: Tue, 20 May 2008 16:33:16 +0200
From: Pavel Machek <pavel@suse.cz>
To: Morten Welinder <mwelinder@gmail.com>
Cc: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Deleting large files
Message-ID: <20080520143315.GB3882@ucw.cz>
References: <118833cc0805071249w36145eb6g7ed5c18d9fdf6fce@mail.gmail.com> <Pine.LNX.4.61.0805071820010.25395@chaos.analogic.com> <118833cc0805071614j49b10da6hfcbeb08cb3356afb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <118833cc0805071614j49b10da6hfcbeb08cb3356afb@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-05-07 19:14:33, Morten Welinder wrote:
> >  Suppose you had an N GB file that just filled up the disk. You now
> >  delete it, but get control back before it is really deleted. You
> >  now start to write a new file that will eventually just fill up
> >  the disk. [...]
> 
> That argument ought to stop right there.  If you believe that deleting a
> file will necessarily and immediately give you back the space, then you
> are wrong in the current state of the affairs already.

Not if you are the only user.

> user experience.  Forking a process to do the deletion (a) is pathetic,
> (b) is not currently done, and (c) does not work: you cannot get a result
> right away, i.e., you lose error handling.

If you fork a kernel thread, you lose error handling, too.

Think -EIO when writing back bitmaps...

(Hmm, you'd have to use O_SYNC to see that, so this is probably
minor).

I guess doing freeing asynchronously would be okay in the 'close'
case...

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
