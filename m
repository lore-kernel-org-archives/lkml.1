Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbXJLCZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbXJLCZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 22:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbXJLCZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 22:25:20 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60858 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbXJLCZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 22:25:19 -0400
Date: Fri, 12 Oct 2007 11:24:09 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Andrew Morton <akpm@osdl.org>
Subject: [Patch 000/002] Make kmem_cache_node for SLUB on memory online to avoid panic(take 2)
Cc: Christoph Lameter <clameter@sgi.com>,
       Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <20071012111008.B995.Y-GOTO@jp.fujitsu.com>
References: <20071012111008.B995.Y-GOTO@jp.fujitsu.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20071012112236.B99B.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set is to fix panic due to access NULL pointer of SLUB.

When new memory is hot-added on the new node (or memory less node),
kmem_cache_node for the new node is not prepared,
and panic occurs by it. So, kmem_cache_node should be created for the node
before new memory is available on the node.
Incidentally, it is freed on memory offline if it becomes not necessary.

This is the first user of the callback of memory notifier, and
requires its rearrange patch set.

This patch set is for 2.6.23-rc8-mm2.
I tested this patch on my ia64 box.

Please apply.

Bye.


-- 
Yasunori Goto 


