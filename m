Return-Path: <linux-kernel-owner+w=401wt.eu-S1755999AbZFQCHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbZFQCHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 22:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261AbZFQCHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 22:07:43 -0400
Received: from mail-pz0-f187.google.com ([209.85.222.187]:48763 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbZFQCHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 22:07:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=MqUjgtFhSSFQCGWsBAZ2R7sU2M9L8ajUUXhz7EnPOULeK12tpB2QosjxuR6PnNrHuP
         f9XK2q9r6p9SBvbMZwz/0O5W+CRE1S8yNmTHLqIurgAhNaoCd5uLf5Lxdoz3E6DsNCpA
         n6rWsUHvIFpOmLlpLBsaXBfYVI4MwJeAQB+6A=
Message-ID: <4A384FE4.9090703@gmail.com>
Date: Wed, 17 Jun 2009 10:07:32 +0800
From: Changli Gao <xiaosuo@gmail.com>
Reply-To: xiaosuo <xiaosuo@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090505)
MIME-Version: 1.0
To: James.Bottomley@HansenPartnership.com
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, xiaosuo <xiaosuo@gmail.com>
Subject: [PATCH] scsi_wait_scan: no option appears when configuring for scsi_wait_scan.
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FIXBUG: missing comment after tristate leads to no option for
scsci_wait_scan when configuring.

When build kernel, this module is always built if I choose SCSI, and I
can't find any option in the configuration menu, so I can't disable it
or build it into kernel statically. After diving into the kernel source
code, I found no comment after keyword tristate, then I added the
comment and help.

Signed-off-by: Changli Gao <xiaosuo@gmail.com <mailto:xiaosuo@gmail.com>>
----

Kconfig | 7 ++++++-
1 file changed, 6 insertions(+), 1 deletion(-)

--- drivers/scsi/Kconfig.orig	2009-06-17 09:52:46.000000000 +0800
+++ drivers/scsi/Kconfig	2009-06-17 09:55:57.000000000 +0800
@@ -259,10 +259,15 @@
 	  or async on the kernel's command line.
 
 config SCSI_WAIT_SCAN
-	tristate
+	tristate "Wait until all the async scans are complete"
 	default m
 	depends on SCSI
 	depends on MODULES
+	help
+	  Wait until all the async scans are complete. The idea is to use it in
+	  initrd/initramfs scripts.  You modprobe it after all the modprobes of
+	  the root SCSI drivers and it will wait until they have all finished
+	  scanning their busses before allowing the boot to proceed
 
 menu "SCSI Transports"
 	depends on SCSI

