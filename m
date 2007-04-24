Return-Path: <linux-kernel-owner+w=401wt.eu-S1422967AbXDXS0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422967AbXDXS0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 14:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422993AbXDXS0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 14:26:22 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:4385 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422967AbXDXS0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 14:26:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type;
        b=nELBX+b8faws73RhwWSu3IVxOvU69kHQufobQt2S0FrmqOClkt8JLPcfi2pmlx8fpEAEIUWzGNTtmIXryefuHLS7nVkU+3IJ3NYRqvBKkJaqzLgoxRGdJf12zxq4YsOphb13g8im7aJAPfrn47LOH9kiOv8a9oD3YMbc+6c4iYY=
Date: Tue, 24 Apr 2007 11:26:01 -0700
From: Mike Mattie <codermattie@gmail.com>
To: CK <kernel@kolivas.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: rsdl v46 report,numbers,comments
Message-ID: <20070424112601.56f5bfb6@reforged>
X-Mailer: Claws Mail 2.6.1 (GTK+ 2.10.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary=Sig_RdAvkpxAtqcJfnIE8Vs3nMF;
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_RdAvkpxAtqcJfnIE8Vs3nMF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

0. intro

I am very happy to report that v46 of RSDL subjectively is much better than=
 v42. As you (Con Kolivas) might=20
remember from a previous mail I was experimenting with using nice levels ef=
fectively. I have refined these=20
levels to this layout:

-2  : clock (ntpd)
-1  : syslog,sshd,X
0   : command; default for shells
1   : audacious (audio), xfce window manager (with compositor on )
2   :  emacs (SCHED_OTHER), desktop/window manager infrastructure (dbus), s=
sh-agent , bind (batch scheduled )
3   : desktop applications (mail , xchat, openoffice )
5   : spamd,batch scheduled compiles/test-suites.
10  : cron jobs

1. Some numbers

My machine is a particularly tough case I think. A uni-processor Athlon XP =
3000+ (involuntary pre-empt) with a=20
software RAID5 on PATA drives. I load it heavily with compiles/test-suites,=
 and I am very sensitive to audio=20
glitches.=20

here are some stats for idle:

---load-avg--- ------memory-usage----- ----total-cpu-usage---- ----interrup=
ts--- ---system--
_1m_ _5m_ 15m_|_used _buff _cach _free|usr sys idl wai hiq siq|__17_ __18_ =
__20_|_int_ _csw_
 0.2  0.2  0.2| 170M   15M  309M 6560k|  2   1  94   4   0   0|   1     7  =
 150 | 238   208=20
 0.2  0.2  0.2| 170M   15M  309M 6568k|  1   0  99   0   0   0|   0     0  =
   0 |  76    55=20
 0.2  0.2  0.2| 170M   15M  309M 6568k|  0   1  99   0   0   0|   0     0  =
   0 |  75    47=20
 0.2  0.2  0.2| 170M   15M  309M 6624k|  4   0  96   0   0   0|   0     0  =
   0 |  75    37=20
 0.2  0.2  0.2| 170M   15M  309M 6624k|  1   0  99   0   0   0|   0     0  =
   0 |  75    36=20

here are some stats for music playing:

---load-avg--- ------memory-usage----- ----total-cpu-usage---- ----interrup=
ts--- ---system--
_1m_ _5m_ 15m_|_used _buff _cach _free|usr sys idl wai hiq siq|__17_ __18_ =
__20_|_int_ _csw_
 0.9  0.4  0.2| 175M   15M  305M 5652k|  2   1  94   4   0   0|   1     7  =
 150 | 238   210=20
 0.9  0.4  0.2| 175M   15M  305M 5652k| 10   1  89   0   0   0|   0     3  =
 989 |1068  1510=20
 0.9  0.4  0.2| 175M   15M  305M 5592k| 13   0  87   0   0   0|   0     3  =
1013 |1093  1565=20
 0.9  0.4  0.2| 175M   15M  304M 6300k| 11   1  88   0   0   0|   0     3  =
1000 |1078  1496=20
 0.9  0.4  0.2| 175M   15M  305M 6300k| 13   0  87   0   0   0|   0     3  =
1006 |1084  1509=20
 0.8  0.4  0.2| 175M   15M  305M 6180k| 13   1  86   0   0   0|   0     3  =
1000 |1078  1524=20
 0.8  0.4  0.2| 175M   15M  305M 6060k| 12   1  87   0   0   0|   0     3  =
1000 |1078  1564=20

The context switches are high, but so are the interrupts (USB 2.0 Audigy NX)

To see how effective using these nice levels were I decided to play with rr=
_interval, on the theory
that with priorities strictly enforced and used aggressively that a longer =
time-slice would not
cause audio delay. So far that theory is holding. All of these numbers are =
with rr_internal =3D 20, and
I have less audio problems than any previous kernel/tuning setup.

That is very impressive.

as far as batch loading goes I tried a kernel compile. These numbers look n=
ice for RSDL but there are
some caveats:

kernel compile , CFS v3                     : make  756.83s user 89.37s sys=
tem 58% cpu 24:08.21 total
kernel compile , v46 rr_interval =3D default  : make  754.66s user 89.74s s=
ystem 59% cpu 23:35.38 total
kernel compile , v46 rr_interval =3D 20       : make  682.83s user 84.34s s=
ystem 73% cpu 17:29.57 total

1. The system was noisy. I did this intentionally. My typical load is a mix=
ture of desktop/compile.
   All three numbers were generated while listening to music, reading docs/=
web/news, using emacs etc.
   with each of the compiles I tried running a visualization plugin (Projec=
tM inside audacious ) for
   a minute or so.

   This skews the numbers for comparison , but I was looking for an impress=
ion that was based off a
   *real* work-load.=20

   It would like to add as well that before RSDL the mainline scheduler fai=
led completely at running=20
   ProjectM even when it was the only application on the desktop. ( It stal=
led for seconds with a rock steady period ).

2. All of these ran nice 5 sched: BATCH

3. I have the xfce compositor turned on, using the transparency.

4. compiled on software RAID 5 (md) -> dev mapper -> lvm2 -> ext3 , 4 drive=
s, write-cache disabled,
   external 512 mg flash drive for a external journal , commit=3D15, journa=
l=3Ddata

=46rom the caveats above , especially the deep stack for the block layer, plu=
s meeting audio deadlines
while sharing a interrupt with the journal drive (arghh) this is very impre=
ssive system behavior for me.

Here is the stats for doing a kernel compile with audacious running, plus m=
ail,editor etc.

---load-avg--- ------memory-usage----- ----total-cpu-usage---- ----interrup=
ts--- ---system--
_1m_ _5m_ 15m_|_used _buff _cach _free|usr sys idl wai hiq siq|__17_ __18_ =
__20_|_int_ _csw_
 1.3    1  0.8| 198M   22M  269M   11M|  3   1  92   4   0   0|   1     7  =
 199 | 287   348=20
 1.3    1  0.8| 204M   22M  269M 6072k| 79  12   0   9   0   0|   0     7  =
1003 |1087  2160=20
 1.3    1  0.8| 195M   22M  268M   16M| 82  18   0   0   0   0|   0     8  =
1003 |1085  2703=20
 1.3    1  0.8| 200M   22M  268M   10M| 82  16   0   2   0   0|   0     8  =
1009 |1094  2204=20
 1.4    1  0.8| 195M   22M  269M   15M| 83  15   0   2   0   0|   0     8  =
1014 |1099  3007=20
 1.4    1  0.8| 200M   22M  269M 9488k| 82  14   0   4   0   0|   0     7  =
1000 |1082  2361=20
 1.4    1  0.8| 200M   22M  267M   12M| 83  15   0   2   0   0|   0     7  =
1000 |1085  2579=20


Now for some comments from the peanut gallery.

2. Window Manager scheduler hinting ?

On reflection my workload may be the easy case. As a developer I run a
somewhat small number of applications, typically the lightest I can find, e=
xcept emacs :)

