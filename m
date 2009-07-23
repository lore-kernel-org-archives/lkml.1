Return-Path: <linux-kernel-owner+w=401wt.eu-S1753816AbZGWVXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbZGWVXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 17:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbZGWVXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 17:23:43 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:37086 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbZGWVXn (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 17:23:43 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Ludwig Nussel <ludwig.nussel@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] implement uid mount option for ext2 and ext3
In-Reply-To: Your message of "Thu, 23 Jul 2009 13:36:29 +0200."
             <1248348991-849-1-git-send-email-ludwig.nussel@suse.de>
From: Valdis.Kletnieks@vt.edu
References: <1248348991-849-1-git-send-email-ludwig.nussel@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1248384221_2742P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 23 Jul 2009 17:23:41 -0400
Message-ID: <10655.1248384221@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1248384221_2742P
Content-Type: text/plain; charset=us-ascii

On Thu, 23 Jul 2009 13:36:29 +0200, Ludwig Nussel said:

> The following two patches (for 2.6.31-rc4) therefore implement the
> uid mount option for ext2 and ext3 to make them actually useful on
> removable media. My implementation just writes uid 0 to disk for
> files that are owned by the specified user.

I'm certain this will end up violating the Principle of Least Surprise.

For instance - you have UID 500 on 2 systems.  Mount on old system, create a
file - it's owned by 500.  Take it to a new system, mount it, watch it get
smashed to 0 because it's owned by "you".  Take it back to the old system, and
hey, you can't edit your file because it's not owned by 500 anymore...

Hint:  This *same exact* problem has been an issue for NFS for at least 25
years. Might want to think about (a) why Yellow Pages (and later LDAP) was
developed, and (b) why NFS "root squash" traditionally maps to "nobody" rather
than a usable UID.


--==_Exmh_1248384221_2742P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKaNTdcC3lWbTT17ARAsiUAKCrFn3nQjsBNK+bao1UsUIRsXY9oQCdF1S+
nR48YowsbU+w9jK1HLwWItA=
=ZMX5
-----END PGP SIGNATURE-----

--==_Exmh_1248384221_2742P--
