Return-Path: <linux-kernel-owner+w=401wt.eu-S1758125AbZKDUCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125AbZKDUCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 15:02:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758075AbZKDUCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 15:02:49 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:56376 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758033AbZKDUCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 15:02:48 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Martin Nybo Andersen <tweek@tweek.dk>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Ryan C. Gordon" <icculus@icculus.org>,
       =?iso-8859-1?q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org
Subject: Re: package managers [was: FatELF patches...]
In-Reply-To: Your message of "Wed, 04 Nov 2009 19:46:44 +0100."
             <Pine.LNX.4.64.0911041901090.26209@artax.karlin.mff.cuni.cz>
From: Valdis.Kletnieks@vt.edu
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan> <20091104165407.1481bc29@lxorguk.ukuu.org.uk> <Pine.LNX.4.64.0911041758420.9986@artax.karlin.mff.cuni.cz> <200911041848.48721.tweek@tweek.dk>
            <Pine.LNX.4.64.0911041901090.26209@artax.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1257364949_3622P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 04 Nov 2009 15:02:29 -0500
Message-ID: <22108.1257364949@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.14.107 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020207.4AF1DDD7.002F,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-07-29 21:33:33,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1257364949_3622P
Content-Type: text/plain; charset=us-ascii

On Wed, 04 Nov 2009 19:46:44 +0100, Mikulas Patocka said:

> When I did it (from Etch to Lenny), two programs that I have compiled 
> manually ("vim" and "links") stopped working because Etch and Lenny have 
> binary-incompatible libgpm.
> 
> If some library cannot keep binary compatibility, it should be linked 
> staticaly, dynamic version shouldn't even exists on the system --- so that 
> no one can create incompatible binaries.

No, all they need to do is bump the .so version number.

I have a creeping-horror binary that was linked against an older audit shared
library. Fedora shipped a newer one.  The fix?  Upgraded the lib, then
snarfed the old version off backups (you *do* make backups, right?)

% ls -l /lib64/libaudit*
lrwxrwxrwx 1 root root     17 2009-09-26 16:47 /lib64/libaudit.so.0 -> libaudit.so.0.0.0
-rwxr-xr-x 1 root root 107304 2009-04-03 15:47 /lib64/libaudit.so.0.0.0
lrwxrwxrwx 1 root root     17 2009-09-30 11:09 /lib64/libaudit.so.1 -> libaudit.so.1.0.0
-rwxr-xr-x 1 root root 103208 2009-09-28 16:00 /lib64/libaudit.so.1.0.0

They happily co-exist. My creeping horror references libaudit.so.0, the rest
of the system references libaudit.so.1 and everybody is happy.

And some distros even pre-package the previous set of libraries for some packages:

% yum list 'compat*'
Loaded plugins: dellsysidplugin2, downloadonly, refresh-packagekit, refresh-updatesd
Installed Packages
compat-expat1.x86_64                                          1.95.8-6                                    @rawhide
compat-readline5.i686                                         5.2-17.fc12                                 @rawhide
compat-readline5.x86_64                                       5.2-17.fc12                                 @rawhide
Available Packages
compat-db.x86_64                                              4.6.21-5.fc10                               rawhide 
compat-db45.x86_64                                            4.5.20-5.fc10                               rawhide 
compat-db46.x86_64                                            4.6.21-5.fc10                               rawhide 
compat-erlang.x86_64                                          R10B-15.12.fc12                             rawhide 
compat-expat1.i686                                            1.95.8-6                                    rawhide 
compat-flex.x86_64                                            2.5.4a-6.fc12                               rawhide 
compat-gcc-34.x86_64                                          3.4.6-18                                    rawhide 
compat-gcc-34-c++.x86_64                                      3.4.6-18                                    rawhide 
compat-gcc-34-g77.x86_64                                      3.4.6-18                                    rawhide 
compat-guichan05.i686                                         0.5.0-10.fc12                               rawhide 
compat-guichan05.x86_64                                       0.5.0-10.fc12                               rawhide 
compat-guichan05-devel.i686                                   0.5.0-10.fc12                               rawhide 
compat-guichan05-devel.x86_64                                 0.5.0-10.fc12                               rawhide 
compat-libf2c-34.i686                                         3.4.6-18                                    rawhide 
compat-libf2c-34.x86_64                                       3.4.6-18                                    rawhide 
compat-libgda.i686                                            3.1.2-3.fc12                                rawhide 
compat-libgda.x86_64                                          3.1.2-3.fc12                                rawhide 
compat-libgda-devel.i686                                      3.1.2-3.fc12                                rawhide 
compat-libgda-devel.x86_64                                    3.1.2-3.fc12                                rawhide 
compat-libgda-sqlite.x86_64                                   3.1.2-3.fc12                                rawhide 
compat-libgda-sqlite-devel.i686                               3.1.2-3.fc12                                rawhide 
compat-libgda-sqlite-devel.x86_64                             3.1.2-3.fc12                                rawhide 
compat-libgdamm.i686                                          3.0.1-4.fc12                                rawhide 
compat-libgdamm.x86_64                                        3.0.1-4.fc12                                rawhide 
compat-libgdamm-devel.i686                                    3.0.1-4.fc12                                rawhide 
compat-libgdamm-devel.x86_64                                  3.0.1-4.fc12                                rawhide 
compat-libgfortran-41.i686                                    4.1.2-38                                    rawhide 
compat-libgfortran-41.x86_64                                  4.1.2-38                                    rawhide 
compat-libstdc++-296.i686                                     2.96-143                                    rawhide 
compat-libstdc++-33.i686                                      3.2.3-68                                    rawhide 
compat-libstdc++-33.x86_64                                    3.2.3-68                                    rawhide 
compat-readline5-devel.i686                                   5.2-17.fc12                                 rawhide 
compat-readline5-devel.x86_64                                 5.2-17.fc12                                 rawhide 
compat-readline5-static.x86_64                                5.2-17.fc12                                 rawhide 

--==_Exmh_1257364949_3622P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFK8d3VcC3lWbTT17ARAurXAJ4kcicg25Xs+h+dJoLMFQ51UkiHLwCfZIDm
BTJebQA236R8YpN2gthAcDw=
=C8YH
-----END PGP SIGNATURE-----

--==_Exmh_1257364949_3622P--

