Return-Path: <linux-kernel-owner+w=401wt.eu-S1753294AbYIMTYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbYIMTYS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 15:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbYIMTYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 15:24:09 -0400
Received: from nocturne.unbit.it ([81.174.68.18]:60311 "EHLO smtp.unbit.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752527AbYIMTYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 15:24:08 -0400
X-Greylist: delayed 422 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Sep 2008 15:24:08 EDT
Subject: Fix for xen guest with mem > 3.7G
From: Roberto De Ioris <roberto@unbit.it>
Reply-To: roberto@unbit.it
To: jeremy@xensource.com, linux-kernel@vger.kernel.org
Cc: Mirko Iannella <mirko@unbit.it>
Content-Type: text/plain
Organization: Unbit
Date: Sat, 13 Sep 2008 21:16:58 +0200
Message-Id: <1221333418.6036.9.camel@sirius>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xen domU kernel 2.6.26 and 2.6.27-rc cannot allocate
more than 3.7GB of ram on my PAE systems (compiled
with gcc version 4.2.3 (Ubuntu 4.2.3-2ubuntu7)).

I have found the problem is in function xen_memory_setup (in
arch/x86/xen/setup.c).

It set max_pfn as 'unsigned long' but add_memory_region()
takes 'unsigned long long'.

I do not know if it is a compiler problem but this is the simple fix
(works on my systems):

--- setup.c.orig	2008-09-13 21:12:56.000000000 +0200
+++ setup.c	2008-09-13 20:35:29.000000000 +0200
@@ -36,7 +36,7 @@
 
 char * __init xen_memory_setup(void)
 {
-	unsigned long max_pfn = xen_start_info->nr_pages;
+	unsigned long long max_pfn = xen_start_info->nr_pages;
 
 	e820.nr_map = 0;
 	add_memory_region(0, LOWMEMSIZE(), E820_RAM);



-- 
Roberto De Ioris
http://unbit.it
JID: roberto@jabber.unbit.it

