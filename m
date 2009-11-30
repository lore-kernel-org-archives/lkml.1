Return-Path: <linux-kernel-owner+w=401wt.eu-S1752477AbZK3Anp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbZK3Anp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 19:43:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbZK3Anp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 19:43:45 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:41893 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751622AbZK3Ano (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 19:43:44 -0500
X-Sasl-enc: DavGuAZoZrQmBd67byu0zWMCZnclhU+KbFmeYxrft6Pp 1259541830
Message-ID: <4B1314F8.10500@imap.cc>
Date: Mon, 30 Nov 2009 01:42:32 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       isdn@linux-pingi.de, mac@melware.de
Subject: Re: [PATCH] proc_fops: convert drivers/isdn/ to seq_file
References: <20091123015625.GA32088@x200.localdomain> <20091124162541.03e7e375.akpm@linux-foundation.org> <20091125045914.GA3528@x200.malnet.ru>
In-Reply-To: <20091125045914.GA3528@x200.malnet.ru>
X-Enigmail-Version: 0.97a
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCADF8FF118A91A6E08B1117A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCADF8FF118A91A6E08B1117A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 25.11.2009 05:59 schrieb Alexey Dobriyan:
> --- a/drivers/isdn/gigaset/capi.c
> +++ b/drivers/isdn/gigaset/capi.c
> @@ -2106,35 +2106,22 @@ static char *gigaset_procinfo(struct capi_ctr *=
ctr)
>  	return ctr->name;	/* ToDo: more? */
>  }
> =20
> -/**
> - * gigaset_ctr_read_proc() - build controller proc file entry
> - * @page:	buffer of PAGE_SIZE bytes for receiving the entry.
> - * @start:	unused.
> - * @off:	unused.
> - * @count:	unused.
> - * @eof:	unused.
> - * @ctr:	controller descriptor structure.
> - *
> - * Return value: length of generated entry
> - */
> -static int gigaset_ctr_read_proc(char *page, char **start, off_t off,
> -			  int count, int *eof, struct capi_ctr *ctr)
> +static int gigaset_proc_show(struct seq_file *m, void *v)

I would prefer that, instead of throwing the kerneldoc comment away,
you adapted it to the new function. Specifically, I would like to
know what the second argument "void *v" is for.

>  {
> +	struct capi_ctr *ctr =3D m->private;

See below.

> +static int gigaset_proc_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, gigaset_proc_show, PDE(inode)->data);

I'd like to understand how that works.

According to Documentation/filesystems/seq_file.txt, the value of
the last argument will be passed to the proc_show function in the
private field of the seq_file structure. Your gigaset_proc_show()
function assumes that this will be the capi_ctr pointer for the
device.

So what is PDE(inode)->data and where does it get set to the
capi_ctr pointer for the device?

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigCADF8FF118A91A6E08B1117A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAksTFQQACgkQQ3+did9BuFsuawCeL25ok+9FZWzZLBqMMRsm99G4
BJoAn1QaC0PR/P563/6I5oIV1E8EllvP
=d+xI
-----END PGP SIGNATURE-----

--------------enigCADF8FF118A91A6E08B1117A--
