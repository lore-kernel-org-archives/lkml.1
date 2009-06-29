Return-Path: <linux-kernel-owner+w=401wt.eu-S1757063AbZF2Vyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063AbZF2Vyg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 17:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbZF2Vy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 17:54:28 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:54704 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbZF2Vy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 17:54:27 -0400
Message-ID: <4A493803.9010509@oracle.com>
Date: Mon, 29 Jun 2009 14:54:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: Sam Ravnborg <sam@ravnborg.org>, akpm <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] kernel-doc: move ignoring kmemcheck
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt008.oracle.com [141.146.116.17]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010207.4A4937FA.021C:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Somehow I managed to generate a diff that put these 2 lines
into the wrong function:  should have been in dump_struct()
instead of in dump_enum().

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kernel-doc |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.31-rc1-git5.orig/scripts/kernel-doc
+++ linux-2.6.31-rc1-git5/scripts/kernel-doc
@@ -1426,6 +1426,8 @@ sub dump_struct($$) {
 	# strip comments:
 	$members =~ s/\/\*.*?\*\///gos;
 	$nested =~ s/\/\*.*?\*\///gos;
+	# strip kmemcheck_bitfield_{begin,end}.*;
+	$members =~ s/kmemcheck_bitfield_.*?;//gos;
 
 	create_parameterlist($members, ';', $file);
 	check_sections($file, $declaration_name, "struct", $sectcheck, $struct_actual, $nested);
@@ -1468,8 +1470,6 @@ sub dump_enum($$) {
 	    }
 
 	}
-	# strip kmemcheck_bitfield_{begin,end}.*;
-	$members =~ s/kmemcheck_bitfield_.*?;//gos;
 
 	output_declaration($declaration_name,
 			   'enum',
