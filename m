Return-Path: <linux-kernel-owner+w=401wt.eu-S1752100AbYKLQoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbYKLQoE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 11:44:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750777AbYKLQnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 11:43:53 -0500
Received: from 30.mail-out.ovh.net ([213.186.62.213]:45050 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750763AbYKLQnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 11:43:52 -0500
Message-ID: <491B07BC.1050900@neotion.com>
Date: Wed, 12 Nov 2008 17:43:40 +0100
From: Neil Armstrong <narmstrong@neotion.com>
Reply-To: narmstrong@neotion.com
Organization: Neotion
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: "Hans J. Koch" <hjk@linutronix.de>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uio: add ioctl callback
References: <491AF8D1.4060106@neotion.com> <20081112154919.GC2891@local> <491AFD7C.8090607@neotion.com> <20081112162333.GD2891@local>
In-Reply-To: <20081112162333.GD2891@local>
X-Enigmail-Version: 0.95.7
OpenPGP: id=1166F485
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig745DE54150300469A2FC59E5"
X-Ovh-Tracer-Id: 559572254072337553
X-Ovh-Remote: 82.236.40.173 (sop06-1-82-236-40-173.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig745DE54150300469A2FC59E5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

I should have specified that I work on a SoC, which does not follow
strict rules like PCI devices.
=46rom a hardware designer point of view, this is a "good" design
especially for this kind of device. (DVB Conditionnal Access Slave
Shared Memory)
If the code was in the kernel space, we could do some processing in irq
mode like other devices of the SoC.

Thanks for your time and comments, I will see the irqcontrol solution as
an alternative.

Just forget my patch since it's only applicable to very specific devices.=


Neil

Hans J. Koch a =E9crit :
> On Wed, Nov 12, 2008 at 04:59:56PM +0100, Neil Armstrong wrote:
>  =20
>> Hi Hans,
>>
>> We need an ioctl callback because we need to query some values only
>> available when the irq handler is running.
>> For example, we have 3 types of reasons why the irq is triggered and
>> these bits are no more available when the irq is cleared.
>>    =20
>
> Ah, that one. That's why we invented the irqcontrol hook. In case of
> such broken hardware, you need to mask the irq in the kernel without
> touching the register containing those volatile bits. On a system where=

> you can be sure the irq is not shared, you can simply use disable_irq()=
=2E
>
> If the irq might be shared, you need to find something else. PCI cards,=

> for example, often have a register within their PCI bridge that contain=
s
> irq mask bits (that's how it is done in uio_cif.c).
>
> Userspace can then reenable the irq by writing the value 1 as a signed
> 32-bit int to /dev/uioX. You need to implement an irqcontrol() function=

> in your kernel driver that does the right thing (e.g. call enable_irq()=

> in the first example).
>
>  =20
>> The cleanest way to have this very specific information is to have a
>> dirty old ioctl returning this data.
>>    =20
>
> The cleanest way would be to throw such hardware into the trash bin :-)=

>
> A chip where the irq mask register cannot be written without destroying=

> the irq status register is simply broken and bad design.
>
> Thanks,
> Hans
>  =20


--------------enig745DE54150300469A2FC59E5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFJGwe9b5rmahFm9IURAibhAJ4sYN7l0HKXupEYMt2KUuqkipGd9gCdHxox
4qIW0tf/Gy/26pLeOO50yFs=
=gcM7
-----END PGP SIGNATURE-----

--------------enig745DE54150300469A2FC59E5--
