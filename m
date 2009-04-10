Return-Path: <linux-kernel-owner+w=401wt.eu-S932626AbZDJCd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626AbZDJCd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 22:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932505AbZDJCdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 22:33:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:37038 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339AbZDJCdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 22:33:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=xEAq29HnFymXBodLjj6oqMyAqE6+wtcnZ2JEfnwK1veZvgtfOYyi8BdyCyHmHR1j9L
         dAetWTtRHW8cu1pYB2GM2ypAZENe6kI9dscg/d4NYJw8McYOoYmN2jW8xhYE5ETJrz29
         3+uNCnzp0qSPHy5Ti6iP0+jBA+T3qaAVB6cIM=
Date: Fri, 10 Apr 2009 06:33:35 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org, containers@lists.linux-foundation.org
Cc: xemul@parallels.com, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, orenl@cs.columbia.edu, hch@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 03/30] ipcns: remove useless get/put while CLONE_NEWIPC
Message-ID: <20090410023335.GD27788@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_ipcs() doesn't actually copy anything. If new ipcns is created,
it's created from scratch, in this case get/put on old ipcns isn't needed.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 ipc/namespace.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

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
 
