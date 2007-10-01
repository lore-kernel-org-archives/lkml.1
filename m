Return-Path: <linux-kernel-owner+w=401wt.eu-S1752729AbXJAJcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbXJAJcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 05:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbXJAJcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 05:32:00 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59022 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbXJAJcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 05:32:00 -0400
Date: Mon, 01 Oct 2007 18:30:52 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Andrew Morton <akpm@osdl.org>
Subject: [Patch / 000](memory hotplug) Fix NULL pointer access of kmem_cache_node when hot-add.
Cc: Christoph Lameter <clameter@sgi.com>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Yasunori Goto <y-goto@jp.fujitsu.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20071001182329.7A97.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

This patch set is to fix panic due to access NULL pointer of SLUB.

When new memory is hot-added on the new node (or memory less node),
kmem_cache_node for the new node is not prepared,
and panic occurs by it. So, new kmem_cache_node should be created
before new memory is available on the node.

This is the first user of the callback of memory notifier.
So, the first patch is to change some defects of it.

This patch set is for 2.6.23-rc8-mm2.
I tested this patch on my ia64 box.

Please apply.

Bye.

-- 
Yasunori Goto 


