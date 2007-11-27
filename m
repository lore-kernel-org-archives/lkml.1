Return-Path: <linux-kernel-owner+w=401wt.eu-S1758821AbXK0Sm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821AbXK0Sm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 13:42:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757550AbXK0SmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 13:42:19 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:60970 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756948AbXK0SmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 13:42:18 -0500
Date: Tue, 27 Nov 2007 12:42:14 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morgan <morgan@kernel.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>,
       Stephen Smalley <sds@epoch.ncsc.mil>, jmorris@sergelap.austin.ibm.com,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] capabilities: introduce per-process capability
	bounding set (v10)
Message-ID: <20071127184214.GA4032@sergelap.austin.ibm.com>
References: <20071126200908.GA13287@sergelap.austin.ibm.com> <474B9220.3020802@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474B9220.3020802@kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morgan (morgan@kernel.org):
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> This looks good to me.
> 
> [As you anticipated, there is a potential merge issue with Casey's
> recent addition of MAC capabilities - which will make CAP_MAC_ADMIN the
> highest allocated capability: ie.,
> 
> #define CAP_LAST_CAP         CAP_MAC_ADMIN
> 
> ].
> 
> Signed-off-by: Andrew G. Morgan <morgan@kernel.org>

Thanks, Andrew.

Yes, the following patch will be needed on top of the previous one:

-serge

>From 97ee046e8075a21b356fb93db0769d440437ef51 Mon Sep 17 00:00:00 2001
From: sergeh@us.ibm.com <hallyn@kernel.(none)>
Date: Tue, 27 Nov 2007 10:37:57 -0800
Subject: [PATCH 1/1] capabilities: fix CAP_LAST_CAP to CAP_MAC_ADMIN

A recent SMACK patch introduced two new capabilities.  The capability
bounding set patch defined CAP_LAST_CAP erroneously relative to that
patch.

Signed-off-by: Serge Hallyn <serue@us.ibm.com>
---
 include/linux/capability.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/capability.h b/include/linux/capability.h
index 5fc3fea..7d50ff6 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -332,7 +332,7 @@ typedef struct kernel_cap_struct {
 
 #define CAP_MAC_ADMIN        33
 
-#define CAP_LAST_CAP         CAP_SETFCAP
+#define CAP_LAST_CAP         CAP_MAC_ADMIN
 
 #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
 
-- 
1.5.1

