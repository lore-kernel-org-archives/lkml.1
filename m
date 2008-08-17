Return-Path: <linux-kernel-owner+w=401wt.eu-S1753095AbYHQGmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbYHQGmV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 02:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbYHQGmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 02:42:13 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:33315 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbYHQGmN (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 02:42:13 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Satish Eerpini <eerpini@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: patching kdb to Centos kernel : error
In-Reply-To: Your message of "Sun, 17 Aug 2008 11:30:41 +0530."
             <93655eb70808162300i4286eac9p9aa34cf23359ff72@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <93655eb70808162300i4286eac9p9aa34cf23359ff72@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1218955331_14862P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 17 Aug 2008 02:42:11 -0400
Message-ID: <23408.1218955331@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1218955331_14862P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <23394.1218955319.1@turing-police.cc.vt.edu>

On Sun, 17 Aug 2008 11:30:41 +0530, Satish Eerpini said:
> hi everyone , i was trying to patch kdb with CentOS 5.0 kernel
> (2.6.18-8) 

You might want to make sure you're using a 2.6.18-vintage kdb patch, as
trying to fit a 2.6.26 kdb onto a 2.6.18 kernel is unlikely to bring joy.

> resolve) ,.... but apart from the rejects during the kernel
> compilation i got the following error which does not seem to have
> anything to do with the rejects ............

No, the rejects during the patch are almost certainly related to your
compile errors...

>  the code(in kdb/modules/kdbm_pg.c) which is causing the second error
> is something like this :
> 
>              iaddr += offsetof(struct inode, u);
> 
> what i am not able to understand is that if 'u' is not a correct
> member of the inode , .. then what did they( whoever wrote this piece
> code) intend by 'u' ? , .....

Your kdb patch probably includes a patch to include/linux/fs.h that adds a
member 'u' to a 'struct inode'.  If this generated a reject, then the member 'u'
won't be in the struct, and your compile dies...

> and for the first error , ... i just checked out the code ....
> according to the line no shown in the error .....the code is :
> 
>              kdb_page_flags(page, Checked);
> 
> and i don't see any function PageChecked ....! so what can the error
> actually mean ??

kdb_page_flags is probably a macro that does something like:

#define kdb_page_flags(a,b) (..... Page##b)

The 'implicit declaration' is most likely a missing #include someplace,
which again hints at the rejects from a misapplied patch...

--==_Exmh_1218955331_14862P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIp8hDcC3lWbTT17ARAhN7AKC8tXzZOv/Xvkd8zkt4UQDp7orkVACgjkem
UHLdUL/7I0oW3R2Stp3aNuE=
=YAks
-----END PGP SIGNATURE-----

--==_Exmh_1218955331_14862P--
