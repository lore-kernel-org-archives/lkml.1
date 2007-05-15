Return-Path: <linux-kernel-owner+w=401wt.eu-S1762055AbXEOHcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762055AbXEOHcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 03:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755318AbXEOHb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 03:31:57 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55524 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494AbXEOHb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 03:31:57 -0400
Date: Tue, 15 May 2007 17:31:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: LKML <linux-kernel@vger.kernel.org>
Subject: __must_check (stir the pot :-))
Message-Id: <20070515173146.505952d1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.0 (GTK+ 2.10.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__15_May_2007_17_31_46_+1000_0irBbUzg=NlS5FyU"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__15_May_2007_17_31_46_+1000_0irBbUzg=NlS5FyU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

So I am looking at "fixing" some of the warning produced by __must_check
but then I see (things like):

drivers/base/core.c: In function 'device_add':
drivers/base/core.c:714: warning: ignoring return value of 'sysfs_create_link', declared with attribute warn_unused_result
drivers/base/core.c:719: warning: ignoring return value of 'sysfs_create_link', declared with attribute warn_unused_result
drivers/base/core.c:722: warning: ignoring return value of 'sysfs_create_link', declared with attribute warn_unused_result
drivers/base/core.c:728: warning: ignoring return value of 'sysfs_create_link', declared with attribute warn_unused_result
drivers/base/core.c: In function 'device_rename':
drivers/base/core.c:1187: warning: ignoring return value of 'sysfs_create_link', declared with attribute warn_unused_result
drivers/base/core.c:1197: warning: ignoring return value of 'sysfs_create_link', declared with attribute warn_unused_result

and things like this in drivers/base/sys.c:

int sysdev_create_file(struct sys_device * s, struct sysdev_attribute * a)
{
        return sysfs_create_file(&s->kobj, &a->attr);
}

where sysfs_create_file() is marked __must_check and sysdev_create_file()
isn't.

So the questions come to mind:  Do we really care if our core
infrastructure doesn't?  Can we care if the core infrastructure doesn't
propogate the error returns?

Flame away, I am prepared to ignore all opinions :-)
--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__15_May_2007_17_31_46_+1000_0irBbUzg=NlS5FyU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGSWHnFdBgD/zoJvwRAhHmAKCbyoQjI5lXj2zyrVvbhNqDiz/5fwCfYhU9
mwtsIYV0gTI+xl8ZhejpWw4=
=BoZs
-----END PGP SIGNATURE-----

--Signature=_Tue__15_May_2007_17_31_46_+1000_0irBbUzg=NlS5FyU--
