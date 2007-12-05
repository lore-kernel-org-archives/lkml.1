Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbXLELno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbXLELno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 06:43:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbXLELnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 06:43:37 -0500
Received: from web53712.mail.re2.yahoo.com ([206.190.39.61]:36648 "HELO
	web53712.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751502AbXLELng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 06:43:36 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Dec 2007 06:43:36 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=GebNUsnahqBXM0fNrIZ8DKivLG8jw2yvR/GOqZQXRN+jrLLQRcqRJ1YqoVeUdoGKPM012HETIaYyQ/fMyd9yJ39uyazR3Pby9Egzsc/tSr3TWU3C5P/IGdMkPhDW30PdNwYtzXBJlJhJg+QBRLGVUTN8Jw+IaQv0DI02qi6ctUI=;
X-YMail-OSG: 8x94WocVM1m_L1Qkux92.VuLF_f7XYKZ6r7p4YPDal0NpR5hCIN7ZKSuvcBLdJFIU5Jk4AalbJUPZZsrawFjd.HgPAkv2_HxPfYZPERePWxmX2LD6yMvKhPLe3qO.Jhk64Nbc75o9AJNQaA9otR4HpUzaw--
Date: Wed, 5 Dec 2007 03:36:54 -0800 (PST)
From: Gabriele Gorla <gorlik@yahoo.com>
Subject: Patch submission question [not in the FAQ]
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <602863.12913.qm@web53712.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I have submitted a patch for the 3x-xxxx driver on
alpha several months ago to both the driver maintainer
and the linux-scsi mailing list.
I have read all the FAQ and I tried to stick to the
instructions to the letter.
However the patch has been completely ignored. No
reply, no comment, no flames, absolutely nothing...

the original email submission is at the end of the
email.

could anyone please explain what I am doing wrong?

thanks,
GG


[PATCH 2.6.22] 3w-xxxx: Fix bad unaligned accesses on
alpha SMP

disable packing of the TAG_TW_Device_Extension
structure to prevent kernel unaligned accesses when
accessing ioctl_wqueue.
Fixes smartmontools kernel panic on alpha SMP

Signed-off-by: Gabriele Gorla <gorlik@yahoo.com>
---


--- linux-2.6.22/drivers/scsi/3w-xxxx.h.orig
2007-09-01 17:49:22.000000000 -0700
+++ linux-2.6.22/drivers/scsi/3w-xxxx.h 2007-09-01
17:49:45.000000000 -0700
@@ -392,6 +392,8 @@ typedef struct TAG_TW_Passthru
        unsigned char padding[12];
 } TW_Passthru;
 
+#pragma pack()
+
 typedef struct TAG_TW_Device_Extension {
        u32                     base_addr;
        unsigned long
*alignment_virtual_address[TW_Q_LENGTH];
@@ -430,6 +432,4 @@ typedef struct
TAG_TW_Device_Extension {
        wait_queue_head_t       ioctl_wqueue;
 } TW_Device_Extension;
 
-#pragma pack()
-
 #endif /* _3W_XXXX_H */


      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ 

