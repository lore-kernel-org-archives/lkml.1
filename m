Return-Path: <linux-kernel-owner+w=401wt.eu-S1759333AbXKMDHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333AbXKMDHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 22:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbXKMDHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 22:07:31 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:63608 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbXKMDHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 22:07:30 -0500
Message-Id: <200711130307.lAD37Nee045340@www262.sakura.ne.jp>
Subject: [PATCH] sysctl: Check length at deprecated_sysctl_warning.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: akpm@linux-foundation.org
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Tue, 13 Nov 2007 12:07:23 +0900
References: <200711080257.lA82vQfA015942@www262.sakura.ne.jp> <20071107192211.c1c22e97.akpm@linux-foundation.org> <200711080819.lA88J8Pv072259@www262.sakura.ne.jp> <m14pfr6bnf.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m14pfr6bnf.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, please replace previous patch with this one.
This one returns -ENOTDIR.
----------

Original patch forgot to check args->nlen.
I don't know why args->nlen == CTL_MAXNAME is rejected,
but it has been rejected traditionally.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN kernel/sysctl.c~sysctl-check-length-at-deprecated_sysctl_warning kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-check-length-at-deprecated_sysctl_warning
+++ a/kernel/sysctl.c
@@ -2609,6 +2609,10 @@ static int deprecated_sysctl_warning(str
 	int name[CTL_MAXNAME];
 	int i;
 
+	/* Check args->nlen. */
+	if (args->nlen <= 0 || args->nlen >= CTL_MAXNAME)
+		return -ENOTDIR;
+
 	/* Read in the sysctl name for better debug message logging */
 	for (i = 0; i < args->nlen; i++)
 		if (get_user(name[i], args->name + i))
