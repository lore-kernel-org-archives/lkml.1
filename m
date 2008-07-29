Return-Path: <linux-kernel-owner+w=401wt.eu-S1756703AbYG2Jrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbYG2Jrc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 05:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbYG2JrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 05:47:23 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:51817 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbYG2JrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 05:47:22 -0400
Date: Tue, 29 Jul 2008 19:47:20 +1000
From: Simon Horman <horms@verge.net.au>
To: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>
Subject: [patch] IA64: only call up() in salinfo_work_to_do() if
	down_trylock() was successful
Message-ID: <20080729094718.GA5247@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aesthetic issues aside is it safe to call up() if down_trylock() failed?

arch/ia64/kernel/salinfo.c: In function `salinfo_work_to_do':
arch/ia64/kernel/salinfo.c:195: warning: ignoring return value of `down_trylock'

Signed-off-by: Simon Horman <horms@verge.net.au>

Index: linux-2.6/arch/ia64/kernel/salinfo.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/salinfo.c	2008-07-29 19:06:33.000000000 +1000
+++ linux-2.6/arch/ia64/kernel/salinfo.c	2008-07-29 19:40:02.000000000 +1000
@@ -192,8 +192,8 @@ struct salinfo_platform_oemdata_parms {
 static void
 salinfo_work_to_do(struct salinfo_data *data)
 {
-	down_trylock(&data->mutex);
-	up(&data->mutex);
+	if (down_trylock(&data->mutex) == 0)
+		up(&data->mutex);
 }
 
 static void
