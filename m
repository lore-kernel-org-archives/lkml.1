Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbXLKTtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbXLKTtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 14:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbXLKTtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 14:49:06 -0500
Received: from smtp20.orange.fr ([80.12.242.27]:57572 "EHLO smtp20.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019AbXLKTtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 14:49:05 -0500
X-ME-UUID: 20071211194903100.186D61C000AB@mwinf2008.orange.fr
Message-ID: <475EE9B5.8060208@cosmosbay.com>
Date: Tue, 11 Dec 2007 20:49:09 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.13 (Windows/20070809)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] parport : "dev->timeslice" is an unsigned long, not an int
Content-Type: multipart/mixed;
 boundary="------------010500050403070709050209"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010500050403070709050209
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

While auditing proc_doulongvec_ms_jiffies_minmax() usage in kernel, I 
found a bug
in drivers/parport/procfs.c, incorrectly using sizeof(int) instead of 
sizeof(unsigned long)

Only 64bit arches are affected by this old bug.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>


--------------010500050403070709050209
Content-Type: text/plain;
 name="parport.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="parport.patch"

diff --git a/drivers/parport/procfs.c b/drivers/parport/procfs.c
index ed82e41..d950fc3 100644
--- a/drivers/parport/procfs.c
+++ b/drivers/parport/procfs.c
@@ -384,7 +384,7 @@ parport_device_sysctl_template = {
 		{
 			.procname 	= "timeslice",
 			.data		= NULL,
-			.maxlen		= sizeof(int),
+			.maxlen		= sizeof(unsigned long),
 			.mode		= 0644,
 			.proc_handler	= &proc_doulongvec_ms_jiffies_minmax,
 			.extra1		= (void*) &parport_min_timeslice_value,

--------------010500050403070709050209--


