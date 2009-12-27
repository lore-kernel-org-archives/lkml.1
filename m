Return-Path: <linux-kernel-owner+w=401wt.eu-S1751088AbZL0TIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751088AbZL0TIT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 14:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbZL0TIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 14:08:18 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54192 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbZL0TIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 14:08:17 -0500
Date: Sun, 27 Dec 2009 20:08:02 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, viro@ZenIV.linux.org.uk,
       michael@laptop.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
       andi@firstfloor.org, david@lang.hm, socketcan@hartkopp.net,
       alan@lxorguk.ukuu.org.uk, herbert@gondor.apana.org.au,
       Valdis.Kletnieks@vt.edu, bdonlan@gmail.com, zbr@ioremap.net,
       cscott@cscott.net, jmorris@namei.org, ebiederm@xmission.com,
       bernie@codewiz.org, mrs@mythic-beasts.com, randy.dunlap@oracle.com,
       xiyou.wangcong@gmail.com, sam@synack.fr, casey@schaufler-ca.com,
       serue@us.ibm.com
Subject: Re: RFC: disablenetwork facility. (v4)
Message-ID: <20091227190802.GH11737@elf.ucw.cz>
References: <20091227010441.GA12077@heat>
 <200912271736.GDB17180.OFJHOOQStMFLVF@I-love.SAKURA.ne.jp>
 <20091227083857.GC11737@elf.ucw.cz>
 <200912272049.FIB35755.OMFFOOJQtVLFSH@I-love.SAKURA.ne.jp>
 <20091227150300.GB19414@hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091227150300.GB19414@hallyn.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I think seccomp() is too much restricted to apply for general applications.
> > Most applications will need some other syscalls in addition to exit(), read()
> > and write(). Most applications cannot use seccomp().
> > 
> > What I want to do is similar to seccomp(), but allows userland process to
> > forbid some syscalls like execve(), mount(), chroot(), link(), unlink(),
> > socket(), bind(), listen() etc. selectively.
> 
> The nice thing about the disablenetwork module is that (AFAICS so far)
> it actually is safe for an unprivileged user to do.  I can't think of
> any setuid-root software which, if started with restricted-network by
> an unprivileged user, would become unsafe rather than simply
> failing.

"I can't see" is not strong enough test, I'd say.

For example, I can easily imagine something like pam falling back to
local authentication when network is unavailable. If you disable
network for su...

It would be also extremely easy to DoS something like sendmail -- if
it forks into background and then serves other users' requests.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
