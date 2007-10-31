Return-Path: <linux-kernel-owner+w=401wt.eu-S1754850AbXJaEJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbXJaEJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 00:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbXJaEJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 00:09:12 -0400
Received: from mx34.mail.ru ([194.67.23.200]:11719 "EHLO mx34.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888AbXJaEJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 00:09:11 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Alexey Starikovskiy <aystarik@gmail.com>
Subject: Re: [2.6.24-rc1 regression] AC adapter state does not change after resume
Date: Wed, 31 Oct 2007 07:09:01 +0300
User-Agent: KMail/1.9.7
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <200710302324.52822.arvidjaar@mail.ru> <47279D8C.5040708@gmail.com>
In-Reply-To: <47279D8C.5040708@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1606719.XSEWg3VSlV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200710310709.06621.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1606719.XSEWg3VSlV
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 31 October 2007, Alexey Starikovskiy wrote:
> Andrey Borzenkov wrote:
> > I suspect new ACPI AC adapter code but have to add some printk's to be
> > sure.
> >
> > To reproduce - plug in AC cord, suspend, unplug, resume - kpowersave and
> > sysfs still show AC adapter online. Or other way round.
> >
> > -andrey
>
> Please check if this patch helps.
>

It does not even compile :)

On serious note (after adding forward declaration) - patch half works. It d=
oes=20
make "online" return true value (which confirms that underlying ACPI works=
=20
correctly) but HAL still does not notice it.

The problem is, with power_supply interface HAL does not use polling, it=20
relies on CHANGE event. This event is apparently never generated if AC=20
adapter state changes on resume. So the obvious fix is to compare AC state=
=20
before and after suspend in ->resume function and generate synthetic CHANGE=
=20
event if something has changed.

This will also make superfluous polling redundant.

--nextPart1606719.XSEWg3VSlV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHJ//eR6LMutpd94wRAuufAJ9HLSss8laxu5MmxUXEZ8AIZm0guQCeO3vL
jEbEJr1ZwGWbVG/oGl9SRwI=
=pzbS
-----END PGP SIGNATURE-----

--nextPart1606719.XSEWg3VSlV--
