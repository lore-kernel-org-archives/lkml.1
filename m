Return-Path: <linux-kernel-owner+w=401wt.eu-S1760374AbYB1PGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760374AbYB1PGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 10:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756103AbYB1PGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 10:06:01 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:39817 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156AbYB1PF7 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 10:05:59 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Kohei KaiGai <kaigai@ak.jp.nec.com>
Cc: greg@kroah.com, morgan@kernel.org, serue@us.ibm.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] add a private data field within kobj_attribute structure (final#2)
In-Reply-To: Your message of "Mon, 25 Feb 2008 15:10:27 +0900."
             <47C25BD3.3020205@ak.jp.nec.com>
From: Valdis.Kletnieks@vt.edu
References: <47C25AE9.7080305@ak.jp.nec.com>
            <47C25BD3.3020205@ak.jp.nec.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1204177759_3291P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 28 Feb 2008 00:49:19 -0500
Message-ID: <7086.1204177759@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1204177759_3291P
Content-Type: text/plain; charset=us-ascii

On Mon, 25 Feb 2008 15:10:27 +0900, Kohei KaiGai said:
> [PATCH 1/3] add a private data field within kobj_attribute structure.

> diff --git a/Documentation/kobject.txt b/Documentation/kobject.txt
> index bf3256e..efa5d71 100644
> --- a/Documentation/kobject.txt
> +++ b/Documentation/kobject.txt
> @@ -207,6 +207,12 @@ Both types of attributes used here, with a kobject that has been created
>  with the kobject_create_and_add(), can be of type kobj_attribute, so no
>  special custom attribute is needed to be created.
> 
> +The simple kobj_attribute is prototyped at include/linux/kobject.h, and can
> +contain your own show()/store() method and private data.
> +When an attribute is accessed, these methods are invoked with kobject,
> +kobj_attribute and read/write buffer. The method can refer the private data
> +via given kobj_attribute, to show/store itself in the text representation.
> +
>  See the example module, samples/kobject/kobject-example.c for an
>  implementation of a simple kobject and attributes.

OK, I'm an idiot, so I re-read this several times, and looked at patch 3/3
that added the sample code, and I'm still confoozled.

Who creates/destroys/manages this "read/write buffer", and/or how does the
method know how large a buffer is available, so (for example) it can use the
strn* versions of string functions to be sure not to run off the end?  Does
this buffer have any lifetime rules attached to it?

--==_Exmh_1204177759_3291P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHxktfcC3lWbTT17ARAiA9AKCbGBBzNFhrX6IygH2t2j6AdC0y3wCglc5s
laAEPgCndrtb4Nu70V2i4d4=
=Y6Rt
-----END PGP SIGNATURE-----

--==_Exmh_1204177759_3291P--
