Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966153Ab0BZVGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 16:06:21 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:60625 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968Ab0BZVGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 16:06:18 -0500
Message-ID: <4B8837AB.1090204@oracle.com>
Date: Fri, 26 Feb 2010 13:05:47 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: lya Dryomov <idryomov@gmail.com>
Subject: [PATCH 1/2] scripts/kernel-doc: track line numbers for each file
 separately
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4B8837BE.0083:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ilya Dryomov <idryomov@gmail.com>
Subject: kernel-doc: track line numbers for each file separately

The problem is that $. keeps track of the current record number (which
is line number by default). But if you pass it multiple files, it does
not wrap at the end of file, and therefore contains the *total* number
of processed lines.
I suppose we can fix line numbering by introducing a simple assignment
$. = 1
before processing every new file.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kernel-doc |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.33-rc3-git5.orig/scripts/kernel-doc
+++ linux-2.6.33-rc3-git5/scripts/kernel-doc
@@ -2023,6 +2023,8 @@ sub process_file($) {
 	return;
     }
 
+    $. = 1;
+
     $section_counter = 0;
     while (<IN>) {
 	if ($state == 0) {
