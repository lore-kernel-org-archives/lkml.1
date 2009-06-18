Return-Path: <linux-kernel-owner+w=401wt.eu-S1756730AbZFRAkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbZFRAkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 20:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbZFRAkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 20:40:09 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:17632 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbZFRAkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 20:40:08 -0400
Message-ID: <4A398BFF.2090308@oracle.com>
Date: Wed, 17 Jun 2009 17:36:15 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       samr <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] kernel-doc: ignore kmemcheck_bitfield_begin/end
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt004.oracle.com [141.146.116.13]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4A398CC3.027A:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Teach kernel-doc to ignore kmemcheck_bitfield_{begin,end} sugar
so that it won't generate warnings like this:

Warning(include/net/sock.h:297): No description found for parameter 'kmemcheck_bitfield_begin(flags)'
Warning(include/net/sock.h:297): No description found for parameter 'kmemcheck_bitfield_end(flags)'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kernel-doc |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.30-git11.orig/scripts/kernel-doc
+++ linux-2.6.30-git11/scripts/kernel-doc
@@ -1468,6 +1468,8 @@ sub dump_enum($$) {
 	    }
 
 	}
+	# strip kmemcheck_bitfield_{begin,end}.*;
+	$members =~ s/kmemcheck_bitfield_.*?;//gos;
 
 	output_declaration($declaration_name,
 			   'enum',


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
