Return-Path: <linux-kernel-owner+w=401wt.eu-S1758305AbZKKRcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758305AbZKKRcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 12:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758274AbZKKRcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 12:32:14 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:34880 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758051AbZKKRcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 12:32:09 -0500
Date: Wed, 11 Nov 2009 09:31:07 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-pcmcia@lists.infradead.org,
       Harald Welte <laforge@gnumonks.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       gregkh@suse.de, akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] pcmcia: fix printk formats
Message-Id: <20091111093107.9032f4bb.randy.dunlap@oracle.com>
In-Reply-To: <20091111203159.a2a6eeeb.sfr@canb.auug.org.au>
References: <20091111203159.a2a6eeeb.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4AFAF4E6.0188:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings on sizeof() [size_t] arguments.

drivers/char/pcmcia/cm4040_cs.c:267: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'size_t'
drivers/char/pcmcia/cm4040_cs.c:272: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/char/pcmcia/cm4040_cs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20091110.orig/drivers/char/pcmcia/cm4040_cs.c
+++ linux-next-20091110/drivers/char/pcmcia/cm4040_cs.c
@@ -264,12 +264,12 @@ static ssize_t cm4040_read(struct file *
 
 	bytes_to_read = 5 + le32_to_cpu(*(__le32 *)&dev->r_buf[1]);
 
-	DEBUGP(6, dev, "BytesToRead=%lu\n", bytes_to_read);
+	DEBUGP(6, dev, "BytesToRead=%zu\n", bytes_to_read);
 
 	min_bytes_to_read = min(count, bytes_to_read + 5);
 	min_bytes_to_read = min_t(size_t, min_bytes_to_read, READ_WRITE_BUFFER_SIZE);
 
-	DEBUGP(6, dev, "Min=%lu\n", min_bytes_to_read);
+	DEBUGP(6, dev, "Min=%zu\n", min_bytes_to_read);
 
 	for (i = 0; i < (min_bytes_to_read-5); i++) {
 		rc = wait_for_bulk_in_ready(dev);
