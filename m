Return-Path: <linux-kernel-owner+w=401wt.eu-S1753348AbZL2Qjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbZL2Qjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 11:39:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbZL2Qjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 11:39:44 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:47964 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbZL2Qjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 11:39:43 -0500
Date: Tue, 29 Dec 2009 10:39:39 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Bryan Donlan <bdonlan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
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
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>, Pavel Machek <pavel@ucw.cz>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: RFC: disablenetwork facility. (v4)
Message-ID: <20091229163939.GA6984@us.ibm.com>
References: <20091229050114.GC14362@heat>
 <m1y6km11lj.fsf@fess.ebiederm.org>
 <20091229151146.GA32153@us.ibm.com>
 <3e8340490912290805s103fb789y13acea4a84669b20@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3e8340490912290805s103fb789y13acea4a84669b20@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Bryan Donlan (bdonlan@gmail.com):
> On Tue, Dec 29, 2009 at 10:11 AM, Serge E. Hallyn <serue@us.ibm.com> wrote:
> > Eric, let me specifically point out a 'disable setuid-root'
> > problem on linux: root still owns most of the system even when
> > it's not privileged.  So does "disable setuid-root" mean
> > we don't allow exec of setuid-root binaries at all, or that
> > we don't setuid to root, or that we just don't raise privileges
> > for setuid-root?
> 
> I, for one, think it would be best to handle it exactly like the
> nosuid mount option - that is, pretend the file doesn't have any
> setuid bits set. There's no reason to deny execution; if the process
> would otherwise be able to execute it, it can also copy the file to
> make a non-suid version and execute that instead. And some programs
> can operate with reduced function without setuid. For example, screen
> comes to mind; it needs root to share screen sessions between multiple
> users, but can operate for a single user just fine without root, and
> indeed the latter is usually the default configuration.

That's fine with me, seems safe for a fully unprivileged program to
use, and would make sense to do through one of the securebits set
with prctl(PR_SET_SECUREBITS).

In addition, I assume we would also refuse to honor file capabilities?

-serge
