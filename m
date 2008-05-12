Return-Path: <linux-kernel-owner+w=401wt.eu-S1755620AbYELP2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbYELP2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 11:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbYELP2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 11:28:03 -0400
Received: from smtp.cs.aau.dk ([130.225.194.6]:55219 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777AbYELP2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 11:28:00 -0400
Subject: [PATCH] Remove NULL pointer check for argument never passed as
	NULL.
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: Julia Lawall <julia@diku.dk>
Cc: tony.luck@intel.com, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0805121637180.3694@ask.diku.dk>
References: <Pine.LNX.4.64.0805121536370.3694@ask.diku.dk>
	 <1210603050.25310.9.camel@odie.local>
	 <Pine.LNX.4.64.0805121637180.3694@ask.diku.dk>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 12 May 2008 17:40:50 +0200
Message-Id: <1210606850.25310.14.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is only palinfo_handle_smp as (indirect) user of palinfo_smp_call (by
way of smp_call_function_single) and surely palinfo_handle_smp never pass
NULL as parameter for info.

Signed-off-by: Simon Holm Thøgersen <odie@cs.aau.dk>
---
 arch/ia64/kernel/palinfo.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/ia64/kernel/palinfo.c b/arch/ia64/kernel/palinfo.c
index 4547a20..9dc00f7 100644
--- a/arch/ia64/kernel/palinfo.c
+++ b/arch/ia64/kernel/palinfo.c
@@ -900,12 +900,6 @@ static void
 palinfo_smp_call(void *info)
 {
 	palinfo_smp_data_t *data = (palinfo_smp_data_t *)info;
-	if (data == NULL) {
-		printk(KERN_ERR "palinfo: data pointer is NULL\n");
-		data->ret = 0; /* no output */
-		return;
-	}
-	/* does this actual call */
 	data->ret = (*data->func)(data->page);
 }
 
-- 
1.5.5.1.125.gc697a

