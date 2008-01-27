Return-Path: <linux-kernel-owner+w=401wt.eu-S1755851AbYA0PGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbYA0PGe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 10:06:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbYA0PGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 10:06:25 -0500
Received: from mail.gmx.net ([213.165.64.20]:54822 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752272AbYA0PGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 10:06:24 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/w2RoeJZnwaWXYE1hRSYTu70WKctWrzip7EWOFxi
	Kh0j9SUgYdyczL
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: vatsa@linux.vnet.ibm.com
Subject: Re: (ondemand) CPU governor  regression between 2.6.23 and 2.6.24
Date: Sun, 27 Jan 2008 16:06:17 +0100
User-Agent: KMail/1.9.7
Cc: Tomasz Chmielewski <mangoo@wpkg.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com
References: <479B69D2.5050603@wpkg.org> <200801261946.54518.toralf.foerster@gmx.de> <20080127144610.GA25632@linux.vnet.ibm.com>
In-Reply-To: <20080127144610.GA25632@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1243458.xAqy6tcq7q";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200801271606.19862.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1243458.xAqy6tcq7q
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Sonntag, 27. Januar 2008 schrieb Srivatsa Vaddagiri:
> On Sat, Jan 26, 2008 at 07:46:51PM +0100, Toralf F=F6rster wrote:
> >=20
> > The problem is the same as described here : http://lkml.org/lkml/2007/1=
0/21/85
> > If I run dnetc even with lowest prority than the CPU stays at 600 MHz r=
egardless
> > of any other load (eg. rsyncing, svn update, compiling, ...)
> >=20
> > Stopping the dnetc process immediately speeds up the CPU up to 1.7 GHz.
> >=20
> >=20
> > Am Samstag, 26. Januar 2008 schrieben Sie:
> > > During the test, run top, and watch your CPU usage. Does it go above =
80%=20
> > > (the default for=20
> > > /sys/devices/system/cpu/cpu0/cpufreq/ondemand/up_threshold).
> >=20
> > No, instead I get :
> >=20
> >  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> >  7294 dnetc     39  19   664  348  264 R 49.5  0.0   0:48.68 dnetc
> >  7310 tfoerste  20   0  1796  492  428 R 48.5  0.0   0:07.19 factor
> >  7050 root      20   0 96736 8872 3972 S  0.7  0.9   0:02.99 X
>=20
> Hi Toralf,
> 	Can you list the o/p you see for overall cpu usage? You should
> see something like below right at the top of the o/p:
>=20
> top - 20:03:59 up 12 days, 21:39, 18 users,  load average: 0.22, 0.20, 0.=
25
> Tasks: 200 total,   5 running, 193 sleeping,   0 stopped,   2 zombie
> Cpu(s):  2.6% us,  1.3% sy,  0.0% ni, 96.0% id,  0.0% wa,  0.0% hi, 0.0% =
si,  0.0% st
>=20
> The third line (giving overall cpu usage stats) is what is interesting he=
re.
> If you have more than one cpu, you can get cpu usage stats for each cpu
> in top by pressing 1. Can you provide this information with and w/o=20
> CONFIG_FAIR_GROUP_SCHED?

This is what I get if I set CONFIG_FAIR_GROUP_SCHED to "y"

top - 16:00:59 up 2 min,  1 user,  load average: 2.56, 1.60, 0.65
Tasks:  84 total,   3 running,  81 sleeping,   0 stopped,   0 zombie
Cpu(s): 49.7%us,  0.3%sy, 49.7%ni,  0.0%id,  0.0%wa,  0.3%hi,  0.0%si,  0.0=
%st
Mem:   1036180k total,   322876k used,   713304k free,    13164k buffers
Swap:   997880k total,        0k used,   997880k free,   149208k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 6070 dnetc     39  19   664  348  264 R 49.7  0.0   1:09.71 dnetc
 6676 tfoerste  20   0  1796  488  428 R 49.3  0.0   0:02.72 factor

Stopping dnetc gives:

top - 16:02:36 up 4 min,  1 user,  load average: 2.50, 1.87, 0.83
Tasks:  89 total,   3 running,  86 sleeping,   0 stopped,   0 zombie
Cpu(s): 99.3%us,  0.7%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0=
%st
Mem:   1036180k total,   378760k used,   657420k free,    14736k buffers
Swap:   997880k total,        0k used,   997880k free,   180868k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 6766 tfoerste  20   0  1796  488  428 R 84.9  0.0   0:05.41 factor


> If I am not mistaken, cpu ondemand gov goes by the cpu idle time stats,
> which should not be affected by FAIR_GROUP_SCHED. I will lookaround for
> other possible causes.

As I stated our in http://lkml.org/lkml/2008/1/26/207 the issue is solved
after unselecting FAIR_GROUP_SCHED.=20

BTW my answer to an email of Mike Galbraith was Cced to the lkml here :
http://lkml.org/lkml/2008/1/27/116

=2D-=20
MfG/Sincerely

Toralf F=F6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--nextPart1243458.xAqy6tcq7q
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHnJ3rhyrlCH22naMRAhWcAJ9IHYEU5Wy+LEnJjkJirh9Tnhp9JQCfaPSp
nj/Kw0TowDcW6nl0EM1wIfE=
=Sm2j
-----END PGP SIGNATURE-----

--nextPart1243458.xAqy6tcq7q--
