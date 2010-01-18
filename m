Return-Path: <linux-kernel-owner+w=401wt.eu-S1751528Ab0ARMzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab0ARMzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 07:55:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750796Ab0ARMzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 07:55:52 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:42254 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab0ARMzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 07:55:50 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Pavel Machek <pavel@ucw.cz>
Cc: Michael Stone <michael@laptop.org>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-security-module@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       David Lang <david@lang.hm>, Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Bryan Donlan <bdonlan@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
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
In-Reply-To: Your message of "Thu, 14 Jan 2010 10:22:51 +0100."
             <20100114092250.GA11500@atrey.karlin.mff.cuni.cz>
From: Valdis.Kletnieks@vt.edu
References: <alpine.LRH.2.00.1001110811350.25601@tundra.namei.org> <20100110215409.GA3705@heat> <20100110215848.GA26609@elf.ucw.cz> <5768.1263264853@localhost> <20100112075927.GA24256@atrey.karlin.mff.cuni.cz> <32558.1263306523@localhost>
            <20100114092250.GA11500@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1263819244_6729P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 18 Jan 2010 07:54:04 -0500
Message-ID: <17852.1263819244@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=steiner.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020208.4B5459F0.023F,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1263819244_6729P
Content-Type: text/plain; charset=us-ascii

On Thu, 14 Jan 2010 10:22:51 +0100, Pavel Machek said:
> > On Tue, 12 Jan 2010 08:59:27 +0100, Pavel Machek said:
> > 
> > > Well, maybe, but mailer system where first user starts is as a daemon
> > > makes sense...
> > 
> > Does it?  How do you get port 25 open for listening if the first user isn't
> > root?  Most *actual* schemes to "launch at first use" that require privs fo
r
> > something have used inetd or similar - that program exists for a
> > *reason*.
> 
> Remember sendmail is setuid root... so it already has the permissions.

Actually, the sendmail setuid bit was removed quite some time ago:

8.12.0/8.12.0   2001/09/08
        *NOTICE*: The default installation of sendmail does not use
                set-user-ID root anymore.  You need to create a new user and
                a new group before installing sendmail (both called smmsp by
                default).  The installation process tries to install
                /etc/mail/submit.cf and creates /var/spool/clientmqueue by
                default.  Please see sendmail/SECURITY for details.

Wow.  2001. And people *still* think it's setuid. ;)

(Interestingly enough, the capabilities bug came *later*:

8.12.1/8.12.1   2001/10/01
        SECURITY: Check whether dropping group privileges actually succeeded
                to avoid possible compromises of the mail system by
                supplying bogus data.  Add configuration options for
                different set*gid() calls to reset saved gid.  Problem
                found by Michal Zalewski.

and was mostly an issue because the same problem existed in pre-8.12 sendmails
that were still setuid and hadn't upgraded yet...


--==_Exmh_1263819244_6729P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLVFnscC3lWbTT17ARArPiAJ9gsFOaXOoPI0PtsT+jBlxoTh9CwQCfaEBQ
AhZmttLo9rYq+6PtWIOHrRg=
=taue
-----END PGP SIGNATURE-----

--==_Exmh_1263819244_6729P--

