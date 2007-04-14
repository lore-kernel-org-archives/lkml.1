Return-Path: <linux-kernel-owner+w=401wt.eu-S965509AbXDNKcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965509AbXDNKcn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 06:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965522AbXDNKcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 06:32:43 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:3132 "EHLO yumi.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965509AbXDNKcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 06:32:42 -0400
Date: Sat, 14 Apr 2007 12:32:40 +0200
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, pavel@suse.cz, linux-pm@lists.osdl.org
Subject: Re: Linux 2.6.21-rc6
Message-ID: <20070414103239.GA2806@melchior.yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Adrian Bunk <bunk@stusta.de>, pavel@suse.cz, linux-pm@lists.osdl.org
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <20070413235017.GR5907@stusta.de> <20070414081619.GA24909@melchior.yamamaya.is-a-geek.org> <200704141105.56265.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200704141105.56265.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Saturday, 14 April 2007 10:16, Tobias Diedrich wrote:
> > Adrian Bunk wrote:
> > > On Fri, Apr 13, 2007 at 11:29:55PM +0200, Tobias Diedrich wrote:
> > > > Linus Torvalds wrote:
> > > > 
> > > > > We should be getting close to a 2.6.21 release, so please update any 
> > > > > regression reports you've done,
> > > > 
> > > > For me, suspend to disk works only once (has been the case for all
> > > > .21-rcs IIRC, but I didn't get around to report it so far).
> > > > There are some threads about an issue like this, which is supposed
> > > > to be fixed by disabling CONFIG_PCI_MSI, but on my system the
> > > > problem persists nonetheless.
> > > > 
> > > > On the second suspend attempt, the last message I see is
> > > > "Suspending console(s)"
> > > > 
> > > > If I find the time, I'll try to bisect it this weekend.
> > > >...
> > > 
> > > Does the latest -git work?
> > 
> > Still no luck with
> > Linux melchior 2.6.21-rc6-gd791d413-dirty #4 PREEMPT Sat Apr 14 09:34:21 CEST 2007 x86_64 GNU/Linux
> 
> Can you boot with init=/bin/bash and see if the problem is present in this
> configuration?

Doesn't help.
Maybe interesting:
In the init=/bin/bash run, the first suspend try was without swap
and thus bailed out. After swapon, the second try already hung,
despite not having 'really' suspended at all on the first try.
I tried it once more, with swap on the first try and got the same
'second try doesn't work' result.

git-bisect so far:
git-bisect start
# good: [fa285a3d7924a0e3782926e51f16865c5129a2f7] Linux 2.6.20
git-bisect good fa285a3d7924a0e3782926e51f16865c5129a2f7
# bad: [2eb1ae149a28c1b8ade687c5fbab3c37da4c0fba] Linux 2.6.21-rc1
git-bisect bad 2eb1ae149a28c1b8ade687c5fbab3c37da4c0fba
# bad: [574009c1a895aeeb85eaab29c235d75852b09eb8] Merge branch 'upstream' of git://ftp.linux-mips.org/pub/scm/upstream-linus
git-bisect bad 574009c1a895aeeb85eaab29c235d75852b09eb8
# good: [43187902cbfafe73ede0144166b741fb0f7d04e1] Merge master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6
git-bisect good 43187902cbfafe73ede0144166b741fb0f7d04e1
# good: [beda9f3a13bbb22cde92a45f230a02ef2afef6a9] kbuild: more Makefile cleanups
git-bisect good beda9f3a13bbb22cde92a45f230a02ef2afef6a9
# bad: [7edc136ab688f751037a86e8a051151d7962d33f] Char: isicom, support higher rates
git-bisect bad 7edc136ab688f751037a86e8a051151d7962d33f

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
このメールは十割再利用されたビットで作られています。
