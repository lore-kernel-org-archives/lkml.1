Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbZFDDjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbZFDDjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 23:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbZFDDjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 23:39:46 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40074 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbZFDDjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 23:39:45 -0400
Date: Thu, 4 Jun 2009 12:38:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, garyhade@us.ibm.com, pbadari@us.ibm.com,
       "y-goto@jp.fujitsu.com" <y-goto@jp.fujitsu.com>, ebiederm@xmission.com,
       gregkh@suse.de
Subject: sysfs_create_link_nowarn still remains (Was Re: mmotm
 2009-06-03-16-33 uploaded
Message-Id: <20090604123813.96c2c5a9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200906032353.n53Nre5r019806@imap1.linux-foundation.org>
References: <200906032353.n53Nre5r019806@imap1.linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Jun 2009 16:33:52 -0700
akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2009-06-03-16-33 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://git.zen-sources.org/zen/mmotm.git
> 
It seems sysfs_create_link_nowarn() is removed in linux-next.patch but
driver/base/node.c still includes it.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=c04fc586c1a480ba198f03ae7b6cbd7b57380b91

How should we fix it ? Folllowing is a quick hack for compile but ...
should be clarified by memory hotplug guys.

==

sysfs_create_link_nowarn() is obsolete.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
Index: mmotm-2.6.30-Jun3/drivers/base/node.c
===================================================================
--- mmotm-2.6.30-Jun3.orig/drivers/base/node.c
+++ mmotm-2.6.30-Jun3/drivers/base/node.c
@@ -279,7 +279,7 @@ int register_mem_sect_under_node(struct 
 			continue;
 		if (page_nid != nid)
 			continue;
-		return sysfs_create_link_nowarn(&node_devices[nid].sysdev.kobj,
+		return sysfs_create_link(&node_devices[nid].sysdev.kobj,
 					&mem_blk->sysdev.kobj,
 					kobject_name(&mem_blk->sysdev.kobj));
 	}


