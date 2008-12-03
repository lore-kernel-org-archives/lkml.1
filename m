Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbYLCSYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbYLCSYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 13:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbYLCSYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 13:24:31 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44203 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbYLCSYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 13:24:31 -0500
Date: Wed, 3 Dec 2008 19:26:03 +0100
From: Pavel Machek <pavel@suse.cz>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Theodore Tso <tytso@mit.edu>, Chris Friesen <cfriesen@nortel.com>,
       kernel list <linux-kernel@vger.kernel.org>, aviro@redhat.com
Subject: Re: writing file to disk: not as easy as it looks
Message-ID: <20081203182603.GB22852@elf.ucw.cz>
References: <20081202140439.GF16172@mit.edu> <20081202152618.GA1646@ucw.cz> <20081202163720.GB18162@mit.edu> <49356EF2.7060806@nortel.com> <20081202205558.GD20858@mit.edu> <20081202224403.GA8277@elf.ucw.cz> <20081203050709.GL20858@mit.edu> <20081203084639.GB1944@ucw.cz> <20081203164240.GA30610@mit.edu> <Pine.LNX.4.64.0812031840420.25439@artax.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812031840420.25439@artax.karlin.mff.cuni.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-12-03 18:43:18, Mikulas Patocka wrote:
> > On Wed, Dec 03, 2008 at 09:46:40AM +0100, Pavel Machek wrote:
> > > Yes. fsync() seeems surprisingly high on Rusty's list of broken
> > > interfaces classification ('impossible to use correctly').
> 
> BTW where is that list.

http://ozlabs.org/~rusty/index.cgi/tech/2008-04-01.html

> > To be fair, fsync() was primarily intended for making sure that the
> > data had been written to disk, and not necessarily as a way of making
> > sure that write errors would be properly reflected back to the
> > application.  As you've pointed out, it's not really adequate for that
> > purpose.
> 
> Well, what else do you want to use for databases? (where crashing the 
> whole computer makes less damage than pretending that transaction was 
> committed while it wasn't).

I guess we could modify fsync() to fail if there was _ever_ write
problem on same filesystem. That would make it "safe". And as
ext2/ext3 can't handle metadata write errors anyway... maybe that
should be done?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
