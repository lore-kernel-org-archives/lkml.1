Return-Path: <linux-kernel-owner+w=401wt.eu-S1767318AbXDTXFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767318AbXDTXFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 19:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767321AbXDTXFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 19:05:50 -0400
Received: from mse2fe1.mse2.exchange.ms ([69.25.50.163]:7242 "EHLO
	mse2fe1.mse2.exchange.ms" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767318AbXDTXFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 19:05:47 -0400
X-Greylist: delayed 846 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Apr 2007 19:05:47 EDT
Subject: Re: Permanent Kgdb integration into the kernel - lets get with it.
From: Piet Delaney <pdelaney@bluelane.com>
Reply-To: pdelaney@bluelane.com
To: Randy Dunlap <randy.dunlap@oracle.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Jason Wessel <jason.wessel@windriver.com>
Cc: pdelaney@bluelane.com, Piet Delaney <piet@bluelane.com>,
       Tom Rini <trini@kernel.crashing.org>, Andi Kleen <ak@suse.de>,
       Dave Jiang <djiang@mvista.com>, linux-kernel@vger.kernel.org,
       sshtylyov@ru.mvista.com, Andrew Morton <akpm@osdl.org>,
       George Anzinger <george@wildturkeyranch.net>,
       "David O'Brien" <obrien@FreeBSD.org>
In-Reply-To: <20070417113016.1f0812c7.randy.dunlap@oracle.com>
References: <20070307204516.GA24095@blade.az.mvista.com>
	 <200703081814.53153.ak@suse.de> <45F04B6E.9000703@mvista.com>
	 <200703081937.56167.ak@suse.de> <20070308184940.GP11626@smtp.west.cox.net>
	 <1173392650.8912.236.camel@piet2.bluelane.com>
	 <20070417113016.1f0812c7.randy.dunlap@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-U6YuXAK0b/FvzhLWB0gi"
Organization: Blue Lane Technologies
Date: Fri, 20 Apr 2007 15:51:35 -0700
Message-Id: <1177109495.9479.81.camel@piet2.bluelane.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4-3mdk 
X-OriginalArrivalTime: 20 Apr 2007 22:51:40.0542 (UTC) FILETIME=[75A8D9E0:01C7839E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-U6YuXAK0b/FvzhLWB0gi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-04-17 at 11:30 -0700, Randy Dunlap wrote:
> On Thu, 08 Mar 2007 14:24:10 -0800 Piet Delaney wrote:
>=20
> > On Thu, 2007-03-08 at 11:49 -0700, Tom Rini wrote:
> > > On Thu, Mar 08, 2007 at 07:37:56PM +0100, Andi Kleen wrote:
> > > > On Thursday 08 March 2007 18:44, Dave Jiang wrote:
> > > >=20
> > > > > In spite of kgdb, shouldn't it have that \n anyways in case some =
other code
> > > > > gets added in the future after the macro? Or are you saying that =
there should
> > > > > never be any code ever after that macro?
> > > >=20
> > > > Sure if there is mainline code added after that macro we add the \n=
.
> > > > But only if it makes sense to add code there, which it didn't in kg=
db.
> > >=20
> > > Was that because with recent enough tools and config options there wa=
s
> > > enough annotations so GDB could finally figure out where things had
> > > stopped?  Thanks.
> >=20
> > The reason Linus said he didn't allow George's kgdb mm patch to=20
> > be integrating into the kernel a year or two ago was that Amit and
> > George had significantly different implementations. So Amit, Tom,=20
> > George, and the rest of the kgdb development gang worked together=20
> > and came up with a unified version that we now support on SourceForge.=20
> >=20
> > Tom rolled up a mm patch back in December for Andrew and then the
> > integration process stopped. I suggest we work together on getting
> > the kgdb patch back into the mm series and permanently into the kernel
> > like the kexec code and then we can avoid this kernel development
> > obfuscation.
>=20
> Hi,
> Is there any movement on this?

Hi Randy:

Jason Wessel <jason.wessel@windriver.com> is currently leading yet
another attempt at getting kgdb permanently into the kernel. Jason
has a linux2_6_21 patch on SourceForge:
=09
http://kgdb.cvs.sourceforge.net/kgdb/kgdb-2/8250.patch?view=3Dlog&pathrev=
=3Dlinux2_6_21_uprev

and has been working with Sergei Shtylyov <sshtylyov@ru.mvista.com>
recently on getting KGDBOE Netpoll patches that got lost around the=20
time of Tom's attempt. Just on Monday there were a dozen posting to=20
the source forge mailing list:

=09

kgdb-bugreport@lists.sourceforge.net

on this effort.

I'd like to see a git repository on kernel.org that is used to update
the mainstream kernel. Unfortunately getting accounts on kernel.org is
next to impossible. If Jason doesn't have one yet it would be nice to
offer him one for the kgdb developers to use.=20

I agree with Andi that the kgdb code seems to be getting more
complicated that needed thought I don't find the hooks offensive.
Here I keep my kgdb hooks completely under #ifdef KGDB, so there
is absolutely no difference to the kernel when KGDB isn't configured.
I also like having debug printks, similar to the SOCK_DEBUG() macros,
to make it easy to watch kgdb internals in action. Ya can't run kgdb
on itself.=20

I find these blemish's a minor concern compared to the damage/lost
of not integrating kgdb into the kernel permanently. When developers
can't rely on using kgdb for easy development they tend to write code
without consideration for what it's like using their code with the
debugger. Linux is making a major headway into $100 embedded systems;
the recent use in the Linksys WRT54GL (DD-WRT) and Engenius EOC-3220
for example. Making kgdb easily accessible will make the viability of
using Linux for embedded system greatly increased, IMHO.=20

Perhaps with a bit of support from the kernel.org folks we could get
the kgdb patch, with all of it's blemishes, into Andrews 2.6.21-rc7-mm1
patch. Accounts on kernel.org for kgdb developers would be a modest
effort. I find the CVS patch framework rather clumsy and would rather
follow the KISS principle and just use git repositories like the rest
of the kernel developers appear to be using.

-piet

>=20
> Thanks,
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code =
***
--=20
Piet Delaney                                    Phone: (408) 200-5256
Blue Lane Technologies                          Fax:   (408) 200-5299
10450 Bubb Rd.
Cupertino, Ca. 95014                            Email: piet@bluelane.com

--=-U6YuXAK0b/FvzhLWB0gi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBGKUP3JICwm/rv3hoRAvOrAJ9Kl4u3CAChVUwP+Md3CRp5dAw/bwCfcOXb
Kqy1vKQS6nnOOaP4SXl9KF0=
=gIbN
-----END PGP SIGNATURE-----

--=-U6YuXAK0b/FvzhLWB0gi--

