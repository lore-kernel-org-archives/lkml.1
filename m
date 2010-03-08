Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501Ab0CHFjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 00:39:49 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:39553 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab0CHFjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 00:39:44 -0500
Date: Sun, 7 Mar 2010 21:37:24 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] scripts/kernel-doc: fix empty function description section
Message-Id: <20100307213724.30f84ea2.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0208.4B948D79.01A4:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

scripts/kernel-doc mishandles a function that has a multi-line
function short description and no function parameters.  The
observed problem was from drivers/scsi/scsi_netlink.c:

/**
 * scsi_netlink_init - Called by SCSI subsystem to intialize
 * 	the SCSI transport netlink interface
 *
 **/

kernel-doc treated the " * " line as a Description: section with
only a newline character in the Description contents.  This caused
output_highlight() to complain:
output_highlight got called with no args?
plus produce a perl call stack backtrace.

The fix is just to ignore Description sections if they only
contain "\n".

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kernel-doc |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.33-git13.orig/scripts/kernel-doc
+++ linux-2.6.33-git13/scripts/kernel-doc
@@ -2105,7 +2105,7 @@ sub process_file($) {
 		$section = $newsection;
 	    } elsif (/$doc_end/) {
 
-		if ($contents ne "") {
+		if (($contents ne "") && ($contents ne "\n")) {
 		    dump_section($file, $section, xml_escape($contents));
 		    $section = $section_default;
 		    $contents = "";
