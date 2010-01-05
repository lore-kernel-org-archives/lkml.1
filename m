Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836Ab0AEAnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab0AEAnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:43:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427Ab0AEAft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:35:49 -0500
Received: from kroah.org ([198.145.64.141]:34462 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754400Ab0AEAfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:44 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, WANG Cong <amwang@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 61/97] kernel/sysctl.c: fix the incomplete part of sysctl_max_map_count-should-be-non-negative.patch
Date: Mon,  4 Jan 2010 16:33:14 -0800
Message-Id: <1262651630-7354-61-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: WANG Cong <amwang@redhat.com>

commit 3e26120cc7c819c97bc07281ca1fb9017cfe9a39 upstream.

It is a mistake that we used 'proc_dointvec', it should be
'proc_dointvec_minmax', as in the original patch.

Signed-off-by: WANG Cong <amwang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sysctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 3928c04..dd84be9 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1607,7 +1607,7 @@ static struct ctl_table debug_table[] = {
 		.data		= &show_unhandled_signals,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero,
 	},
 #endif
-- 
1.6.6

