Return-Path: <linux-kernel-owner+w=401wt.eu-S1757983AbYHON1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983AbYHON1W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 09:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753452AbYHON1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 09:27:09 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:52604 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbYHON1J (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 09:27:09 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Marcin Obara <marcin_obara@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Marcel Selhorst <tpm@selhorst.net>,
       Kylene Jo Hall <kjhall@us.ibm.com>, tpmdd-devel@lists.sourceforge.net
Subject: Re: [PATCH] 2.6.26-mmotm tpm-correct-tpm-timeouts-to-jiffies-conversion-d820-fix.patch
In-Reply-To: Your message of "Sat, 26 Jul 2008 20:27:33 BST."
             <ea8d860a0807261227w66e29978uecd12cf1fcb915d1@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <20080725164614.044a526e.akpm@linux-foundation.org> <50684.1217035060@turing-police.cc.vt.edu> <20080725185115.5d1a107d.akpm@linux-foundation.org> <15114.1217045033@turing-police.cc.vt.edu>
            <ea8d860a0807261227w66e29978uecd12cf1fcb915d1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1218793144_6209P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 15 Aug 2008 05:39:05 -0400
Message-ID: <8700.1218793145@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1218793144_6209P
Content-Type: text/plain; charset=us-ascii

On Sat, 26 Jul 2008 20:27:33 BST, Marcin Obara said:

> Value in  chip->vendor.duration[TPM_SHORT]  is in jiffies not in  milliseconds.
>  (As I know it's not the same. Jiffy is in range 1-10 ms.)
> I know the result may be the same, but it is unclear.

I suppose I could have worded the comment block better - the intent was to
point out what the Broadcom chip returns, but by that point in the code
we're dealing with jiffies...

> Maybe... value should be compared (to 1000) before conversion?

Actually, that's probably a better idea, because my kernel is built with
HZ=1000 - usecs_to_jiffies will do something different than ==1 for HZ=100
or HZ=250 or other odd values.

> If after conversion, there should be something like this:
>        if (chip->vendor.duration[TPM_SHORT]  < (HZ/100))  /*  less
> than 10ms ? */
>                chip->vendor.duration[TPM_SHORT] = HZ;

That's another option as well, that does the right thing for various HZ values.

> What do you think?

Let me go cook up and test another iteration of the patch, will probably be
a few hours...


--==_Exmh_1218793144_6209P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIpU64cC3lWbTT17ARApXFAKCINS73EsZqct+b0T2BdMPxaM5tngCggvhu
N099ZDxwjzndDWiwrlsDrm4=
=A/Wn
-----END PGP SIGNATURE-----

--==_Exmh_1218793144_6209P--
