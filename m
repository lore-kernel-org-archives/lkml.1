Return-Path: <linux-kernel-owner+w=401wt.eu-S1161444AbXDRB5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161444AbXDRB5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 21:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161458AbXDRB5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 21:57:34 -0400
Received: from smtp113.sbc.mail.mud.yahoo.com ([68.142.198.212]:45032 "HELO
	smtp113.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161444AbXDRB5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 21:57:33 -0400
Date: Tue, 17 Apr 2007 20:57:29 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Wondering: why capabilities system is broken?
Message-ID: <20070418015728.GA20727@vino.hallyn.com>
References: <46252471.2030006@tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46252471.2030006@tls.msk.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Michael Tokarev (mjt@tls.msk.ru):
> Hopefully not a flamewar question...

nothing wrong with asking for clarification.  Though you should have
copied linux-security-module@vger.kernel.org.

> Currently, capabilities of a process are reset during exec()
> system call.  At least effective+permitted set.
> 
> 1) In case new uid != 0, all the caps are cleared, so it is not
> possible to execute a program as non-root but still give it some
> capabilities (like, say, CAP_NET_BIND_SERVICE).

With the introduction of file capabilities in -mm, you can assign
CAP_NET_BIND_SERVICE to a program not owned by root such that all users
can run the program with that capabilities.

Even in mainline, you can make the program setuid 0 and code it such
that it immediately specify keepcaps, change to nonroot, and drop all
caps but CAP_NET_BIND_SERVICE.

> 2) In case new uid == 0, effective and permitted sets are restored
> to all-ones.
> 
> This is regardless of other settings, like prctl(KEEPCAPS), or
> the current set of capabilities.

Look at the prctl(2) manpage - it is about keeping capabilities across
setuid, not across exec.

> I partly understand why 2) is done - in case of setuid binary being
> executed, all the capabilities are set for it.  But this breaks
> executing non-setuid binaries too -- for example, it'd be very nice
> to be able to chroot to some directory, and remove CAP_SYS_CHROOT
> (and other evil caps like CAP_SYS_MODULE, CAP_SETPCAP) -- this way,
> with minimal efforts, chroot will work almost (yes, I understand
> it's not entirely the same) the same as BSD jail(2) concept.

Are you aware of the namespace/containers work going on right now to get
full virtual server support into mainline?  See
http://lists.linux-foundation.org/pipermail/containers/
for the archives of the main relevant mailing list.

> So the question is: why capability sets are being reinitialized during
> exec()?  At least in 2.4 era, they weren't...  and stuff like
> execcap, sucaps etc was working.  Now they aren't anymore.

Please see the file capabilities support in -mm and let us know whether
that does (not) meet your needs.

thanks,
-serge
