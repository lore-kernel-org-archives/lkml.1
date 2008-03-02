Return-Path: <linux-kernel-owner+w=401wt.eu-S1755002AbYCBPRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbYCBPRe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 10:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbYCBPR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 10:17:26 -0500
Received: from www.courier-mta.com ([216.254.115.190]:48420 "EHLO
	www.courier-mta.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbYCBPRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 10:17:25 -0500
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Mar 2008 10:17:25 EST
X-IMAP-Sender: mrsam@courier-mta.com
References: <MDEHLPKNGKAHNMBLJOLKAEHCHNAC.davids@webmaster.com> <Pine.LNX.4.64.0710291147180.3387@alien.or.mcafeemobile.com> <47C42CA7.4030607@gmail.com> <Pine.LNX.4.64.0802261049040.27243@alien.or.mcafeemobile.com> <1204075804.5238.7.camel@linux.heathens.co.nz> <Pine.LNX.4.64.0802271131180.377@alien.or.mcafeemobile.com> <cfd18e0f0802280512q43a457d0sc9a8dc83c51e8e1c@mail.gmail.com> <Pine.LNX.4.64.0802281106050.7660@alien.or.mcafeemobile.com> <cfd18e0f0802290746p3cb7efc9j72394cd77ff37829@mail.gmail.com> <Pine.LNX.4.64.0802291111320.31028@alien.or.mcafeemobile.com> <cfd18e0f0802291154j612b4238i66cb8323b72814ca@mail.gmail.com>
Message-ID: <cone.1204470717.369031.30230.500@commodore.email-scan.com>
X-Mailer: http://www.courier-mta.org/cone/
From: Sam Varshavchik <mrsam@courier-mta.com>
To: linux-man@vger.kernel.org
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Chris =?UTF-8?B?wqXCrw==?= Heath <chris@heathens.co.nz>,
       David Schwartz <davids@webmaster.com>, dada1@cosmosbay.com,
       =?UTF-8?B?TGludXgtS2VybmVsQFZnZXIuIEtlcm5lbC4=?= Org 
	<linux-kernel@vger.kernel.org>
X-PGP-KEY: http://www.courier-mta.org/KEYS.bin
Subject: Re: epoll design problems with common fork/exec patterns
Date: Sun, 02 Mar 2008 10:11:57 -0500
Mime-Version: 1.0
Content-Type: multipart/signed;
    boundary="=_mimegpg-commodore.email-scan.com-30230-1204470717-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-commodore.email-scan.com-30230-1204470717-0001
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Hijacking this epoll thread, the following related question occurs to me:

#Q8
#    Does an operation on a file descriptor affect the already collected but 
#not yet reported events?
#
#A8
#    You can do two operations on an existing file descriptor. Remove would 
#be meaningless for this case. Modify will re-read available I/O.

Why is EPOLL_CTL_DEL considered meaningless? A process is wrapping up its 
business and is preparing to remove the fd from the epoll set, and then 
close the file descriptor itself. In the meantime, the fd became readable, 
and a POLLIN event gets collected. So, what happens to the collected event, 
when the EPOLL_CTL_DEL operation is made?


--=_mimegpg-commodore.email-scan.com-30230-1204470717-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHysO9x9p3GYHlUOIRAqEQAJ9QcE4nl6OQ3ZxOXDdM7Mr9ZpXBWQCfSZwp
bxUJC9q3agGsE9Kd4EkV/w8=
=JtXf
-----END PGP SIGNATURE-----

--=_mimegpg-commodore.email-scan.com-30230-1204470717-0001--
