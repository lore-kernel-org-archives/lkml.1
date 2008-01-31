Return-Path: <linux-kernel-owner+w=401wt.eu-S1758040AbYAaApW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040AbYAaApW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 19:45:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbYAaApI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 19:45:08 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:61217 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbYAaApH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 19:45:07 -0500
Date: Wed, 30 Jan 2008 16:43:10 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, samr <sam@ravnborg.org>
Subject: [PATCH 1/2] kernel-doc: prevent duplicate description: output
Message-Id: <20080130164310.007ad3fc.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Prevent duplicate output of a Description: section when there is a "blank"
("*") line between the initial function name/description line and the
"Description:" header.

Test case:  drivers/scsi/scsi_devinfo.c::scsi_init_devinfo().

Rob Landley hit this while he was producing SCSI kernel-doc.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---

 scripts/kernel-doc |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-git8.orig/scripts/kernel-doc
+++ linux-2.6.24-git8/scripts/kernel-doc
@@ -1907,7 +1907,7 @@ sub process_file($) {
 		$newsection = $1;
 		$newcontents = $2;
 
-		if ($contents ne "") {
+		if (($contents ne "") && ($contents ne "\n")) {
 		    if (!$in_doc_sect && $verbose) {
 			print STDERR "Warning(${file}:$.): contents before sections\n";
 			++$warnings;
