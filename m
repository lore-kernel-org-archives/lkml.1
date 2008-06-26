Return-Path: <linux-kernel-owner+w=401wt.eu-S1755724AbYFZElc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724AbYFZElc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 00:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbYFZElX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 00:41:23 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:43355 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752539AbYFZElW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 00:41:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjQDAEOGYkh5LG+uZWdsb2JhbACSXhICHqAH
X-IronPort-AV: E=Sophos;i="4.27,706,1204464600"; 
   d="scan'208";a="135640682"
From: Dave Chinner <david@fromorbit.com>
To: xfs@oss.sgi.com
Cc: matthew@wil.cx, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] Remove most users of semaphores from XFS.
Date: Thu, 26 Jun 2008 14:41:11 +1000
Message-Id: <1214455277-6387-1-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.5.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series aims to convert all but one of the remaining users of
semaphores in the XFS code to use completions. Two of these
semaphores don't quite match to completion semantics, but a small
amount of additional code on top of the completions fixes this
problem. I'm open to suggestions on different/better ways to implement
this.

The patch series does not touch the b_lock semaphore in the
xfs_buf_t. At this point I'm not sure what we want to do with that
semaphore so I've ignored that for now. Also, this lock uses
linux primitives, not the xfs sema_t primitives so  it doesn't
need changing to allow me to remove the sema_t.

