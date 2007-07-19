Return-Path: <linux-kernel-owner+w=401wt.eu-S936226AbXGSQfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936226AbXGSQfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 12:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934863AbXGSQfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 12:35:00 -0400
Received: from cust198-202.dsl.versadsl.be ([62.166.198.202]:51736 "HELO
	idefix.wisa.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1765729AbXGSQe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 12:34:58 -0400
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jul 2007 12:34:57 EDT
Date: Thu, 19 Jul 2007 18:27:34 +0200 (CEST)
From: =?ISO-8859-1?Q?Dani=EBl_Mantione?= <daniel.mantione@freepascal.org>
X-X-Sender: daniel@idefix.wisa.be
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Keyboard programming needs root
In-Reply-To: <d120d5000707190817t62013ddcg966bd4e8c0ec116f@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0707191748340.10291@idefix.wisa.be>
References: <f79qnt$rn3$1@sea.gmane.org> <d120d5000707190817t62013ddcg966bd4e8c0ec116f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="657924-1701969859-1184862454=:10291"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--657924-1701969859-1184862454=:10291
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE



Op Thu, 19 Jul 2007, schreef Dmitry Torokhov:

> Hi Daniel,
>=20
> On 7/14/07, Daniel Mantione <daniel.mantione@freepascal.org> wrote:
> > Hello,
> >=20
> > A while back a patch was merged to make that only root can program the
> > keyboard:
> >=20
> > http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3D=
commit;h=3D0b360adbdb54d5b98b78d57ba0916bc4b8871968
> >=20
> > Is this patch discussable? I think this patch isn't proper because of t=
he
> > following reasons:
> >=20
> > * Users can play games in many ways. They can configure the terminal
> > settings, (remove the automatic line feed, disable the echo etc). They
> > can
> > load console fonts. They can still put the keyboard in raw mode, etc.
>=20
> Keyboard raw mode or disabling line echo may be annoying but you
> really don't want someone leaving box after binding "rm -rf /" to a
> backspace key...

As I said, the proper solution to this problem is to restore the keyboard=
=20
in a known state after logout. There is no need for the kernel to change=20
behaviour. Many operating systems allow changing keyboard layout and can=20
because there is no need for it to be insecure.

However, I can agree that in some cases, as per system policy,=20
administrators mays want to prevent this.

> > * All of these games can be prevented by making mingetty (or whatever=
=20
> >   getty is used) or PAM can put the console into a known state after=20
> >   logout.
> > * All of these games are annoyances, system security is not=20
> >   compromised.
> > * I do not see a problem with for example a French user doing a "loadke=
ys
> > fr" if that allows hims to use the computer easier.
> >=20
> > Worst issue for me though, is that KDSBENT is needed to be able to catc=
h
> > keys like shift+tab, alt+fx, escape without delay. My application
> > suddenly
> > needs root permissions to work properly.
>=20
> Yes, if your application mucks with the console it has to be trusted...

That is not really constructive: I don't want to muck with the console, I
a working keyboard. Linux just just requires you to muck with the console i=
f=20
you want a working keyboard. Many applications, Midnight Commander to name=
=20
one, work around Linux console limitations (try ctrl+arrows,=20
works as expected despite not supported by Linux).

Now if you force applications to work around limitations, you have a=20
certain responsibility not to break them.

> > The alternative, semi raw mode,
> > has the disadvantage that you need to implement your own keymaps (like
> > X).
> > In short, this change breaks applications.
> >=20
>=20
> You may also try reading data directly from evdev devices... They are
> normally privileged as well but usually user logged on console is
> given access to them.

evdev has the same problem as medium/full raw mode: You need your own=20
keyboard maps. This makes this solution not very practical.

To make this discussion productive, I want to work towards a solution. I=20
don't mind how I can make the keyboard work as it should, I just want it=20
work. Think of the needs of a user interface, you walk through controls=20
using tab and shift+tab, put common commands under the function keys and=20
shift/control/alt combinations. Cursor control in an editor is done with=20
the navigation pad on your keyboard: arrows, home/end/pgup/pgdown, plus=20
shift/control/alt combinations with them.

That is all, nothing fancy. Could the kernel support a way to do this?

Greetings,

Dani=EBl Mantione
--657924-1701969859-1184862454=:10291--
