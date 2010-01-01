Return-Path: <linux-kernel-owner+w=401wt.eu-S1751815Ab0AAOmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815Ab0AAOmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 09:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694Ab0AAOmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 09:42:21 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57906 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751330Ab0AAOmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 09:42:20 -0500
Date: Fri, 1 Jan 2010 14:43:00 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: "Andrew G. Morgan" <morgan@kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>, Bryan Donlan <bdonlan@gmail.com>,
       Benny Amorsen <benny+usenet@amorsen.dk>,
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
Subject: Re: [RFC][PATCH v3] Unprivileged: Disable raising of privileges
Message-ID: <20100101144300.023f47a5@lxorguk.ukuu.org.uk>
In-Reply-To: <m1aawzm1tc.fsf@fess.ebiederm.org>
References: <551280e50912300652r1007dee0j8de750bf33af9b3c@mail.gmail.com>
	<m1fx6suswz.fsf@fess.ebiederm.org>
	<20091230201712.GA23999@us.ibm.com>
	<m1hbr8tb8q.fsf_-_@fess.ebiederm.org>
	<20091230212931.233003b9@lxorguk.ukuu.org.uk>
	<m1skasrvnq.fsf@fess.ebiederm.org>
	<20091230230042.5d2e78ac@lxorguk.ukuu.org.uk>
	<3e8340490912301844p4fddaf57ke58ceeba9582e0fa@mail.gmail.com>
	<20091231173334.5e3d7557@lxorguk.ukuu.org.uk>
	<20091231175257.GA7210@us.ibm.com>
	<551280e50912311020x2bdc5b1o699a601f67b91662@mail.gmail.com>
	<m1aawzm1tc.fsf@fess.ebiederm.org>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> - unprivileged process took action to prevent gaining a capability.
> - exec'd suid sendmail.
> - sendmail took action as root because it could not become someone else.

Which is a classic bug and replicated historically in cpu time, quota and
other similar "remove rights and then .." attacks.

> I would like to trivially stop that entire class of exploit by making
> execing a suid ( or equivalent ) executable impossible.

Fine the LSM modules can already build such policies or you can add a new
LSM for it - it doesn't need whacky one off extensions to prctl.

Of course you could also have an LSM which undoes restrictions on suid
apps instead. Thats an equally valid model, just don't load both at once
and don't assume you have the one true model.
