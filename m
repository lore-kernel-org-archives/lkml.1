Return-Path: <linux-kernel-owner+w=401wt.eu-S1758070AbYAGTOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070AbYAGTOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 14:14:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755402AbYAGTOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 14:14:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757522AbYAGTOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 14:14:31 -0500
Message-ID: <478279A4.3030903@redhat.com>
Date: Mon, 07 Jan 2008 14:12:36 -0500
From: Larry Woodman <lwoodman@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.4.2) Gecko/20040301
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [Patch] Include count of pagecache pages in show_mem() output.
Content-Type: multipart/mixed;
 boundary="------------010005090405090207040109"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010005090405090207040109
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

The show_mem() output does not include the total number of
pagecache pages.  This would be helpful when analyzing the
debug information in the /var/log/messages file after OOM kills
occur.

This patch includes the total pagecache pages in that output:

Signed-off-by: Larry Woodman <lwoodman@redhat.com>



--------------010005090405090207040109
Content-Type: text/plain;
 name="linux-2.6.23-showmem.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6.23-showmem.patch"

--- linux-2.6.23/mm/page_alloc.c.orig	2008-01-07 13:26:00.228823000 -0500
+++ linux-2.6.23/mm/page_alloc.c	2008-01-07 13:33:18.105448000 -0500
@@ -1644,6 +1644,8 @@ void show_free_areas(void)
 		printk("= %lukB\n", K(total));
 	}
 
+	printk("%ld total pagecache pages\n", global_page_state(NR_FILE_PAGES));
+
 	show_swap_cache_info();
 }
 

--------------010005090405090207040109--

