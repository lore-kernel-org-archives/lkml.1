Return-Path: <linux-kernel-owner+w=401wt.eu-S1753659Ab0ALC4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab0ALC4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 21:56:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753340Ab0ALC4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 21:56:09 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:53440 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab0ALC4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 21:56:07 -0500
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
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 2/3] Security: Implement disablenetwork semantics. (v4)
In-Reply-To: Your message of "Sun, 10 Jan 2010 22:58:48 +0100."
             <20100110215848.GA26609@elf.ucw.cz>
From: Valdis.Kletnieks@vt.edu
References: <alpine.LRH.2.00.1001110811350.25601@tundra.namei.org> <20100110215409.GA3705@heat>
            <20100110215848.GA26609@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1263264853_4979P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 11 Jan 2010 21:54:13 -0500
Message-ID: <5768.1263264853@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail: UCE(50)
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=50/50, host=steiner.cc.vt.edu
X-Junkmail-SD-Raw: score=bulk(0),
	refid=str=0001.0A020206.4B4BE45A.00F0,ss=3,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1263264853_4979P
Content-Type: text/plain; charset=us-ascii

On Sun, 10 Jan 2010 22:58:48 +0100, Pavel Machek said:

> Scenario 2:
> 
> Mallory calls disablenetwork, calls sendmail as the first user after
> boot; sendmail can't deliver anything (its network is disabled), but
> starts forking and taking requests for other users, DoSing the mail
> delivery.

You need to be root to start sendmail as a daemon.  If Mallory is getting
a root shell before your /etc/rc.d scripts have started sendmail, you
have bigger problems.

> Scenario 3:
> 
> Mallory calls disablenetwork, then keeps hammering on su, knowing that
> su can no longer send data to audit subsystem and so he will not get caught.

I assume you mean syslog, not audit.  And it still won't work.

% strace /usr/bin/logger test message
...
socket(PF_FILE, SOCK_DGRAM|SOCK_CLOEXEC, 0) = 1
connect(1, {sa_family=AF_FILE, path="/dev/log"}, 110) = 0
sendto(1, "<13>Jan 11 21:49:25 logger: test"..., 40, MSG_NOSIGNAL, NULL, 0) = 40
close(1)                                = 0

su's complaint will get written to /dev/log which isn't interfered with
by the disablenetwork patch - and then syslogd will forward over the net
if configured to do so.

--==_Exmh_1263264853_4979P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLS+RVcC3lWbTT17ARAvE0AJ9I5zWQJ1HToLmy89MmBaBr1PJfKQCfZNug
TNmPDNNUi2d6bhPMIXnWTI4=
=dF24
-----END PGP SIGNATURE-----

--==_Exmh_1263264853_4979P--

