Return-Path: <linux-kernel-owner+w=401wt.eu-S935262AbZLPW0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935262AbZLPW0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:26:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932535AbZLPW0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:26:20 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:60856 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486AbZLPW0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:26:19 -0500
Date: Wed, 16 Dec 2009 14:26:06 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org
Subject: [PATCH -next] power: fix printk formats
Message-Id: <20091216142606.1a9f3817.randy.dunlap@oracle.com>
In-Reply-To: <20091216183212.118c5e14.sfr@canb.auug.org.au>
References: <20091216183212.118c5e14.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4B295E73.022A:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings:

drivers/base/power/main.c:398:warning: format '%Lu' expects type 'long long unsigned int', but argument 5 has type 'long int'
drivers/base/power/main.c:398:warning: format '%03Lu' expects type 'long long unsigned int', but argument 6 has type 'long int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/base/power/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20091216.orig/drivers/base/power/main.c
+++ linux-next-20091216/drivers/base/power/main.c
@@ -395,7 +395,7 @@ static void dpm_show_time(ktime_t startt
 	usecs = usecs64;
 	if (usecs == 0)
 		usecs = 1;
-	pr_info("PM: %s%s%s of devices complete after %Lu.%03Lu msecs\n",
+	pr_info("PM: %s%s%s of devices complete after %lu.%03lu msecs\n",
 		info ?: "", info ? " " : "", pm_verb(state.event),
 		usecs / USEC_PER_MSEC, usecs % USEC_PER_MSEC);
 }
