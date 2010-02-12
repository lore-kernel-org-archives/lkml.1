Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab0BLKTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 05:19:30 -0500
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:36599 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab0BLKT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 05:19:28 -0500
Date: Fri, 12 Feb 2010 11:19:24 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Andi Kleen <ak@linux.intel.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] sysdev: fix missing s390 conversion
Message-ID: <20100212101924.GA27548@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

In linux-next "sysdev: Pass attribute in sysdev_class attributes show/store"
forgot to convert one place in s390 code. Here is the missing part.

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/kernel/smp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -1033,7 +1033,9 @@ static ssize_t __ref rescan_store(struct
 static SYSDEV_CLASS_ATTR(rescan, 0200, NULL, rescan_store);
 #endif /* CONFIG_HOTPLUG_CPU */
 
-static ssize_t dispatching_show(struct sysdev_class *class, char *buf)
+static ssize_t dispatching_show(struct sysdev_class *class,
+				struct sysdev_class_attribute *attr,
+				char *buf)
 {
 	ssize_t count;
 
