Return-Path: <linux-kernel-owner+w=401wt.eu-S964934AbXDXK7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964934AbXDXK7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 06:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932819AbXDXK7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 06:59:33 -0400
Received: from lugor.de ([212.112.242.222]:37609 "EHLO solar.vpn.lugor.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932812AbXDXK7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 06:59:32 -0400
From: Christian Hesse <mail@earthworm.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: crash with CFS v4 and qemu/kvm (was: [patch] CFS scheduler, v4)
Date: Tue, 24 Apr 2007 12:54:12 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       kvm-devel@lists.sourceforge.net, Avi Kivity <avi@qumranet.com>
References: <20070420140457.GA14017@elte.hu> <200704231128.23594.mail@earthworm.de> <20070423101839.GA19599@elte.hu>
In-Reply-To: <20070423101839.GA19599@elte.hu>
X-Face: 1\p'dhO'VZk,x0lx6U}!Y*9UjU4n2@4c<"a*K%3Eiu'VwM|-OYs;S-PH>4EdJMfGyycC)=?utf-8?q?k=0A=09=3Anv*xqk4C?=@1b8tdr||mALWpN[2|~h#Iv;)M"O$$#P9Kg+S8+O#%EJx0TBH7b&Q<m)=?utf-8?q?n=23Q=2Eo=0A=09kE=7E=26T=5D0cQX6=5D?=<q!HEE,F}O'Jd#lx/+){Gr@W~J`h7sTS(M+oe5<=?utf-8?q?3O7GY9y=5Fi!qG=26Vv=5CD8/=0A=09=254?=@&~$Z@UwV'NQ$Ph&3fZc(qbDO?{LN'nk>+kRh4`C3[KN`-1uT-TD_m
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2143203.GxWJ45fF4u";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704241254.13791.mail@earthworm.de>
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-2.0 (solar.vpn.lugor.de [10.5.1.1]); Tue, 24 Apr 2007 12:54:22 +0200 (CEST)
X-Spam-Flag: NO
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2143203.GxWJ45fF4u
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 23 April 2007, Ingo Molnar wrote:
> * Christian Hesse <mail@earthworm.de> wrote:
> > On Friday 20 April 2007, Ingo Molnar wrote:
> > > i'm pleased to announce release -v4 of the CFS patchset.
> >
> > Hi Ingo, hi Avi, hi all,
> >
> > I'm trying to use kvm-20 with cfs v4 and get a crash:
> >
> > eworm@revo:~$ /usr/local/kvm/bin/qemu -snapshot
> > /mnt/data/virtual/qemu/winxp.img kvm_run: failed entry, reason 7
> > kvm_run returned -8
> >
> > It works (though it is a bit slow) if I start qemu with strace, so for
> > me it looks like a race condition?
>
> hm. Can you work it around with:
>
>    echo 0 > /proc/sys/kernel/sched_granularity_ns
>
> ?
>
> If yes then this is a wakeup race: some piece of code relies on the
> upstream scheduler preempting the waker task immediately in 99% of the
> cases.
>
> and you might want to test -v5 too which i released earlier today. It
> has no bugfix in this area though, so it will likely still trigger this
> race - but it will also hopefully be even more pleasant to use than -v4
> ;-)

Hi Ingo,

This was kvm's fault. It works perfectly now without modifications to the=20
scheduler. If anybody is interested in details please see the kvm mailing=20
list archives.
=2D-=20
Regards,
Chris

--nextPart2143203.GxWJ45fF4u
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGLeHVlZfG2c8gdSURAh+RAKDjPNqb6szSUmu1Dk6D8NesN2z+nQCfe+xl
ScGfSVhCgdDFz4ZAH5lvNsA=
=d9CV
-----END PGP SIGNATURE-----

--nextPart2143203.GxWJ45fF4u--
