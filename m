Return-Path: <linux-kernel-owner+w=401wt.eu-S1752093Ab0AAPLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab0AAPLc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 10:11:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990Ab0AAPLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 10:11:31 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58260 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891Ab0AAPLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 10:11:30 -0500
Date: Fri, 1 Jan 2010 16:11:29 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Michael Stone <michael@laptop.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, David Lang <david@lang.hm>,
       Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Bryan Donlan <bdonlan@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Am?rico Wang <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: RFC: disablenetwork facility. (v4)
Message-ID: <20100101151129.GG3944@atrey.karlin.mff.cuni.cz>
References: <20091228181316.GA16277@us.ibm.com> <20091229050114.GC14362@heat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091229050114.GC14362@heat>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I think that Pavel's point, at its strongest and most general, could be
> rephrased as:
> 
>   "Adding *any* interesting isolation facility to the kernel breaks 
>   backwards
>    compatibility for *some* program [in a way that violates security 
>    goals]."

Yep.

> So far, I've seen the following suggestions:
> 
>   a) setuid restores pre-isolation semantics
> 
>         - Doesn't work for me because it violates the security guarantee of 
>         the
>           isolation primitive 

d) when any new isolation feature requires removing ability to
exec(anything setuid) first.

>   b) setuid is an escape-hatch
> 
>         - Probably the cleanest in the long-run
> 
>         - Doesn't, by itself, suffice for Pavel since it violates backwards
>           compatibility
> 
>   c) signal to the kernel through a privileged mechanism that
>      backwards-incompatible isolation may or may not be used
> 
>         - No problems seen so far.


> I would be happy with (c), assuming we can agree on an appropriate 
> signalling
> mechanism and default.
> 
> So far, two defaults have been proposed:
> 
>   default-deny incompatible isolation (Pavel)


> So far, several signalling mechanisms have been proposed:
> 
>   1) enabling a kernel config option implies default-permit
> 
>         - My favorite; apparently insufficient for Pavel?
> 
>   2) default-deny; disablesuid grants disablenetwork
> 
>         - "disablesuid" is my name for the idea of dropping the privilege of
>           exec'ing setuid binaries
> 
>         - Suggested by Pavel and supported by several others. 

>         - I think it has the same backwards-compatibility problem as
>           disablenetwork: disablesuid is an isolation primitive.

Which is ok, use can already arbitrarily break *his own* apps, eg. by
using ptrace. Only with setuid in place it becomes security problem.

>   4) default-deny; setting a sysctl implies permit
> 
>         - Suggested by Serge; works fine for me
...
> I am happiest with (1) and, if (1) isn't good enough, with (4).
> 
> Pavel, what do you think of (4)?

It is still bad idea: (2) is better solution.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
