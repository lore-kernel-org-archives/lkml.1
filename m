Return-Path: <linux-kernel-owner+w=401wt.eu-S1756807AbZKRBak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbZKRBak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 20:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756604AbZKRBai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 20:30:38 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:37793 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586AbZKRBag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 20:30:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=bBxj92Tnl7+jBAHc1uaOTNHIA6gELpwJ0V64SCRDcTdRglMIbPLiy7MAyCmNlyizhV
         UfeQUT2Z3KVNhqMg/48tVTVi/WAe1K8UcBADEVrv/StAz+Hg/4tvDNAyxOi0oCl4kEk8
         ek5RRFwDiB1V9ptBPuzBFQLSf+gflugykAn6Y=
MIME-Version: 1.0
Date: Wed, 18 Nov 2009 12:30:42 +1100
Message-ID: <d45a3acc0911171730kc3a03d5iacec6d9ef4b1874c@mail.gmail.com>
Subject: [PATCH] Documentation, clarify tuntap IPX example.
From: andrew hendry <andrew.hendry@gmail.com>
To: maxk@qualcomm.com, netdev@vger.kernel.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can the TUNSETIFF ioctl change a tap's protocol to IPX as the
documentation suggests?
I think tun.c would need IFF_IPX_TAP added for it to work as described?
Otherwise tap can only be ptp or ethernet, and there is no way to
route or use AF_IPX.

Signed-off-by: Andrew Hendry <andrew.hendry@gmail.com>

--- a/Documentation/networking/tuntap.txt       2009-11-11
14:03:22.676167648 +1100
+++ b/Documentation/networking/tuntap.txt       2009-11-18
11:34:18.106647029 +1100
@@ -127,12 +127,14 @@ Ethernet device, which instead of receiv
 media, receives them from user space program and instead of sending
 packets via physical media sends them to the user space program.

-Let's say that you configured IPX on the tap0, then whenever
-the kernel sends an IPX packet to tap0, it is passed to the application
-(VTun for example). The application encrypts, compresses and sends it to
-the other side over TCP or UDP. The application on the other side decompresses
-and decrypts the data received and writes the packet to the TAP device,
-the kernel handles the packet like it came from real physical device.
+Let's say for the purpose of example, IPX support was added to tuntap.
+Then whenever the kernel routes an IPX packet to tap0, it is passed to the
+application reading the file descriptor from /dev/net/tun (VTun for example).
+The application encrypts, compresses and sends it to the other side over TCP
+or UDP. The application on the other side decompresses and decrypts the data
+received and writes the packet to the TAP device, the remote kernel handles
+the packet like it came from real physical device. The IPX applications are
+able to communicate as if there was a real IPX network.

 4. What is the difference between TUN driver and TAP driver?
 TUN works with IP frames. TAP works with Ethernet frames.