A more typical desktop user might not be able to use my sort of setup, wher=
e I can push
a batchy job down in priority and wait for it. I also write shell functions=
, aliases etc=20
to set this up, which is easy for a distro, but not necessarily average use=
r usable.
For the users where they are running multiple monolithic CPU hog programs, =
like openoffice,firefox etc=20
This sort of approach won't suit them.

However the strict enforcement of RSDL could be leveraged for the desktop u=
ser as well. The Mac OSX
scheduler has layered on-top of the typical nice priority levels the concep=
t of foreground and background
scheduling. Basically the Mac window manager can tune the scheduling based =
on window focus.

I think something like this combined with RSDL could be a worthy experiment=
. If the window manager can
calculate the "attention" a user gives a window then it could nice it up/do=
wn within a small range.
Mac OS X has a nasty behavior of being jerky when switching focus under loa=
d. I think this is due to
a simplistic knee-jerk response to window focus in scheduling (or my ibook =
has to little RAM).

If a linux window manager were to rank the attention of windows, and be sma=
rt about cycling between
groups of apps I think three priority levels could be used like this:

1  : foreground ( frequent attention )
2  : background ( infrequent attention )
3  : batchy ( downloaders, other long running infrequently monitored progra=
ms )

Think of how easy this is for a window-manager to compute, compared to tryi=
ng to re-build the
information in-kernel with heuristics.

