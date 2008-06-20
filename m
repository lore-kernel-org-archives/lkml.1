Return-Path: <linux-kernel-owner+w=401wt.eu-S1753334AbYFTIEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbYFTIEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 04:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbYFTIEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 04:04:16 -0400
Received: from mx28.mail.ru ([194.67.23.67]:20893 "EHLO mx28.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbYFTIEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 04:04:13 -0400
From: Andrew Savchenko <Bircoph@list.ru>
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] ipg: add jumbo frame support kconfig option
Date: Fri, 20 Jun 2008 10:37:36 +0400
User-Agent: KMail/1.9.1
Cc: penberg@cs.helsinki.fi
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2143283.X7csQDvRL5";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200806201037.46687.Bircoph@list.ru>
X-Spam: Not detected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2143283.X7csQDvRL5
Content-Type: multipart/mixed;
  boundary="Boundary-01=_wA1WIXV8S6TvsNX"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_wA1WIXV8S6TvsNX
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,

On Wed, 27 Feb 2008 09:44:44 +0200 (EET), Pekka J Enberg wrote:
> Stephen Hemminger wrote:
> > > Please don't do this as a config option. Config options seem
> > > like a good idea to developers but are difficult for
> > > distributions.  Either support jumbo frames by default or
> > > not at all.
>
> On Tue, 26 Feb 2008, Jeff Garzik wrote:
> > Agreed, but to be more specific... always compile in jumbo
> > frame support. You don't have to enable it at runtime by
> > default, though.
>
> Ok, so a sysfs attribute would be sufficient, I suppose? I don't
> have the hardware though, so I don't even know if the jumbo
> frame code actually works at this point hence the RFC. So I'll
> wait for someone to test this before sending a new patch. Thanks
> for the review!

I own such card:
02:02.0 Ethernet controller: Sundance Technology Inc / IC Plus Corp=20
IP1000 Family Gigabit Ethernet (rev 41)
and I use patch similar to yours in order to enable Jumbo Frames.=20
See attachment for details, patch is done for linux-2.6.25.6.

It works fine for me. However, I enabled 10K jumbo boxes instead of=20
default 4K value, activated using your patch. Reason is simple: I=20
need at least 9000-byte jumbo boxes in my network.

However, I have one request for you: please, make in possible to=20
choose max MTU via kernel config option. In different environments=20
different people may need different max MTU sizes (2K...10K).=20
Recommended value is 4K (as described in the original driver from=20
manufacturer, which was remake into kernel's one), but, for=20
example, I'm interested in larger MTU values. OTOH larger MTU=20
values require more memory and so on. For me, as for end user of=20
Linux kernel, a possibility to select desired max MTU is very=20
attractive and is definitely in no doubt more convenient than=20
patching the kernel myself each time.

So, feel free to add jumbo boxes on ipg support to the mainstream=20
and, please, make in possible to select max MTU; 4K as default=20
will be fine.

Sincerely yours,
Andrew

--Boundary-01=_wA1WIXV8S6TvsNX
Content-Type: text/plain;
  charset="us-ascii";
  name="ipg-jumbo.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="ipg-jumbo.patch"

=2D-- drivers/net/ipg.c.orig	2008-04-17 06:49:44.000000000 +0400
+++ drivers/net/ipg.c	2008-06-18 04:46:06.000000000 +0400
@@ -42,7 +42,8 @@
 #define ipg_r16(reg)		ioread16(ioaddr + (reg))
 #define ipg_r8(reg)		ioread8(ioaddr + (reg))
=20
=2D#define JUMBO_FRAME_4k_ONLY
+#define JUMBO_FRAME
+#define JUMBO_FRAME_SIZE_10K
 enum {
 	netdev_io_size =3D 128
 };
@@ -1267,7 +1268,7 @@
 			return;
=20
 		if (jumbo->found_start) {
=2D			int framelen, endframelen;
+			int framelen, endframeLen;
=20
 			framelen =3D le64_to_cpu(rxfd->rfs) & IPG_RFS_RXFRAMELEN;
=20
@@ -1352,16 +1353,16 @@
=20
 		switch (ipg_nic_rx_check_frame_type(dev)) {
 		case FRAME_WITH_START_WITH_END:
=2D			ipg_nic_rx_with_start_and_end(dev, tp, rxfd, entry);
+			ipg_nic_rx_with_start_and_end(dev, sp, rxfd, entry);
 			break;
 		case FRAME_WITH_START:
=2D			ipg_nic_rx_with_start(dev, tp, rxfd, entry);
+			ipg_nic_rx_with_start(dev, sp, rxfd, entry);
 			break;
 		case FRAME_WITH_END:
=2D			ipg_nic_rx_with_end(dev, tp, rxfd, entry);
+			ipg_nic_rx_with_end(dev, sp, rxfd, entry);
 			break;
 		case FRAME_NO_START_NO_END:
=2D			ipg_nic_rx_no_start_no_end(dev, tp, rxfd, entry);
+			ipg_nic_rx_no_start_no_end(dev, sp, rxfd, entry);
 			break;
 		}
 	}

--Boundary-01=_wA1WIXV8S6TvsNX--

--nextPart2143283.X7csQDvRL5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBIW1AwAvwbVeyQBdURAmbQAKCE1Kp/PEjXcZ8DDWh8iHXqFBad5ACfXwvj
9/atcVro7Vw4eqGwdHvaAdk=
=JONN
-----END PGP SIGNATURE-----

--nextPart2143283.X7csQDvRL5--
