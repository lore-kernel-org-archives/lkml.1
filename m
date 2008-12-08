Return-Path: <linux-kernel-owner+w=401wt.eu-S1753160AbYLHVKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbYLHVKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 16:10:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbYLHVKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 16:10:07 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:48393 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbYLHVKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 16:10:05 -0500
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Alex Chiang <achiang@hp.com>
Subject: Re: Problems with fakephp
Date: Mon, 8 Dec 2008 22:09:53 +0100
User-Agent: KMail/1.9.10
Cc: Trent Piepho <xyzzy@speakeasy.org>, "Darrick J. Wong" <djwong@us.ibm.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-pci" <linux-pci@vger.kernel.org>,
       Matthew Wilcox <matthew@wil.cx>, gregkh@suse.de
References: <20081126074808.GE6539@plum> <200812031855.50874.eike-kernel@sf-tec.de> <20081203182200.GC26130@ldl.fc.hp.com>
In-Reply-To: <20081203182200.GC26130@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart16390786.B7uBQ5PUq2";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200812082209.57172.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart16390786.B7uBQ5PUq2
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Alex Chiang wrote:
> * Rolf Eike Beer <eike-kernel@sf-tec.de>:
> > Alex Chiang wrote:
> > > * Rolf Eike Beer <eike-kernel@sf-tec.de>:
> > > > Alex Chiang wrote:
> > > > > 	- wholesale replacement of fakephp with new fakephp
> > > > > 	- schedule new fakephp for deprecation
> > > >
> > > >                    ^^^
> > > >
> > > > I don't think so.
> > >
> > > If we get function level reset as part of the PCI core, then I
> > > don't see what fakephp offers us anymore.
> >
> > Why add a new fakephp if you want to remove it right after that?
>
> How we got here:
>
> 	- we made changes to PCI core that says,
> 	  "/sys/bus/pci/slots/ is for _physical_ slots"
>
> 	- that series of changes broke an existing interface
> 	  (fakephp) that had real users
>
> 	- the existing interface was interesting because it was
> 	  the only way that allowed for function level hotplug
>
> So, if we can get function level hotplug via a different
> interface (by adding a "remove" attribute to pci-sysfs), then I
> don't really see a strong reason to keep fakephp.
>
> We also don't want to break existing software (more than we
> already have :-/ ) so we need a transition period to get users
> over to the new "remove" interface.
>
> A deprecation period is usually pretty long, several years, iirc.
>
> > > > > 	- encourage anyone who wants function level
> > > > > 	hotplug to use the 'remove' attribute
> > > > >
> > > > > Thoughts? Jesse, Willy, Eike, Greg?
> > > >
> > > > Oh yes, let's start using dummyphp ;) That one already
> > > > handled the rescan long ago. But I think it's a bit
> > > > outdated at the moment, I haven't touched it for month.
> > > > Looks like I need to bring it back to live.
> > >
> > > I take it you are not impressed with my proposal? Care to
> > > explain why not?
> >
> > It's a long fight between me and Greg about fakephp. I wrote
> > dummyphp, fakephp is a for of an early version of dummyphp that
> > I never liked. So if anyone comes up with "fakephp can not do
> > $foobar" my first answer is "try dummyphp".  So if you want to
> > remove fakephp I'm the first do support you *eg* Yes, this
> > probably is mostly personal taste and not so much technical,
> > but I'm just human ;)
>
> Ok, well I haven't seen dummyphp.
>
> I don't think we should really care that much about dummyphp vs.
> new fakephp as long as we complete the end goal, which in my
> opinion is:
>
> 	/sys/bus/pci/slots/ represents physical slots and device hotplug
>
> 	/sys/devices/<bus>/<function>/remove used for function hotplug
>
> If we can use dummyphp to get us through the transition period,
> meaning it can:
>
> 	- provide an interface compatible with fakephp
> 	- allow recursive hotplug (remove a bridge and all
> 	  functions behind it)
> 	- recognize if a function has been hotplugged via a
> 	  different interface
> 	- relatively simple implementation
>
> Then I'm sure that Trent won't mind whether we use your dummyphp
> or his new fakephp.
>
> I'm wondering though, if dummyphp uses the PCI hotplug API, it
> will probably suffer from the same limitation that the current
> fakephp does, which is that the PCI hotplug core will only allow
> drivers to claim on a _device_ level, not _function_ level.

Exactly.

> Care to post dummyphp for us to see?

http://opensource.sf-tec.de/kernel/dummyphp-2.6.28-rc7.diff

Since I'm rather short on time it's not in a state I would like to see it i=
n,=20
i.e. I've not tested it for the last year.

Greetings,

Eike

--nextPart16390786.B7uBQ5PUq2
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkk9jSUACgkQXKSJPmm5/E4sMQCfezF6Oe13Lq6qQsEZhKPsEQZl
HDYAoJHAscpAO6HaoJZi8nQjH2kUeWdu
=Ndqa
-----END PGP SIGNATURE-----

--nextPart16390786.B7uBQ5PUq2--
