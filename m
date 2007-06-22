Return-Path: <linux-kernel-owner+w=401wt.eu-S1758105AbXFVOFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbXFVOFm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 10:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755085AbXFVOFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 10:05:35 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:17722 "EHLO
	outbound6-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752218AbXFVOFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 10:05:33 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Fri, 22 Jun 2007 16:06:15 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: [patch] DLM: fix kconfig dependency
Message-ID: <20070622140615.GP5193@alberich.amd.com>
MIME-Version: 1.0
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 22 Jun 2007 14:05:07.0585 (UTC)
 FILETIME=[56D06F10:01C7B4D6]
X-WSS-ID: 6A6508AA1S41141638-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid kernel build error (as DLM depends on SYSFS)
    
  LD      vmlinux
  fs/built-in.o: In function `dlm_lockspace_init':
  : undefined reference to `kernel_subsys'
  fs/built-in.o: In function `configfs_init':
  mount.c:(.init.text+0xef4): undefined reference to `kernel_subsys'
    
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>

diff --git a/fs/dlm/Kconfig b/fs/dlm/Kconfig
index 69a9469..c0e4c59 100644
--- a/fs/dlm/Kconfig
+++ b/fs/dlm/Kconfig
@@ -1,5 +1,5 @@
 menu "Distributed Lock Manager"
-	depends on EXPERIMENTAL && INET
+	depends on EXPERIMENTAL && INET && SYSFS
 
 config DLM
 	tristate "Distributed Lock Manager (DLM)"



