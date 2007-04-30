Return-Path: <linux-kernel-owner+w=401wt.eu-S1946706AbXD3TQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946706AbXD3TQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 15:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946710AbXD3TQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 15:16:12 -0400
Received: from smtp-out.google.com ([216.239.45.13]:44707 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946706AbXD3TQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 15:16:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=qIHChRwo1sC1LkJ25r3DniI4rDZgwJB6ux4t0w/2yKRXCOjiAzj6sZBxzADq3RjGq
	bNazrkpNEnKvOL0M3f3Hg==
Date: Mon, 30 Apr 2007 12:15:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: David Brownell <david-b@pacbell.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] pm: include EIO from errno-base.h
In-Reply-To: <200704300751.07078.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.64.0704301215190.17664@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0704291700220.1822@chino.kir.corp.google.com>
 <200704300751.07078.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For backwards compatibility, call_platform_enable_wakeup() can return 0 
instead of -EIO since we aren't guaranteed to have errno defined.

Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/pm.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/pm.h b/include/linux/pm.h
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -328,7 +328,7 @@ static inline void dpm_runtime_resume(struct device * dev)
 
 static inline int call_platform_enable_wakeup(struct device *dev, int is_on)
 {
-	return -EIO;
+	return 0;
 }
 
 #endif
