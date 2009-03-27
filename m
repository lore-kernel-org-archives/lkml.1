Return-Path: <linux-kernel-owner+w=401wt.eu-S1757206AbZC0LiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206AbZC0LiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 07:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755260AbZC0Lh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 07:37:56 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:32920 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbZC0Lhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 07:37:55 -0400
X-Greylist: delayed 685 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Mar 2009 07:37:55 EDT
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Linux 2.6.29
Date: Fri, 27 Mar 2009 12:27:01 +0100
User-Agent: KMail/1.9.9
Cc: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <20090324132032.GK5814@mit.edu> <20090324160353.06a4a5ed@hobbes.virtuouswap> (sfid-20090325_092908_502849_27B3F1C9)
In-Reply-To: <20090324160353.06a4a5ed@hobbes.virtuouswap>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1474302.kQQn0crxJr";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200903271227.07424.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1474302.kQQn0crxJr
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Mittwoch 25 M=E4rz 2009 schrieb Jesse Barnes:
> On Tue, 24 Mar 2009 09:20:32 -0400
>
> Theodore Tso <tytso@mit.edu> wrote:
> > They don't solve the problem where there is a *huge* amount of writes
> > going on, though --- if something is dirtying pages at a rate far
> > greater than the local disk can write it out, say, either "dd
> > if=3D/dev/zero of=3D/mnt/make-lots-of-writes" or a massive distcc clust=
er
> > driving a huge amount of data towards a single system or a wget over
> > a local 100 megabit ethernet from a massive NFS server where
> > everything is in cache, then you can have a major delay with the
> > fsync().
>
> You make it sound like this is hard to do...  I was running into this
> problem *every day* until I moved to XFS recently.  I'm running a
> fairly beefy desktop (VMware running a crappy Windows install w/AV junk
> on it, builds, icecream and large mailboxes) and have a lot of RAM, but
> it became unusable for minutes at a time, which was just totally
> unacceptable, thus the switch.  Things have been better since, but are
> still a little choppy.
>
> I remember early in the 2.6.x days there was a lot of focus on making
> interactive performance good, and for a long time it was.  But this I/O
> problem has been around for a *long* time now... What happened?  Do not
> many people run into this daily?  Do all the filesystem hackers run
> with special mount options to mitigate the problem?

Well I always had the feeling that somewhen from one 2.6.x to another I/O=20
latencies increased a lot. But first I thought I was just imaging this=20
and when I more and more thought that this is for real, I forgot since=20
when I observed these increased latencies.

This is on IBM ThinkPad T42 and T23 with XFS.

I/O latencies are pathetic when dpkg reads in the database or I do tar -xf=
=20
linux-x.y.z.tar.bz2.

I never got down to what is causing these higher latencies though also I=20
tried different I/O schedulers, tuned XFS options, used relatime.

What I found tough is that on XFS at least a tar -xf linux-kernel / rm -rf=
=20
linux-kernel operation is way slower with barriers and write cache=20
enabled that with no barriers and no write cache enabled. And frankly I=20
never got that.

XFS crawls to a stop on metadata operations when barriers are enabled.=20
According to the XFS FAQ disabling drive write cache should be as safe as=20
enabling barriers. And I always unterstood barriers as a feature to be=20
have *some* ordering contraints, i.e. write before barrier go before=20
barrier and writes after it after it - even when a drives hardware write=20
cache is involved. But when this cache is enabled ordering will always be=20
like issued from Linux block layer cause all I/Os issued to the drive are=20
write-through and synchron without write cache, versus only barrier=20
requests are synchron with barriers and write cache.

=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart1474302.kQQn0crxJr
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknMuAcACgkQmRvqrKWZhMdIngCeM2EGhNPseiD5TRRjbMJVqHTk
5xYAni85/1ZN/ff8LCbyLPjcRJBw9bmr
=PBHk
-----END PGP SIGNATURE-----

--nextPart1474302.kQQn0crxJr--
