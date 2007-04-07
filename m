Return-Path: <linux-kernel-owner+w=401wt.eu-S966179AbXDGRVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966179AbXDGRVN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 13:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966154AbXDGRVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 13:21:13 -0400
Received: from h80ad275a.async.vt.edu ([128.173.39.90]:50108 "EHLO
	h80ad275a.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966143AbXDGRVL (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 13:21:11 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: johnrobertbanks@fastmail.fm, Jan Harkes <jaharkes@cs.cmu.edu>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Reiser4. BEST FILESYSTEM EVER.
In-Reply-To: Your message of "Sat, 07 Apr 2007 16:11:46 +0200."
             <m34pns46l9.fsf@maximus.localdomain>
From: Valdis.Kletnieks@vt.edu
References: <46157B5B.5000602@gmail.com> <1175817921.18400.1183285196@webmail.messagingengine.com> <461592FB.5060507@zytor.com> <1175819681.20754.1183287946@webmail.messagingengine.com> <461596DE.2020802@zytor.com> <1175823288.25662.1183293506@webmail.messagingengine.com> <4615C780.5040407@zytor.com> <1175833931.8916.1183307802@webmail.messagingengine.com> <20070406152119.GC4228@delft.aura.cs.cmu.edu> <1175914056.9653.1183426876@webmail.messagingengine.com> <20070407033049.GI4228@delft.aura.cs.cmu.edu> <1175925525.21154.1183436614@webmail.messagingengine.com>
            <m34pns46l9.fsf@maximus.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1175966465_4736P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 07 Apr 2007 13:21:05 -0400
Message-ID: <14133.1175966465@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1175966465_4736P
Content-Type: text/plain; charset=us-ascii

On Sat, 07 Apr 2007 16:11:46 +0200, Krzysztof Halasa said:
>
> Gzip - 3 files (zeros only, raw DV data from video camera, x86_64
> kernel rpm file), 10 MB of data (10*1024*1024),
> $ l -Ggh zeros dv bin
> -rw-r--r-- 1 10M Apr  7 15:30 bin
> -rw-r--r-- 1 10M Apr  7 15:31 dv
> -rw-r--r-- 1 10M Apr  7 15:31 zeros

> $ l -Ggh zeros.gz dv.gz bin.gz
> -rw-r--r-- 1  10K Apr  7 15:31 zeros.gz
> -rw-r--r-- 1 9.1M Apr  7 15:31 dv.gz
> -rw-r--r-- 1 9.3M Apr  7 15:30 bin.gz
> 
> ... and though the numbers may still sound impressive, space savings
> are less than 10%.

I am quite sure that the kernel RPM file is *already* compressed, at least
somewhat.  Otherwise, it's hard to explain this:

-rw-r--r--    1 529      263     17835757   Apr  5 00:19   kernel-2.6.20-1.3045.fc7.x86_64.rpm

% du -s /lib/modules/2.6.20-1.3038.fc7/
76436   /lib/modules/2.6.20-1.3038.fc7/

and it can't all be slack space at ends of files:

% find /lib/modules/2.6.20-1.3038.fc7/ -type f | wc -l
1482

Even on a 4K filesystem, the *max* wasted slack would be about 4M.

And what do you know - if you tar.gz that /lib/modules:

% tar czf /tmp/kern.tar.gz /lib/modules/2.6.20-1.3038.fc7/
tar: Removing leading `/' from member names
% ls -l /tmp/kern.tar.gz 
-rw-r--r-- 1 valdis valdis 15506359 2007-04-07 13:19 /tmp/kern.tar.gz

The *compressed* tar is about 15M (remember the .rpm contained a 2M vmlinuz
as well - that;s compressed too).  So we're right up to the 17M of the .rpm,
which indicates that the RPM is compressed at a factor close to tar.gz.

I'd not be surprised to find out that your digital-video also contains
at least some light compression - if it's mpeg or similar, that's already
had some *heavy* compression done to it....

--==_Exmh_1175966465_4736P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGF9MBcC3lWbTT17ARAnKtAJ9XGPthGNaIjLVPapOXX3gCYTYb1gCgzcGa
TyO+vN3sMuy0cWvZ/M39ldw=
=ux2q
-----END PGP SIGNATURE-----

--==_Exmh_1175966465_4736P--
