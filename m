Return-Path: <linux-kernel-owner+w=401wt.eu-S1759619AbYF0Ip7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619AbYF0Ip7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 04:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756866AbYF0Iox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 04:44:53 -0400
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:24226 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755939AbYF0Iot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 04:44:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEANexXkh5LFnm/2dsb2JhbACuPg
X-IronPort-AV: E=Sophos;i="4.27,714,1204464600"; 
   d="scan'208";a="144433140"
From: Dave Chinner <david@fromorbit.com>
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org, matthew@wil.cx, dwalker@mvista.com
Subject: [PATCH 0/6] Remove most users of semaphores from XFS V2.
Date: Fri, 27 Jun 2008 18:44:38 +1000
Message-Id: <1214556284-4160-1-git-send-email-david@fromorbit.com>
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

Version 2:
o remove "flush" based API and just add the minimum necessary
  extensions to allow counting completions to do what is needed
  by XFS.
o change XFS patches to make use of new API
o clean up the XFS APIs using the new completion API a little.

