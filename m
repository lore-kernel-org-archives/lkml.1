Return-Path: <linux-kernel-owner+w=401wt.eu-S1757380AbXKRBXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380AbXKRBXz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 20:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbXKRBXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 20:23:45 -0500
Received: from simmts6.bellnexxia.net ([206.47.199.164]:62696 "EHLO
	simmts6-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754392AbXKRBXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 20:23:44 -0500
Message-ID: <473F941E.6040809@gmail.com>
Date: Sat, 17 Nov 2007 21:23:42 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andrew Morgan <morgan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, apw@shadowen.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       kamalesh@linux.vnet.ibm.com
Subject: Re: 2.6.24-rc2-mm1 -- strange apparent network failures
References: <20071113175906.497a1a6a.akpm@linux-foundation.org> <20071115164441.67a8e2df.akpm@linux-foundation.org> <473E794A.4060107@kernel.org> <200711170848.35726.kjwinchester@gmail.com> <473F7EDB.60701@kernel.org>
In-Reply-To: <473F7EDB.60701@kernel.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andrew Morgan wrote:
> Kevin,
> 
> Can you try this quick hack?
> 
> diff --git a/kernel/capability.c b/kernel/capability.c
> index e57d1aa..4088610 100644
> --- a/kernel/capability.c
> +++ b/kernel/capability.c
> @@ -109,7 +109,7 @@ out:
>                         kdata[i].permitted = pP.cap[i];
>                         kdata[i].inheritable = pI.cap[i];
>                 }
> -               while (i < _LINUX_CAPABILITY_U32S) {
> +               while (0 && (i < _LINUX_CAPABILITY_U32S)) {
>                         if (pE.cap[i] || pP.cap[i] || pP.cap[i]) {
>                                 /* Cannot represent w/ legacy structure */
>                                 return -ERANGE;
> 


Oh, and the reason your patch turned up incorrect in my mailer and on
lkml seems to be the PGP signature.  I didn't have your public key, so
my mail client just left the full PGP-signed text in, which includes
escaping of '-' characters.  LKML must also ignore the signature.  Once
I added your public key, the patch shows up correctly in my client at least.

(I guess everyone else probably knew this already...but at least I
learned something new today)

- --
Kevin Winchester
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHP5QdKPGFQbiQ3tQRAqimAJwOSGDSM2wXeLbm+sBKehGf/haNpACfX7Cb
IALnPxwlgShR6Xb+XQclBro=
=xFUp
-----END PGP SIGNATURE-----
