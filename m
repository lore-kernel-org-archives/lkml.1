Return-Path: <linux-kernel-owner+w=401wt.eu-S1755266AbZGYCKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbZGYCKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 22:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbZGYCK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 22:10:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34991 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbZGYCK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 22:10:29 -0400
Date: Fri, 24 Jul 2009 22:10:26 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH] Don't export scsi kernel variables in userspace headers.
Message-ID: <20090725021026.GA6942@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-scsi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found with make headers_check

/usr/include/scsi/scsi.h:159: userspace cannot call function or variable defined in the kernel
/usr/include/scsi/scsi.h:285: userspace cannot call function or variable defined in the kernel

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 084478e..689570e 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -156,7 +156,9 @@ scsi_varlen_cdb_length(const void *hdr)
 	return ((struct scsi_varlen_cdb_hdr *)hdr)->additional_cdb_length + 8;
 }
 
+#ifdef __KERNEL__
 extern const unsigned char scsi_command_size_tbl[8];
+#endif
 #define COMMAND_SIZE(opcode) scsi_command_size_tbl[((opcode) >> 5) & 7]
 
 static inline unsigned
@@ -281,8 +283,10 @@ enum scsi_protocol {
 	SCSI_PROTOCOL_UNSPEC = 0xf, /* No specific protocol */
 };
 
+#ifdef __KERNEL__
 /* Returns a human-readable name for the device */
 extern const char * scsi_device_type(unsigned type);
+#endif
 
 /*
  * standard mode-select header prepended to all mode-select commands
