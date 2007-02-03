Return-Path: <linux-kernel-owner+w=401wt.eu-S1752086AbXBCNUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbXBCNUh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 08:20:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbXBCNUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 08:20:36 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51600 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752086AbXBCNUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 08:20:36 -0500
Date: Sat, 3 Feb 2007 13:48:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
Cc: Robin Holt <holt@sgi.com>, akpm@osdl.org, linux-kernel@vger.kernel.org,
       dhowells@redhat.com, alan@lxorguk.ukuu.org.uk,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>,
       "Hideo AOKI@redhat" <haoki@redhat.com>
Subject: Re: [PATCH 0/4] coredump: core dump masking support v2
Message-ID: <20070203124853.GA4191@elf.ucw.cz>
References: <45BA0A93.30004@hitachi.com> <20070126152907.GB30950@lnx-holt.americas.sgi.com> <45BEF582.7080004@hitachi.com> <20070130124417.GA7320@lnx-holt.americas.sgi.com> <45C08E33.9030300@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45C08E33.9030300@hitachi.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>>Can you make this a little more transparent?  Having a magic bitmask does
> >>>not seem like the best way to do stuff.  Could you maybe make a core_flags
> >>>directory with a seperate file for each flag.  It could still map to a
> >>>single field in the mm, but be broken out for the proc filesystem.
> >>
> >>It seems to be one of the good enhancement idea, thanks.:-)
> >>But currently, there is only one flag. So we had better keep this simple
> >>implementation until someone requests to add a new flag.
> > 
> > If that is the case, can we rename the file from core_flags to something
> > more descriptive like dump_core_skip_anonymous_mappings.  The name
> > is a wild suggestion, the renaming does seem fairly important to me.
> > Remember once you get this in, changing the name will be fairly difficult
> > as admin tools and documentation will adopt the name.  These are usually
> > cases where it is better to do it right the first time.
> 
> Okay, I'll adopt your idea in the next version.
> I'm going to provide the proc entry as follows:
> 
>   (1) /proc/<pid>/core_flags/flags
>   (2) /proc/<pid>/core_flags/omit_anon_shared
> 
> (1) is the same as current core_flags. It is for expert users.
> (2) corresponds to one bit in (1).
> If (2) is set to 1, anonymous shared memory of the process is never
> dumped.

Now, that's what I call an ugly interface.

Can we simply add ulimit with boolean value, that says dump
anon_shared... or not? It will be simpler and faster, because you'll
not need locking.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
