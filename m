Return-Path: <linux-kernel-owner+w=401wt.eu-S1753101AbZF3I5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbZF3I5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 04:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbZF3I5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 04:57:40 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:33480 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbZF3I5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 04:57:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer;
        b=I0vWepVu+33rxXYWhXWWoKFK+VigWFofQ6fKVE8vtueTV6K+a4vhmzojMloL/tO9AE
         lS+B3zDlAMLCmKqAsmMc+4UZtEirMhkqk0jpeUFbpbLSWzf3cSWTn+KSopxRYG5xgTjU
         z4vOI4GhEEzrXR1dB66XxhnC/MbKvqnKs2oYg=
Subject: Re: MFD: mutex from ISR in ezx-pcap?
From: Daniel Ribeiro <drwyrm@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: sameo@linux.intel.com, LKML <linux-kernel@vger.kernel.org>,
       laforge@openezx.org
In-Reply-To: <4A493BF9.7010304@gmail.com>
References: <4A49175E.3020409@gmail.com> <1246306840.18231.29.camel@brutus>
	 <4A493BF9.7010304@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-MMfh8O481sxigc6voD7Q"
Date: Tue, 30 Jun 2009 05:57:36 -0300
Message-Id: <1246352256.18231.408.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-MMfh8O481sxigc6voD7Q
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Em Ter, 2009-06-30 =C3=A0s 00:11 +0200, Jiri Slaby escreveu:=20
> > pcap_adc_irq actually already runs from a workqueue (pcap_isr_work).
>=20
> Aha, thanks, there is a specific irq handler. Ok, sounds fair.
>=20
> But interrupts are disabled in pcap_isr_work anyway,

Right.

> so that
> pcap_adc_irq shouldn't sleep, right? Or maybe I missed something again...

No. Interrupts are enabled again before pcap_adc_irq() runs.

pcap_isr_work() doesn't call pcap_adc_irq directly, it calls the
irq_flow_handler, handle_simple_irq(), which needs to run with
interrupts disabled. Interrupts are enabled again on handle_IRQ_event(),
as pcap_adc_irq is requested _without_ IRQF_DISABLED.

--=20
Daniel Ribeiro

--=-MMfh8O481sxigc6voD7Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Esta =?ISO-8859-1?Q?=E9?= uma parte de mensagem
 assinada digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpJ04AACgkQw3OYl0G0liRRrACeOdZuAbHLxhg9z0zcl0eezSZq
dm8AmwVrllpyn0feGFNJ/gLympSZxKVV
=Dl/v
-----END PGP SIGNATURE-----

--=-MMfh8O481sxigc6voD7Q--

