Return-Path: <linux-kernel-owner+w=401wt.eu-S1753089AbXDZAtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089AbXDZAtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 20:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbXDZAtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 20:49:15 -0400
Received: from 85-10-211-152.clients.your-server.de ([85.10.211.152]:2704 "EHLO
	nesselzelle.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663AbXDZAtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 20:49:13 -0400
X-Greylist: delayed 482 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Apr 2007 20:49:12 EDT
Date: Thu, 26 Apr 2007 02:41:03 +0200
From: Thomas Orgis <thomas-forum@orgis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kenneth Crudup <kenny@panix.com>, Nick Piggin <npiggin@suse.de>,
       suspend2-devel@lists.suspend2.net, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
Message-ID: <20070426024103.1179d952@neuling>
In-Reply-To: <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org>
References: <200704182245.24156.mail@earthworm.de>
	<20070418211632.GA7610@elte.hu>
	<200704182357.28107.mail@earthworm.de>
	<20070418220228.GA14536@elte.hu>
	<1176947576.5906.21.camel@nigel.suspend2.net>
	<20070419070437.GA25211@elte.hu>
	<20070424202336.GC16503@elf.ucw.cz>
	<alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
	<20070424212408.GD16457@elf.ucw.cz>
	<alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
	<20070425072350.GA6866@ucw.cz>
	<Pine.LNX.4.64.0704251239110.8406@vaio.localdomain>
	<alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary=Sig_qp6JffFIXuxh3XtYY1LeG3S;
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_qp6JffFIXuxh3XtYY1LeG3S
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Sort of my 2-many-cents story on why I need "snapshot/restore"...

Am Wed, 25 Apr 2007 13:08:09 -0700 (PDT)
schrieb Linus Torvalds <torvalds@linux-foundation.org>:=20

>=20
>=20
> On Wed, 25 Apr 2007, Kenneth Crudup wrote:
> >=20
> > Any working suspend-to-disk method takes care of that for me.  (I'm
> > really not sure why Linus hates S2D so much, though. Back in the day
> > there was a lot more BIOS support, but that's been years now.)
>=20
> The really sad part is that APM actually did this better..=20

This really triggers a nerve in me. My laptops (always used models from
some years ago, even) didn't necessarily get easier with respect to power
management (suspend) over time.

My first laptop (Siemens Scenic Mobile 710, 200Mhz Pentium, maxed to
192MB RAM) worked just fine with APM, be it s2ram or s2disk.
Everything handled by the BIOS.
Admittedly, S2disk was quite slow as it stored all ram and didn't write
to the disk as fast as possible, but it worked.
S2ram was also a viable option because I was even able to easily swap
batteries because the thing had two bays to put batteries in.

The next one was a Toshiba Portege 7020 CT (366MHz Pentium2 with dynamic
clock, 192MB), supporting both APM and ACPI.
Installing Linux was not that easy, I think I remember that APM in kernel
froze the box (early 2.6 kernel), while ACPI needed some headache to set
up (compiling a fixed DSDT into the kernel, for example)... I needed
experimental toshiba_acpi to get functions and the acpi_pm_timer to
get something like continuous system clock (special cpu throttling has
funny effects).
Well, I got it together after some time.
Used suspend2 for "snapshot/restore" and actually was able to use ACPI
S3 with the glitch of having to unload/load psmouse driver ... until I
realized that it only resumed in about 80% of cases (BIOS ....).
So suspend2 was a badly needed "hack" around the hardware/BIOS to get
some sane workflow.
I remember dealing with swsusp / pmdisk before... but I really ended
up with suspend2 as the thing that works (and I wouldn't have bothered
finding this patch if the in-kernel stuff worked for me).
Of course this was a long time ago and recently I have seen that
in-kernel swsusp works ok, just this unresponsiveness after "restore"
due to missing page cache...

Now I have an IBM ThinkPad X31 (600-1.4GHz Pentium M, 512MB).
ACPI. SpeedStep.
The machine generally works fine, hardware config via ACPI seems to
be fine.
But doing S3/STR? Well... this machine has the odd idea that turning the
system off but the screen backlight back on after a second is a good idea.
Of course just now S3 worked fine... you cannot even depend on the
malfunction -- could have something to do with changing bootup video
from LCD to VGA output for some other reason recently.
Hm. Perhaps it even may work (after tricking the BIOS!?). But I doubt
I'll suddenly develop trust in that.
I _had_ trust in APM STR and STD.
I am quite confident in suspend2 being able to correctly resume (restore)
after a successful suspend (snapshot/restore).

And then, STR doesn't help me on the road when I need to exchange the
battery (I'd need this special extra battery to put under the ThinkPad
for that).
Another thing is that the old Siemens has a nice auxilliary monochrome
LCD that shows the charge status of the batteries in 5 levels, so you
have some means to predict the time you have in STR. The Thinkpad has
greed LED for "battery level OK" and red for "battery level low".
Well, but the Linux kernel won't change that...

Perhaps at some time ACPI implementations in BIOS get to something
reliable (hm, should I get a PowerBook instead?) and can be a good partner
for Linux which struggles for many years now to get into the post-APM era.
Remember reading desktop PC test reports in the c't magazine in the last
years, S3 usually did _not_ work; with Windows, even.
Well, there must be a reason Microsoft chose to implement the "hibernate"
(it _is_ in software, right?).

The APM->ACPI transition made me use the software STD
(snapshot/restore...;-) and I think I will stay with it for the
forseeable future, and be it because I can do fancy things like image
encryption.
ACPI S3 / STR is a nice addition when it works, for the smaller pauses
(changing a train at the station, leaving office for half an hour...),
but I consider STD really to be the more important feature that enables
me to _never_ close my applications unless I want to do a kernel update.

I really must say that some sort of STD is a total must for a laptop for me.
On the other hand I once had a Psion 5MX, which basically was on STR all
the (non-working) time -- and enabled well over 20h of working time on two =
AAs.
When laptops enter that range of battery life, I guess I could arrange with
just doing STR and won't have to worry about changing batteries without AC
connection;-)


Alrighty then,

Thomas.

--Sig_qp6JffFIXuxh3XtYY1LeG3S
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGL/Ugm0xSvNRG1SQRAmCKAKCIMAED536HguJjz98gJ4swWzQc8ACfSucb
J6I96Y22F+eBjr7U88hqpqY=
=VQRA
-----END PGP SIGNATURE-----

--Sig_qp6JffFIXuxh3XtYY1LeG3S--
