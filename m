Return-Path: <linux-kernel-owner+w=401wt.eu-S1752082AbXJUDFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbXJUDFb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 23:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751025AbXJUDFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 23:05:24 -0400
Received: from mail.gmx.net ([213.165.64.20]:45901 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750987AbXJUDFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 23:05:24 -0400
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX19SxPoDRI9SqNeK6XWXIhKvqvY3GgPhzl8bAUMmr6
	L4KiMRpe8juU6i
From: Helge Deller <deller@gmx.de>
To: Andrew Morton <akpm@osdl.org>
Subject: [PATCH 1/2] UUID: set multicast bit in pseudo-random MAC address
Date: Sat, 20 Oct 2007 21:58:40 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu
References: <200710202139.25595.deller@gmx.de>
In-Reply-To: <200710202139.25595.deller@gmx.de>
X-Face: &[jmHH-Dw>Aj):"[/t-VasJu+(5eP`/LEckV7V"JV,!nBy[6(/?#8M>x`5xzg/7:FkM.l@=?utf-8?q?=0A=0913?=<&9'nfV3"OkD~P)@j{P2=(uB7J(){:CcrM2jZeA+IBq?FUTp3c8Y{t+k<95mZf~[v"=?utf-8?q?=27=3A=0A=09t?="f6wKtHUPFB&/]Z5^?9~IQs=16R;Pg"NS9JD=DK!ft&4b@=?utf-8?q?S=7E=26q/MfI3=3BqWqlg7Q1=3D=3DjS4=0A=099V5OJkm=24WQ=5Bdc=5E=5FY?=
 =?utf-8?q?=27=5DDvibvMjizUZ=5D+=27Jd4UnM?=><yrT}Rw(
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710202158.40645.deller@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a bug in the current random UUID generator:

Section 4.1.6 of RFC 4122 states regarding the "NodeID" of a UUID:
:  For systems with no IEEE address, a randomly or pseudo-randomly
:  generated value may be used; see Section 4.5.  The multicast bit must
:  be set in such addresses, in order that they will never conflict with
:  addresses obtained from network cards. 

So up to now it was just pure ("random") luck if this bit was set or not.
This tiny patch sets the bit explicitely.

Signed-off-by: Helge Deller <deller@gmx.de>
CC:  Valdis.Kletnieks@vt.edu

 random.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1157,6 +1158,8 @@ void generate_random_uuid(unsigned char uuid_out[16])
 	uuid_out[6] = (uuid_out[6] & 0x0F) | 0x40;
 	/* Set the UUID variant to DCE */
 	uuid_out[8] = (uuid_out[8] & 0x3F) | 0x80;
+	/* Set multicast bit to avoid conflicts with NIC MAC addresses */
+	uuid_out[10] |= 0x80;
 }
 
 EXPORT_SYMBOL(generate_random_uuid);
