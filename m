Return-Path: <linux-kernel-owner+w=401wt.eu-S1763956AbXKTXg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763956AbXKTXg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 18:36:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbXKTXgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 18:36:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbXKTXgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 18:36:12 -0500
Message-ID: <47436E7F.2060901@redhat.com>
Date: Tue, 20 Nov 2007 15:32:15 -0800
From: Ulrich Drepper <drepper@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Guillaume Chazarain <guichaz@yahoo.fr>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Subject: Re: 2.6.24-rc3: find complains about /proc/net
References: <20071119191000.GA1560@elf.ucw.cz>	<200711192304.25087.rjw@sisk.pl>	<4743026B.2020907@openvz.org>	<m11wakshyz.fsf@ebiederm.dsl.xmission.com>	<20071120215914.GE24156@elte.hu>	<m1ve7wr28z.fsf@ebiederm.dsl.xmission.com>	<20071120223559.GA6655@elte.hu>	<20071120225457.B6E2D26F8BE@magilla.localdomain>	<20071120230106.GD24380@elte.hu>	<3d8471ca0711201506t6b2b88a0h9484f8a40a1f2e40@mail.gmail.com> <20071120232600.F1D2F26F8BE@magilla.localdomain>
In-Reply-To: <20071120232600.F1D2F26F8BE@magilla.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Roland McGrath wrote:
> Oh, it seems it has indeed been that way for a very long time, so I was
> mistaken.  It still seems a little odd to me.  Ulrich can say definitively
> whether the kind of concern I mentioned really matters one way or the other
> for glibc.

glibc cannot survive (at least NPTL) if somebody uses funny CLONE_*
flags to separate various pieces of information, e.g., file descriptors.
 So, all the information in each thread's /proc/self should be identical.

When the information is not the same, the current semantics seems to be
more useful.  So I guess, no change is the way to go here.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFHQ25/2ijCOnn/RHQRAmhhAJsHRF7FqO8DWwZ97gHxIO/i4Z1AAQCffCGa
Q2J8kjthKbbNQf1USWMAw3Y=
=xl/a
-----END PGP SIGNATURE-----
