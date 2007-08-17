Return-Path: <linux-kernel-owner+w=401wt.eu-S1764871AbXHQNQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764871AbXHQNQf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 09:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760297AbXHQNQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 09:16:27 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:57931 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758782AbXHQNQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 09:16:25 -0400
Message-ID: <46C59FA6.7020601@bull.net>
Date: Fri, 17 Aug 2007 15:16:22 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [kvm-devel] [PATCH/RFC 4/4,	second shot]KVM uses "account_guest_time()"
References: <46C4719A.2060308@bull.net>	<46C4720F.7030304@bull.net>		<46C4725A.4070607@bull.net>	<46C4740F.2050701@bull.net>		<1187303955.6449.7.camel@localhost.localdomain>	<46C54FB8.7050504@bull.net>	<1187339450.6449.115.camel@localhost.localdomain>	<46C56774.2030009@bull.net>	<46C58BD5.3090207@bull.net> <46C58C8C.3080803@bull.net> <46C59C92.40902@qumranet.com>
In-Reply-To: <46C59C92.40902@qumranet.com>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 17/08/2007 15:21:34,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 17/08/2007 15:21:36,
	Serialize complete at 17/08/2007 15:21:36
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig9F0A0390A13AC28B70D28840"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9F0A0390A13AC28B70D28840
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Laurent Vivier wrote:
>> KVM updates vtime in task_struct to allow account_guest_time() to modi=
fy user,
>> system and guest time in cpustat accordingly.
>>  =20
>=20
>> --- kvm.orig/drivers/kvm/Kconfig	2007-08-17 10:24:46.000000000 +0200
>> +++ kvm/drivers/kvm/Kconfig	2007-08-17 10:25:25.000000000 +0200
>> @@ -41,4 +41,10 @@
>>  	  Provides support for KVM on AMD processors equipped with the AMD-V=

>>  	  (SVM) extensions.
>> =20
>> +config GUEST_ACCOUNTING
>> +	bool "Virtual Machine accounting support"
>> +	depends on KVM
>> +	---help---
>> +	  Allows to account CPU time used by the Virtual Machines.
>> +
>=20
>=20
> Other way round.  In the patch that adds account_guest_time(), have a
> CONFIG_GUEST_ACCOUNTING (defaulting to n, with no description, help, or=

> dependencies.  Then, CONFIG_KVM can select GUEST_ACCOUNTING.

I was wondering in which Kconfig I can put it...

> The advantages of this are:
> - the puppyvisor can also select this if it so wishes
> - we don't have core code reference some obscure module

I agree.

> CONFIG_PREEMPT_NOTIFIERS does the same thing.

I saw

Laurent
--=20
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth


--------------enig9F0A0390A13AC28B70D28840
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.7 (GNU/Linux)

iD8DBQFGxZ+u9Kffa9pFVzwRAk4UAJ45PUQ31VdS7JvfSOgee1fZtbj4pgCgy+0M
4ST8nImsXxd8lh7zh3FoFms=
=bYeR
-----END PGP SIGNATURE-----

--------------enig9F0A0390A13AC28B70D28840--
