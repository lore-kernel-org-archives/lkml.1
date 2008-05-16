Return-Path: <linux-kernel-owner+w=401wt.eu-S1760572AbYEPWqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760572AbYEPWqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 18:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756223AbYEPWqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 18:46:13 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:63911 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202AbYEPWqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 18:46:12 -0400
Date: Fri, 16 May 2008 15:45:52 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, samr <sam@ravnborg.org>
Subject: [PATCH] kernel-doc: allow unnamed bit-fields
Message-Id: <20080516154552.eadc454e.randy.dunlap@oracle.com>
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

Allow for unnamed bit-fields and skip them instead of printing an
erroneous warning message for them, such as:

Warning(include/asm-s390/cio.h:103): No description found for parameter 'u32'

which contains:

struct tm_scsw {
	u32 :1;

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kernel-doc |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- next-20080516.orig/scripts/kernel-doc
+++ next-20080516/scripts/kernel-doc
@@ -1556,7 +1556,9 @@ sub create_parameterlist($$$) {
 		    push_parameter($2, "$type $1", $file);
 		}
 		elsif ($param =~ m/(.*?):(\d+)/) {
-		    push_parameter($1, "$type:$2", $file)
+		    if ($type ne "") { # skip unnamed bit-fields
+			push_parameter($1, "$type:$2", $file)
+		    }
 		}
 		else {
 		    push_parameter($param, $type, $file);
