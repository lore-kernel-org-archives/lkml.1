Return-Path: <linux-kernel-owner+w=401wt.eu-S1751520AbZDWPfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbZDWPfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 11:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751720AbZDWPfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 11:35:10 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:33211 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbZDWPfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 11:35:08 -0400
Date: Thu, 23 Apr 2009 11:41:45 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, e1000-devel@lists.sourceforge.net,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [E1000-devel] e1000: "eeprom checksum is not valid" after kexec
Message-ID: <20090423144145.GA3749@vespa.holoscopio.com>
References: <49F06EEB.9060500@gmail.com> <20090423141026.GB4046@vespa.holoscopio.com> <49F07B69.1020305@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <49F07B69.1020305@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 23, 2009 at 04:30:01PM +0200, Jiri Slaby wrote:
> On 04/23/2009 04:10 PM, Thadeu Lima de Souza Cascardo wrote:
> > On Thu, Apr 23, 2009 at 03:36:43PM +0200, Jiri Slaby wrote:
> >> Hi,
> >>
> >> 4a865905f685eaefaedf6ade362323dc52aa703b
> >> (PCI PM: Make pci_set_power_state() handle devices with no PM support)
> >> breaks e1000 after being kexec'ed. These reverts fix the problem:
> >>     Revert "PCI PM: Make pci_set_power_state() handle devices with no =
PM
> >> support"
> >>     Revert "PCI PM: Introduce __pci_[start|complete]_power_transition()
> >> (rev. 2)"
> >>
> >> I reverted the second one just for an easy revert of the former one,
> >> which is actually the culprit.
> >>
> >> The symptoms:
> >> e1000 0000:02:01.0: enabling device (0000 -> 0003)
> >> e1000 0000:02:01.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> =
IRQ 11
> >> e1000 0000:02:01.0: setting latency timer to 64
> >> e1000: 0000:02:01.0: e1000_probe: The EEPROM Checksum Is Not Valid
> >> Switched to high resolution mode on CPU 0
> >=20
> > Have you tried b43fcd7dc7b, found in v2.6.30-rc3?
>=20
> I've tried 2.6.30-rc3-next-20090423 without success.

You mean next-20090423. The patch is really found there.

But, then, I realize you mean reverting these patches for the kernel
that is running or the kernel that is being kexec'd?

If b43fcd7dc7b is applied to the running kernel, it fixes the shutdown
issue, and the next loaded kernel probes e1000 fine.

If you are reverting 4a865905f in the kexec'd kernel and the running
kernel does not have b43fcd7dc7b, then I'd like to test the revert for
my case here, which is e100.

Which is it?

Regards,
Cascardo.

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknwfikACgkQyTpryRcqtS0lDACfQllmexUatgI2O/fN/VAFV0et
4BUAoJdGtjtxzRVm6K8lZSFslFtoQIYd
=2CnN
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
