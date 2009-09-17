Return-Path: <linux-kernel-owner+w=401wt.eu-S1753981AbZIQUbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbZIQUbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 16:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbZIQUbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 16:31:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50947 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348AbZIQUbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 16:31:21 -0400
Date: Thu, 17 Sep 2009 22:31:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [bug] /etc/profile: line 30: /dev/null: Permission denied
	(Was: Re: [PATCH] Remove broken by design and by implementation
	devtmpfs maintenance disaster)
Message-ID: <20090917203113.GA9530@elte.hu>
References: <m1y6oef08k.fsf@fess.ebiederm.org> <20090917125759.GA4045@kroah.com> <m1ab0tcwep.fsf@fess.ebiederm.org> <20090917185306.GA28635@elte.hu> <ac3eb2510909171218k4963fc7dv8fb7549007e511aa@mail.gmail.com> <alpine.LFD.2.01.0909171322210.4950@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0909171322210.4950@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 17 Sep 2009, Kay Sievers wrote:
> 
> > On Thu, Sep 17, 2009 at 20:53, Ingo Molnar <mingo@elte.hu> wrote:
> > > I've reproduced a bug with the following .config options:
> > >
> > > ??CONFIG_DEVTMPFS=y
> > > ??CONFIG_DEVTMPFS_MOUNT=y
> > >
> > > /dev/null and /dev/zero are not read/writable to ordinary users, 
> > > breaking normal bootup and login:
> > 
> > Udev should run long before some ordinary/non-root user can login, 
> > and apply the permissions as it always does. It's known to work on 
> > Fedora, SUSE, Ubuntu. What kind of system/environment/setup is that 
> > where you see this?
> 
> I don't know if this is what Ingo does, but I have a few machines 
> where I don't run the distro-supplied 'initrd' at all, because it's 
> easier to boot without it. The Fedora initrd doesn't allow me to 
> sanely set root filesystem parameters without totally rewriting the 
> initrd image, which I'm not interested in, for example (they'll take 
> effect for the root initrd, not the final root).

Correct: i'm booting raw bzImages, with /dev copied to the real /dev. To 
this box udev is mostly an annoyance that slows down my bootup ;-)

Furthermore, this is a really old image, Fedora Core 6, where udev does 
not get updated anymore. I still boot new kernels on it though, and it 
worked fine up to now.

	Ingo
