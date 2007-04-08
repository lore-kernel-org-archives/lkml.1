Return-Path: <linux-kernel-owner+w=401wt.eu-S1751306AbXDHPHC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306AbXDHPHC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 11:07:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbXDHPHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 11:07:01 -0400
Received: from h80ad276f.async.vt.edu ([128.173.39.111]:55331 "EHLO
	h80ad276f.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbXDHPHA (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 11:07:00 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: root <swordfish@onetbd.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Scheduler: Improving the scheduler performance.
In-Reply-To: Your message of "Sat, 07 Apr 2007 23:42:20 +0600."
             <1175967725.5798.13.camel@localhost>
From: Valdis.Kletnieks@vt.edu
References: <1175967725.5798.13.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1176044803_6542P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 08 Apr 2007 11:06:43 -0400
Message-ID: <8762.1176044803@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1176044803_6542P
Content-Type: text/plain; charset=us-ascii

On Sat, 07 Apr 2007 23:42:20 +0600, root said:

> As we know that, linux scheduler use separate runqueue for every CPU of
> a multiprocessor system, which having an active and an expired array.If
> we use only one expired array, then the CPUs of a multiprocessor system
> will be able to share their expired task via the accumulated expired
> array,

I got this far, and the first thought that popped into my head was:

"Wow.  This might actually win on a UP or small MP (2-15 CPU).  But the
lock contention on a big 512-CPU machoflops box is likely going to *suck*".

For that matter, my quick eyeballing of the code, although it doesn't *find*
any race conditions, doesn't convince me there's any protection taken to make
sure there aren't any.  Is there some subtle algorithmic trick I'm missing
to ensure Nothing Bad Can Happen?

--==_Exmh_1176044803_6542P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGGQUDcC3lWbTT17ARAlblAJ4v8orJnvnTkgWFGK5GaBCi0liKzACg/fkn
46yITe3dQgotnBtC9zpz+tw=
=GQ/e
-----END PGP SIGNATURE-----

--==_Exmh_1176044803_6542P--
