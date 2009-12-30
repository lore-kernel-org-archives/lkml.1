Return-Path: <linux-kernel-owner+w=401wt.eu-S1753364AbZL3XAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbZL3XAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 18:00:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbZL3XAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 18:00:16 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50446 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752127AbZL3XAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 18:00:10 -0500
Date: Wed, 30 Dec 2009 23:00:42 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       "Andrew G. Morgan" <morgan@kernel.org>,
       Bryan Donlan <bdonlan@gmail.com>,
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
Message-ID: <20091230230042.5d2e78ac@lxorguk.ukuu.org.uk>
In-Reply-To: <m1skasrvnq.fsf@fess.ebiederm.org>
References: <m1iqbpwjtp.fsf@fess.ebiederm.org>
	<20091229223631.GB22578@us.ibm.com>
	<m1aax1uoa3.fsf_-_@fess.ebiederm.org>
	<3e8340490912291954v5a837a26p64bd776102d281d7@mail.gmail.com>
	<m1r5qdt721.fsf@fess.ebiederm.org>
	<3e8340490912292057g3e87eaabn115f85b78af2b08c@mail.gmail.com>
	<m1d41w62zc.fsf_-_@fess.ebiederm.org>
	<551280e50912300652r1007dee0j8de750bf33af9b3c@mail.gmail.com>
	<20091230183513.GC14493@us.ibm.com>
	<m1fx6suswz.fsf@fess.ebiederm.org>
	<20091230201712.GA23999@us.ibm.com>
	<m1hbr8tb8q.fsf_-_@fess.ebiederm.org>
	<20091230212931.233003b9@lxorguk.ukuu.org.uk>
	<m1skasrvnq.fsf@fess.ebiederm.org>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Dec 2009 13:36:57 -0800
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
> 
> >> Added bprm->nosuid to make remove the need to add
> >> duplicate error prone checks.  This ensures that
> >> the disabling of suid executables is exactly the
> >> same as MNT_NOSUID.
> >
> > Another fine example of why we have security hooks so that we don't get a
> > kernel full of other "random security idea of the day" hacks.
> 
> Well it comes from plan 9.  Except there they just simply did not
> implement suid.  What causes you to think dropping the ability
> to execute suid executables is a random security idea of the day?

Well to be fair its random regurgitated security idea of every year or
two.

More to the point - we have security_* hooks so this kind of continuous
security proposal turdstream can stay out of the main part of the kernel.

Cleaning up the mechanism by which NOSUID is handled in kernel seems a
good idea. Adding wacky new prctls and gunk for it doesn't, and belongs
in whatever security model you are using via the security hooks.



