Return-Path: <linux-kernel-owner+w=401wt.eu-S1756922AbZECXZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbZECXZI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 19:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755584AbZECXYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 19:24:55 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:51664 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394AbZECXYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 19:24:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=hE5lUSOuMCGU6UrLnyuH9GqQgDiDPmmzVnCgxjn75DZZwWBobg/PT+T1aaLFz/ptEL
         qkLFeb/JqxoGnkWfkLKGZbNzSUyQ2sVOLOHl5JqG9oJZdb1HEHykMIPch6z/tLnFafcm
         zXMZcA329eRdshM9ae94IsgTzB4M3c3DeetXQ=
Date: Mon, 4 May 2009 03:25:42 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: [PATCH 1/2] ipcns 1/2: remove useless get/put while CLONE_NEWIPC
Message-ID: <20090503232542.GB16631@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_ipcs() doesn't actually copy anything. If new ipcns is created, it's
created from scratch, in this case get/put on old ipcns isn't needed.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---
 ipc/namespace.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/ipc/namespace.c b/ipc/namespace.c
index 4a5e752..a56fc59 100644
--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -50,15 +50,11 @@ struct ipc_namespace *copy_ipcs(unsigned long flags, struct ipc_namespace *ns)
 {
 	struct ipc_namespace *new_ns;
 
-	BUG_ON(!ns);
-	get_ipc_ns(ns);
-
 	if (!(flags & CLONE_NEWIPC))
-		return ns;
+		return get_ipc_ns(ns);
 
 	new_ns = clone_ipc_ns(ns);
 
-	put_ipc_ns(ns);
 	return new_ns;
 }
 
