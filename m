Return-Path: <linux-kernel-owner+w=401wt.eu-S1753298Ab0AKMBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab0AKMBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 07:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077Ab0AKMBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 07:01:33 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58160 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab0AKMBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 07:01:32 -0500
Date: Mon, 11 Jan 2010 13:01:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Michael Stone <michael@laptop.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-security-module@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       David Lang <david@lang.hm>, Oliver Hartkopp <socketcan@hartkopp.net>,
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
       "Serge E. Hallyn" <serue@us.ibm.com>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 2/3] Security: Implement disablenetwork semantics. (v4)
Message-ID: <20100111120131.GB1697@atrey.karlin.mff.cuni.cz>
References: <20100110215848.GA26609@elf.ucw.cz> <20100110224010.GA3825@heat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100110224010.GA3825@heat>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >You can trivialy make disablenetwork disable setuid exec, too. That
> >will introduce better isolation facilities, but not introduce any new
> >security problems.
> >
> >For some reason, you don't want to do the obviously right thing.
> 
> I don't want to do it because it's not "obviously right" to me: I *have* 
> setuid
> programs that I want to be able to raise privileges when network-disabled.
> I *don't have* any setuid programs that will be harmed by disablenetwork.

Well, I do not have any desire to use disablenetwork, but I do not
want my users to use it and DoS sendmail.

> Examples of software that I want to be able to gain privileges normally 
> include:

You'll have to make sure those are not accessed from the
disablenetworked parts, I'd say. Pre-existing unix domain socket
should be the way to go.

>   rainbow, which requires privilege in order to add new accounts to the 
>   system
>   and in order to call setuid() but which does not require networking
>   privileges.
> 
>   qmail-queue, which uses setuid to deliver mail that it reads from fd 0 to
>   local users
> 
>   and other old favorites like mount, fusermount, X, and, presumably, any 
>   audio
>   software that wants to go realtime.

mount certainly wants network access for NFS.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
