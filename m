Return-Path: <linux-kernel-owner+w=401wt.eu-S1752863AbZL2Vdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbZL2Vdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 16:33:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbZL2Vdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 16:33:49 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57084 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752847AbZL2Vdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 16:33:47 -0500
Date: Tue, 29 Dec 2009 21:35:19 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bryan Donlan <bdonlan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Benny Amorsen <benny+usenet@amorsen.dk>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Michael Stone <michael@laptop.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, David Lang <david@lang.hm>,
       Oliver Hartkopp <socketcan@hartkopp.net>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>, Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?UTF-8?B?QW3DqXJpY28=?= Wang <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>, Pavel Machek <pavel@ucw.cz>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: RFC: disablenetwork facility. (v4)
Message-ID: <20091229213519.09644bf9@lxorguk.ukuu.org.uk>
In-Reply-To: <3e8340490912291314m5e1b72e6s6e394d0a8cf95d00@mail.gmail.com>
References: <20091229050114.GC14362@heat>
	<m1y6km11lj.fsf@fess.ebiederm.org>
	<20091229151146.GA32153@us.ibm.com>
	<3e8340490912290805s103fb789y13acea4a84669b20@mail.gmail.com>
	<m3oclhzgm4.fsf@ursa.amorsen.dk>
	<m17hs5y0mg.fsf@fess.ebiederm.org>
	<20091229211139.0732a0c1@lxorguk.ukuu.org.uk>
	<3e8340490912291314m5e1b72e6s6e394d0a8cf95d00@mail.gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The security hole is that secrets in a setuid application with
> other-exec but no other-read permission can be read when the
> filesystem is mounted nosuid.

Erm no

We enforce the following anyway to prevent execution being permitted to
make file copies. Most Unixen do although its historical value is
primarily to prevent people "stealing valuable proprietary intellectual
software assets".


      } else if (file_permission(bprm->file, MAY_READ) ||
                    bprm->interp_flags & BINPRM_FLAGS_ENFORCE_NONDUMP)
      { 
             set_dumpable(current->mm, suid_dumpable);
      }

There does appear to be a small race in modern versions of that code
which wants swatting.