If this idea is actually pursued there may need to be a new feature in RSDL=
. With this scheme it is very important
to ensure that a particular nice level does not become overloaded ( think f=
oreground ) . The current linux schedulers
report a load value for the total system. This scheme needs to know the loa=
d value for a individual nice level as well,
that way the foreground nice level could remain responsive by worst case ki=
cking a program down a level or two if it
starts becoming unresponsive.

3. Better throughput

I think that this mixed developer work-load is actually the worst case for =
a scheduler. It has to meet deadlines
and provide decent throughput. Beyond pre-empt and clock precise scheduling=
 I am not sure if there is much more
that can be done for interactive.

I do think that SCHED_BATCH provides alot of room for interesting ideas tho=
ugh since the guarantees are so loose.
As I understand it SCHED_BATCH is guaranteed to not starve and that is abou=
t it.

Since I am commenting freely here is a idea to be taken with a huge grain o=
f salt. Is it possible that
the scheduler could compute and combine the deadlines for both audio/video =
? If the scheduler can compute
the longest interval between both video/audio refresh then scheduling could=
 be arranged like so:

refresh -> interactive -> batch -> refresh

The interactive processes would run first, that way the risk of missing a r=
efresh would be minimized. Once
the scheduler has ran all the interactive stuff, for the case of a small se=
t of programs such
as audio player and editor, it would be very likely that alot of time is le=
ft.

Next assume that the SCHED_BATCH has been sorted into CPU intensive and IO =
intensive. For the CPU intensive
it would be nice if the scheduler would give it a massive time-slice, why n=
ot all the time until the
next refresh point ? Basically reduce the context-switching to mostly inter=
rupts/background noise.=20
The SCHED_BATCH programs may take longer to run, as they are being interlea=
ved more than balanced, but I think it's=20
possible that overall throughput could be increased considerably. If someth=
ing like this could be done while
still honoring the nice values (though not as strictly as for interactive p=
rograms ) it would be a big win.
With huge time-slices other parts of the system such as VM management might=
 behave more efficiently as well.

I think linux would be quite special if it was the best in throughput effic=
iency (ignoring completion
time, just how much processor etc used to run the same work-load ) for SETI=
 like work-loads while still=20
running a fully responsive interactive desktop.

btw, the above concept is articulated from a distant background of programm=
ing a VGA adapter on a 286.
     That the last time I dealt with hard-deadlines hands on. I haven't had=
 a reason to code at bare-metal=20
     since I started using linux so please consider it a vehicle for articu=
lating a concept.=20

4. Outro

In summary I like the RSDL scheduler quite a bit. It is consistent and does=
n't do magic so I can build a
priority scheme on-top of it with a very compact and reliable behavior mode=
l. Using the priority levels
seems to allow me to use larger time-slices without sacrificing interactivi=
ty. This is unsuprising as
I am actually telling the scheduler what I want ......

I think that the window manager can use simple algorithms to calculate what=
 the kernel would have to guess
at with hairy heuristics. Hacking nice throttling into the window manager c=
ombined with a very simple
but reliable scheduler may work pretty well for desktop users. Maybe that w=
ill excite someone enough to
go try it, or dig up some existing implementation (other than OSX).

I also think that SCHED_BATCH is where alot of fun experiments can be playe=
d. Especially in regards to CPU
intensive programs. This combination is actually quite common I would think=
 in audio/video production.

At this point with how well my system works the itch has been scratched as =
far as the in-kernel part goes.=20
I am interested though in playing around with your idlerun program though.=
=20

Later on , possibly much later I will cook up some better numbers/compariso=
ns. I really don't trust subjective
evaluations of scheduling, my own included. I think people really want a ne=
w kernel patch to work better, which=20
is a horrible way to start an evaluation. I want to measure both throughput=
, and interactivity in a double-blind
like way. (random option for grub ?)

With most of my work-load IO bound I expect the performance improvements to=
 come from places like CFQ,ext4,syslet etc.

Thank you to all for a good kernel. Linux user-space is quite comfortable t=
hese days.

Cheers,
Mike Mattie - codermattie@gmail.com

--Sig_RdAvkpxAtqcJfnIE8Vs3nMF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGLkvCdfRchrkBInkRAnT4AJ0VODRRKbwzgBYwhZFWdUX7+tVE8QCgk/6j
6cpa0sHwnVIabqIclCM7fkU=
=9RRq
-----END PGP SIGNATURE-----

--Sig_RdAvkpxAtqcJfnIE8Vs3nMF--
