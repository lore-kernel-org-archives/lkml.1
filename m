Return-Path: <linux-kernel-owner+w=401wt.eu-S932910AbYCFNU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932910AbYCFNU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 08:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbYCFNUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 08:20:20 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:43401 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbYCFNUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 08:20:19 -0500
Message-ID: <47CFEF82.10709@tiscali.nl>
Date: Thu, 06 Mar 2008 14:20:02 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: paulus@samba.org, arnd@arndb.de
CC: linuxppc-dev@ozlabs.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PPC: in celleb_show_cpuinfo() convert strncpy(x, y, sizeof(x))
 to strlcpy
References: <47CFEE9D.1020300@tiscali.nl>
In-Reply-To: <47CFEE9D.1020300@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:
> This patch was not yet tested. Please confirm it's right.

was too quick with the send button. the batch below is probably better
---
strncpy does not append '\0' if the length of the source string equals
the size parameter, strlcpy does.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/arch/powerpc/platforms/celleb/setup.c b/arch/powerpc/platforms/celleb/setup.c
index f27ae1e..cbe09d9 100644
--- a/arch/powerpc/platforms/celleb/setup.c
+++ b/arch/powerpc/platforms/celleb/setup.c
@@ -81,8 +81,7 @@ static void celleb_show_cpuinfo(struct seq_file *m)
 
 static int __init celleb_machine_type_hack(char *ptr)
 {
-	strncpy(celleb_machine_type, ptr, sizeof(celleb_machine_type));
-	celleb_machine_type[sizeof(celleb_machine_type)-1] = 0;
+	strlcpy(celleb_machine_type, ptr, sizeof(celleb_machine_type));
 	return 0;
 }
 
