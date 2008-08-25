Return-Path: <linux-kernel-owner+w=401wt.eu-S1757744AbYHYVZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744AbYHYVZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 17:25:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754859AbYHYVYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 17:24:18 -0400
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:17235 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328AbYHYVYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 17:24:15 -0400
Message-Id: <20080825212035.861870487@quilx.com>
User-Agent: quilt/0.46-1
Date: Mon, 25 Aug 2008 14:20:35 -0700
From: Christoph Lameter <cl@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org
Cc: Mel Gorman <mel@skynet.ie>
Cc: andi@firstfloor.org
Cc: Rik van Riel <riel@redhat.com>
Cc: mpm@selenic.com
Cc: Dave Chinner <david@fromorbit.com>
Subject: [patch 0/3] Dentry support for Slab Fragmentation Reduction
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is basically a repost of the 2 patches that were dropped because
they caused oopses plus a fixup patch.

The reason for the failures was that commit
4a0962abd187df29b7d1378b2f372a55667d54c04a0962abd187df29b7d1378b2f372a55667d54c0
(back in February) was clobbered by a later
commit. As a result the dentry objects did not have consistent object
state on free which did not allow accurate object state determination.

The first patch fixes the dentry code so that there is a consistent object
state on free again.

---
