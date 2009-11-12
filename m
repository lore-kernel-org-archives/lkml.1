Return-Path: <linux-kernel-owner+w=401wt.eu-S1755863AbZKLXq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbZKLXq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 18:46:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755358AbZKLXqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 18:46:22 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:22346 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367AbZKLXqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 18:46:18 -0500
Date: Thu, 12 Nov 2009 15:46:01 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       devel@driverdev.osuosl.org
Subject: [PATCH -next] staging/line6: fix printk formats
Message-Id: <20091112154601.97a4e2ab.randy.dunlap@oracle.com>
In-Reply-To: <20091112195101.63263490.sfr@canb.auug.org.au>
References: <20091112195101.63263490.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4AFC9E44.0017:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings in line6/pod.c; sizeof() is of type
size_t, so use %zu.

drivers/staging/line6/pod.c:581: warning: format '%d' expects type 'int', but argument 4 has type 'long unsigned int'
drivers/staging/line6/pod.c:693: warning: format '%d' expects type 'int', but argument 4 has type 'long unsigned int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/line6/pod.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20091112.orig/drivers/staging/line6/pod.c
+++ linux-next-20091112/drivers/staging/line6/pod.c
@@ -579,7 +579,7 @@ static ssize_t pod_set_dump(struct devic
 
 	if (count != sizeof(pod->prog_data)) {
 		dev_err(pod->line6.ifcdev,
-			"data block must be exactly %d bytes\n",
+			"data block must be exactly %zu bytes\n",
 			sizeof(pod->prog_data));
 		return -EINVAL;
 	}
@@ -691,7 +691,7 @@ static ssize_t pod_set_dump_buf(struct d
 
 	if (count != sizeof(pod->prog_data)) {
 		dev_err(pod->line6.ifcdev,
-						"data block must be exactly %d bytes\n",
+						"data block must be exactly %zu bytes\n",
 						sizeof(pod->prog_data));
 		return -EINVAL;
 	}
