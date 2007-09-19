Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbXISCsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbXISCsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 22:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbXISCsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 22:48:01 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:58053 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbXISCsA (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 22:48:00 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: tapio.laxstrom@iptime.fi, linux-kernel@vger.kernel.org
Subject: Re: drivers/usb/misc/emi*.c have the biggest data objects in the whole tree
In-Reply-To: Your message of "Fri, 14 Sep 2007 11:35:34 BST."
             <200709141135.35239.vda.linux@googlemail.com>
From: Valdis.Kletnieks@vt.edu
References: <200709141135.35239.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1190170078_4811P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 18 Sep 2007 22:47:58 -0400
Message-ID: <27040.1190170078@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1190170078_4811P
Content-Type: text/plain; charset=us-ascii

On Fri, 14 Sep 2007 11:35:34 BST, Denys Vlasenko said:
> Hi Tapio,
> 
> You are the author of these files. Are you still maintaining them?
> If not, do you know who is the current maintainer?

> These two object files hold the biggest data objects in the whole Linux kernel
> after lockdep:
> 
>    text    data     bss     dec     hex filename
>    1258  160516       0  161774   277ee ./drivers/usb/misc/emi26.o
>    1504  209296       0  210800   33770 ./drivers/usb/misc/emi62.o
> 
> Basically, these are big arrays of the following structures:
> 
> typedef struct _INTEL_HEX_RECORD
> {
>         __u32   length;
>         __u32   address;
>         __u32   type;
>         __u8    data[MAX_INTEL_HEX_RECORD_LENGTH];
> } INTEL_HEX_RECORD;
> 
> I suggest the following optimizations:
> 
> Change structure to

I suggest moving those out of the kernel entirely and use the firmware loader
support to bring it in from userspace like all the *other* firmware blobs.

'INTEL_HEX_RECORD' just *screams* 'microcode' ;)

--==_Exmh_1190170078_4811P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG8I3ecC3lWbTT17ARApegAJ0RJsWV98SzvKxr1ispYvvAZ3DldQCgyaOQ
dSUqQe0fUWb82Fvb+bawJAA=
=vJ6i
-----END PGP SIGNATURE-----

--==_Exmh_1190170078_4811P--
