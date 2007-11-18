Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbXKRAuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbXKRAuc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 19:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbXKRAuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 19:50:22 -0500
Received: from simmts5-qfe0.srvr.bell.ca ([206.47.199.163]:47050 "EHLO
	simmts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752278AbXKRAuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 19:50:22 -0500
Message-ID: <473F8C46.4070308@gmail.com>
Date: Sat, 17 Nov 2007 20:50:14 -0400
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

Well, something went wrong with the patch - it has extra negative signs
in my mail reader, and on lkml, but now that I've hit reply and it's
been quoted, it looks fine in my mail client.  So I have no idea what
went on.

However, I got around the problem by making the code change manually -
and my network connection is now working.  Looking at the code being
bypassed:

    if (pE.cap[i] || pP.cap[i] || pP.cap[i])

looks somewhat weird as it is testing the same condition twice.  Should
it have been:

    if (pE.cap[i] || pP.cap[i] || pI.cap[i])

?

I'm about to test that change instead of bypassing the loop, so I'll let
you know the results.

- --
Kevin Winchester


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHP4xGKPGFQbiQ3tQRAooWAJ9c6exhOiD4VUZ04hS9z77/RmERUACfauTE
BV/JAexzlm2zSmG4laYi+HQ=
=IPkA
-----END PGP SIGNATURE-----
