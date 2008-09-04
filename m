Return-Path: <linux-kernel-owner+w=401wt.eu-S1754083AbYIDP2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbYIDP2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 11:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbYIDP2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 11:28:13 -0400
Received: from xenotime.net ([66.160.160.81]:57990 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751671AbYIDP2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 11:28:12 -0400
Date: Thu, 4 Sep 2008 08:28:07 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: Nir Tzachar <nir@tzachar.com>
cc: "Randy.Dunlap" <rdunlap@xenotime.net>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Nir Tzachar <tzachar@grad120a.cs.bgu.ac.il>,
       linux-kernel@vger.kernel.org, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] ncurses based config
In-Reply-To: <9b2db90b0809032155h6ed5df9ey846de96779022d11@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0809040822440.19666@shark.he.net>
References: <1220469076-16487-1-git-send-email-nir@tzachar.com> 
 <200809032138.14651.bzolnier@gmail.com>  <Pine.LNX.4.64.0809031259110.20541@shark.he.net>
 <9b2db90b0809032155h6ed5df9ey846de96779022d11@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1606286688-1057114846-1220542087=:19666"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1606286688-1057114846-1220542087=:19666
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 4 Sep 2008, Nir Tzachar wrote:

> Good morning.
>=20
> Sorry for the delay, it was night here...
>=20
> > Hi,
> > >
> > > On Wednesday 03 September 2008, Nir Tzachar wrote:
> > > > This patch was inspired by the kernel projects page, where an ncurs=
es
> > > > replacement for menuconfig was mentioned (by Sam Ravnborg).
> > > >
> > > > Building on menuconfig, this patch implements a more modern look
> > interface using
> > > > ncurses and ncurses' satellite libraries (menu, panel, form). The
> > implementation
> > > > does not depend on lxdialog, which is currently distributed with th=
e
> > kernel.
> > > >
> > > > The only change outside of nconf.c is due to a name clash: both ncu=
rses
> > and
> > > > lkc.h define a fucntion named menu_init(). I changed the internal
> > version's
> > > > name.
> > > >
> > > > Please consider the patch for merging. Comments are appreciated.
> > >
> > > Could you please tell what kernel version is it against?
> >
> > It applies cleanly to 2.6.27-rc5-git4 FWIW.
> >
>=20
> I based the patch on current git tree. Is a more stable version preferabl=
e?

No, that's fine.

> >
> > > I'm getting the following error on make nconfig (and also on make
> > menuconfig
> > > which works fine without this patch) with the current Linus' tree:
> > >
> > >   HOSTCC  scripts/kconfig/conf.o
> > >   HOSTCC  scripts/kconfig/kxgettext.o
> > >   HOSTCC  scripts/kconfig/nconf.o
> > >   HOSTCC  scripts/kconfig/zconf.tab.o
> > > scripts/kconfig/zconf.tab.c: In function =FF=FFconf_parse=FF=FF:
> > > scripts/kconfig/zconf.tab.c:2258: warning: implicit declaration of
> > function =FF=FFmenu_init=FF=FF
> > >   HOSTLD  scripts/kconfig/nconf
> > > scripts/kconfig/nconf arch/x86/Kconfig
> > > make[1]: *** [nconfig] Segmentation fault
> > > make: *** [nconfig] Error 2
> >
> > Need to change all /menu_init/ in zconf.tab.c* to /_menu_init/.
> >
>=20
> I believe the patch does change these lines.

Perhaps the patch was missing some pieces then.  It does not
contain any changes to the zconf* files.

> >
> > Need to strip trailing whitespace on new source code lines.
> >
>=20
> scripts/checkpatch.pl did not report anything here. Maybe git-email-send
> messed up the patch??

Too bad.

quilt reported several of those when I applied the patch.
AFAIK, git also will report that.

These lines have trailing spaces:

57:+nconf-objs  :=3D nconf.o zconf.tab.o=20
85:+HOSTLOADLIBES_nconf =3D -lmenu -lpanel -lform -lncurses=20
86:+HOSTCFLAGS_nconf.o  =3D=20
87:+LDFLAGS_nconf.o     =3D=20

> > I'm seeing cyan (?) foreground on black background.  Is that the colors
> > that were planned?
> >
>=20
> > Instructions are dark blue on black -- cannot read them.
> >
>=20
> Well, colors were never my strong point ;) If someone can come up with a
> better color scheme I'll be more than happy to change.

--=20
~Randy
---1606286688-1057114846-1220542087=:19666--
