Return-Path: <linux-kernel-owner+w=401wt.eu-S1752559AbZL2UfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbZL2UfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 15:35:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbZL2UfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 15:35:16 -0500
Received: from gate1.ipvision.dk ([94.127.49.2]:59040 "EHLO gate1.ipvision.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409AbZL2UfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 15:35:14 -0500
X-Greylist: delayed 1480 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Dec 2009 15:35:14 EST
From: Benny Amorsen <benny+usenet@amorsen.dk>
To: Bryan Donlan <bdonlan@gmail.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Michael Stone <michael@laptop.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, David Lang <david@lang.hm>,
       Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>, Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>, Pavel Machek <pavel@ucw.cz>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: RFC: disablenetwork facility. (v4)
References: <20091229050114.GC14362@heat> <m1y6km11lj.fsf@fess.ebiederm.org>
	<20091229151146.GA32153@us.ibm.com>
	<3e8340490912290805s103fb789y13acea4a84669b20@mail.gmail.com>
Date: Tue, 29 Dec 2009 21:10:11 +0100
In-Reply-To: <3e8340490912290805s103fb789y13acea4a84669b20@mail.gmail.com>
	(Bryan Donlan's message of "Tue, 29 Dec 2009 11:05:09 -0500")
Message-ID: <m3oclhzgm4.fsf@ursa.amorsen.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Spam-Score: -4.1 (----)
X-Spam-Report: ALL_TRUSTED=-3.3, AWL=-0.568, BAYES_40=-0.185
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Donlan <bdonlan@gmail.com> writes:

> I, for one, think it would be best to handle it exactly like the
> nosuid mount option - that is, pretend the file doesn't have any
> setuid bits set. There's no reason to deny execution; if the process
> would otherwise be able to execute it, it can also copy the file to
> make a non-suid version and execute that instead.

Execute != read. The executable file may contain secrets which must not
be available to the user running the setuid program. If you fail the
setuid, the user will be able to ptrace() and then the secret is
revealed.

It's amazing how many security holes appear from what seems like a very
simple request.


/Benny

