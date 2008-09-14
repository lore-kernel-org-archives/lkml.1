Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbYINP6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbYINP6P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 11:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbYINP6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 11:58:00 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3240 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753305AbYINP57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 11:57:59 -0400
Date: Sun, 14 Sep 2008 17:57:45 +0200
From: Pavel Machek <pavel@suse.cz>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, dwmw2@infradead.org, drepper@redhat.com,
       mingo@elte.hu, tglx@tglx.de
Subject: Re: [PATCH 12/13] hrtimer: create a "timer_slack" field in the task struct
Message-ID: <20080914155744.GA4845@ucw.cz>
References: <20080901160343.75a89ec9@infradead.org> <20080901161423.59ebf2fc@infradead.org> <20080902100439.GA11383@elf.ucw.cz> <20080902060323.70245b83@infradead.org> <20080908132713.GA18486@elf.ucw.cz> <20080908064002.7abc2a22@infradead.org> <20080908141555.GB31784@elf.ucw.cz> <a36005b50809140821w2caeb810p431cf5625b0297f5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a36005b50809140821w2caeb810p431cf5625b0297f5@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Yes, it is a great advantage, but it feels like a hack. Maybe it is
> > better done with LD_PRELOAD or something?
> >
> > I'd certianly want the applications to specify slack themselves in
> > like 10 years.
> 
> LD_PRELOAD is not a solution.  LD_PRELOAD always has been and always
> will be a hack.  You use it to work around problems or to test
> something.  Nothing else.
> 
> LD_PRELOAD and other variables are ignored in security-relevant
> contexts and environments are cleared in many situations.  Sure, you

...but that's okay, right? You would not want passwd to inherit huge
slack specified by attacker...?

> The prctl() way plus a default non-zero value is the best way for
> legacy apps.  And you'll hopefully get your wish that apps will take
> fate into their own hand by specifying the slack themselves.  Arjan's
> proposal also introduces new poll/select-like interface which take the
> additional slack value (at least that's what we discussed before).
> 
> I'm strongly opposed to using LD_PRELOAD.  And I think requiring the
> libc implementation of select/ poll, ... etc to wrap around the new
> interfaces which take the slack and determine the slack at userlevel
> (by reading some file) is too expensive.  It's one little value per
> process (group) to be kept by the kernel.  That's not much.

Well, it is not too much, but... is the cost for userspace really
significant? You'd clearly want it stored in environment, not
filesystem...
						Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
