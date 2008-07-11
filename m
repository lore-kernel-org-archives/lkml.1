Return-Path: <linux-kernel-owner+w=401wt.eu-S1759280AbYGKBOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280AbYGKBOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 21:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756734AbYGKBNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 21:13:55 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:54292 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756132AbYGKBNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 21:13:54 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAF9Odkh5LFxA/2dsb2JhbACxSA
X-IronPort-AV: E=Sophos;i="4.30,341,1212330600"; 
   d="scan'208";a="146350267"
From: Dave Chinner <david@fromorbit.com>
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org, matthew@wil.cx
Subject: [RESEND, PATCH 0/6] Remove most users of semaphores from XFS
Date: Fri, 11 Jul 2008 11:13:44 +1000
Message-Id: <1215738830-31048-1-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.5.6
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

