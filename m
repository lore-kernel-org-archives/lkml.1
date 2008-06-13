Return-Path: <linux-kernel-owner+w=401wt.eu-S1756547AbYFMPEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbYFMPEp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 11:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756188AbYFMPEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 11:04:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:18303 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbYFMPEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 11:04:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type;
        b=ke+kTLUxI7J440xK666KEPFRY90EYZBpgUwcG0yDuL4P0/yIrLxBPrQUKKuLAlGWKN
         CVA1D6AHhLT9CGia7qASOpQpo4YtkrZfT+fyMR1P1Z9blFLjtxHf+U9ntRBoZNBlwGHm
         3O9fQ8Asv4I4m3GLTgW8cRJ7T1XWVuFXvw6aw=
Message-ID: <c49e66200806130804u280fdfa1gd1027f3401ae7f4f@mail.gmail.com>
Date: Fri, 13 Jun 2008 17:04:34 +0200
From: "Pieter Steyn" <pieterste@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] eth_v10.c phy fix
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_30697_12525289.1213369474725"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_30697_12525289.1213369474725
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi guys,

This patch allows you to set phy address parameters through ethtool, like:

/bin/ethtool -s eth0 phyad 8

--- drivers/net/cris/eth_v10.c  2008-06-12 14:12:33.000000000 +0200
+++ drivers/net/cris/eth_v10.c  2008-06-12 14:19:35.000000000 +0200
@@ -1430,7 +1430,11 @@
                e100_set_duplex(dev, ecmd->duplex == DUPLEX_HALF ? half : full);
                e100_set_speed(dev, ecmd->speed == SPEED_10 ? 10: 100);
        }
-
+        //Honor ethtool phy address parameter, which was simply
discarded before this.
+        if (ecmd->phy_address <= 31)
+                mdio_phy_addr = ecmd->phy_address;
+        else if (ecmd->phy_address == 32)
+                return -ENODEV;
        return 0;
 }

I've searched the MAINTAINERS file and haven't seen anything regarding
either the source file name or cris.  Please consider applying my
patch to main kernel...

Thanks,
Pieter Steyn

------=_Part_30697_12525289.1213369474725
Content-Type: application/octet-stream; name=eth_v10.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fhewoglo
Content-Disposition: attachment; filename=eth_v10.patch

LS0tIGRyaXZlcnMvbmV0L2NyaXMvZXRoX3YxMC5jCTIwMDgtMDYtMTIgMTQ6MTI6MzMuMDAwMDAw
MDAwICswMjAwCisrKyBkcml2ZXJzL25ldC9jcmlzL2V0aF92MTAuYwkyMDA4LTA2LTEyIDE0OjE5
OjM1LjAwMDAwMDAwMCArMDIwMApAQCAtMTQzMCw3ICsxNDMwLDExIEBACiAJCWUxMDBfc2V0X2R1
cGxleChkZXYsIGVjbWQtPmR1cGxleCA9PSBEVVBMRVhfSEFMRiA/IGhhbGYgOiBmdWxsKTsKIAkJ
ZTEwMF9zZXRfc3BlZWQoZGV2LCBlY21kLT5zcGVlZCA9PSBTUEVFRF8xMCA/IDEwOiAxMDApOwog
CX0KLQorICAgICAgICAvL0hvbm9yIGV0aHRvb2wgcGh5IGFkZHJlc3MgcGFyYW1ldGVyLCB3aGlj
aCB3YXMgc2ltcGx5IHVudXNlZCBiZWZvcmUgdGhpcy4KKyAgICAgICAgaWYgKGVjbWQtPnBoeV9h
ZGRyZXNzIDw9IDMxKQorICAgICAgICAgICAgICAgIG1kaW9fcGh5X2FkZHIgPSBlY21kLT5waHlf
YWRkcmVzczsKKyAgICAgICAgZWxzZSBpZiAoZWNtZC0+cGh5X2FkZHJlc3MgPT0gMzIpCisgICAg
ICAgICAgICAgICAgcmV0dXJuIC1FTk9ERVY7CiAJcmV0dXJuIDA7CiB9CiAK
------=_Part_30697_12525289.1213369474725--
