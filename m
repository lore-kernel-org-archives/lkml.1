Return-Path: <linux-kernel-owner+w=401wt.eu-S1757836AbYHZJzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836AbYHZJzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 05:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbYHZJyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 05:54:51 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43547 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbYHZJyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 05:54:50 -0400
Message-Id: <20080826095524.294452330@bull.net>
References: <20080826095427.460892713@bull.net>
User-Agent: quilt/0.46-1
Date: Tue, 26 Aug 2008 11:54:28 +0200
From: Nadia.Derbey@bull.net
To: akpm@linux-foundation.org
Cc: matthltc@us.ibm.com, Solofo.Ramangalahy@bull.net,
       linux-kernel@vger.kernel.org, Nadia.Derbey@bull.net
Subject: [PATCH 1/1] IPC - Document the new auto_msgmni proc file
Content-Disposition: inline; filename=auto_msgmni_doc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delay but this message has been queued for 5 days (my sendmail
was not correclty configured) - resending.

[PATCH 01/01]

This patch updates Documentation/filesystems/proc.txt: it describes the file
auto_msgmni intoduced to enable/disable msgmni automatic recomputing upon
memory add/remove (see thread http://lkml.org/lkml/2008/7/4/27).
Also added a description for msgmni (this filex is only listed in
Documentation/sysctl/kernel.txt).

Applies to 2.6.27-rc1-mm1.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 Documentation/filesystems/proc.txt |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

Index: linux-2.6.27-rc1-mm1/Documentation/filesystems/proc.txt
===================================================================
--- linux-2.6.27-rc1-mm1.orig/Documentation/filesystems/proc.txt	2008-08-21 09:43:36.000000000 +0200
+++ linux-2.6.27-rc1-mm1/Documentation/filesystems/proc.txt	2008-08-21 10:17:28.000000000 +0200
@@ -1339,6 +1339,25 @@ Enables/Disables the protection of the p
 "smaps".  When enabled, the contents of these files are visible only to
 readers that are allowed to ptrace() the given process.
 
+msgmni
+------
+
+Maximum number of message queue ids on the system.
+This value scales to the amount of lowmem. It is automatically recomputed
+upon memory add/remove or ipc namespace creation/removal.
+When a value is written into this file, msgmni's value becomes fixed, i.e. it
+is not recomputed anymore when one of the above events occurs.
+Use auto_msgmni to change this behavior.
+
+auto_msgmni
+-----------
+
+Enables/Disables automatic recomputing of msgmni upon memory add/remove or
+upon ipc namespace creation/removal (see the msgmni description above).
+Echoing "1" into this file enables msgmni automatic recomputing.
+Echoing "0" turns it off.
+auto_msgmni default value is 1.
+
 
 2.4 /proc/sys/vm - The virtual memory subsystem
 -----------------------------------------------

-- 
