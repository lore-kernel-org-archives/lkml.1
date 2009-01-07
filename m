Return-Path: <linux-kernel-owner+w=401wt.eu-S1760981AbZAGTo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760981AbZAGTo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 14:44:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756032AbZAGTot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 14:44:49 -0500
Received: from bsdimp.com ([199.45.160.85]:53336 "EHLO harmony.bsdimp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbZAGTos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 14:44:48 -0500
Date: Wed, 07 Jan 2009 12:42:01 -0700 (MST)
Message-Id: <20090107.124201.-1760127186.imp@bsdimp.com>
To: alan@lxorguk.ukuu.org.uk
Cc: mayer@ntp.isc.org, linasvepstas@gmail.com, david@lang.hm, hancockr@shaw.ca,
       kyle@moffetthome.net, slashdot@jameshallam.info, goodgerster@gmail.com,
       davidn@davidnewall.com, linux-kernel@vger.kernel.org,
       ntpwg@lists.ntp.isc.org, pretzalz@techhouse.org,
       burdell@iruntheinter.net, nick@nick-andrew.net, jeff@kosowsky.org
Subject: Re: [ntpwg] Bug: Status/Summary of slashdot leap-second crash on
 new years 2008-2009
From: "M. Warner Losh" <imp@bsdimp.com>
In-Reply-To: <20090107193127.0bec8ad8@lxorguk.ukuu.org.uk>
References: <49642674.9080703@ntp.isc.org>
	<20090107.103947.1324582654.imp@bsdimp.com>
	<20090107193127.0bec8ad8@lxorguk.ukuu.org.uk>
X-Mailer: Mew version 5.2 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message: <20090107193127.0bec8ad8@lxorguk.ukuu.org.uk>
            Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
: > time, causing time to jump backwards by 1s (or violate POSIX time_t's
: > invariant that midnight time_t is % 86400 == 0).  This jump backwards
: > is a pita in the kernel, and violates the assumption that many
: > programs have that time doesn't flow backwards.
: 
: They can slew the clock slowly as well. There is a wonderful quote from
: one of the summaries of the POSIX committee discussions on time that says
: quite simply "the posix clock is not guaranteed to be accurate"

True, You can.  However, anybody you peer with via ntpd will have
issues unless things are coordinated with ntpd (and aren't a leaf
node).  There you have much higher tolerances for correctness.

: As it currently stands the kernel contains sufficient support that at the
: point you know a leap second is coming you can adjust the second length
: marginally over the entire period.
: 
: The current behaviour is an implementation decision. Jumping on a second
: shouldn't be an issue to most people, jumping back is asking for badness
: but isn't in fact used in the world today. Slewing the entire day so that
: each second is 1/86400 of a second longer or shorter wouldn't be noticed
: by anyone.

If you are an ntp leaf node, that doesn't care about UTC accurate to
the second, this will work well.  For most users, this effectively
papers over the problem.

If you do care about UTC time being more accurate than this slewing
will be too large and introduce errors that are too big.  Likewise for
non-leaf ntp nodes.  For these machines, having time be off by 1/2
second can be very bad.  There are many real-time systems that fall
into this category, trading systems on wall street, systems that
control things based on doing things at certain points within UTC
second, etc.  For those types of systems, changing the length of the
second by this much isn't going to work at all.

ntpd also lights the INS bit only on 'leap day' so depending on when
you poll, you might not have a full day's notice of these changes, but
that can be managed...

Warner

