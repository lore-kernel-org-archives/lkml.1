Return-Path: <linux-kernel-owner+w=401wt.eu-S1752249AbXDGPfD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249AbXDGPfD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 11:35:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966027AbXDGPfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 11:35:03 -0400
Received: from dovecot.org ([213.157.71.38]:42630 "EHLO dovecot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbXDGPfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 11:35:00 -0400
X-Greylist: delayed 1138 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Apr 2007 11:35:00 EDT
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Transfer-Encoding: 7bit
Message-Id: <BFF42091-C65E-49FE-826A-91E181354E2F@iki.fi>
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-14-83262571"
To: linux-kernel@vger.kernel.org
From: Timo Sirainen <tss@iki.fi>
Subject: O_APPEND, lseek() and pwrite()
Date: Sat, 7 Apr 2007 18:15:57 +0300
X-Pgp-Agent: GPGMail 1.1.2 (Tiger)
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-14-83262571
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed

If I open a file with O_APPEND and write() to it, it looks like the  
file offset is updated and I can get it with lseek(SEEK_CUR). Can I  
trust that this behavior won't change in future Linux versions?  
Apparently this isn't standard, because at least OS X and Solaris  
don't do this.

pwrite() ignores the file offset if the fd has O_APPEND set (with  
2.6.20). http://www.opengroup.org/austin/mailarchives/ag/ 
msg09453.html suggests that it shouldn't ignore it. Could this be  
changed? For now I can of course just change the flag with fcntl().

I guess there aren't any limits to how large blocks write() accepts  
without the data being mixed with another process's writes (both with  
O_APPEND)? And I guess there aren't any horrible performance problems  
with this, so that this is actually a good idea compared to file lock  
+ write() + unlock? :)


--Apple-Mail-14-83262571
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (Darwin)

iD8DBQFGF7WuyUhSUUBViskRAp5hAJ9pyjaotNFqciVWdcRQzrF5iZb6iACfY6kO
jTxNcxYXXT9u6oHYlZezmIw=
=vJqh
-----END PGP SIGNATURE-----

--Apple-Mail-14-83262571--
