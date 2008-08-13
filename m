Return-Path: <linux-kernel-owner+w=401wt.eu-S1754436AbYHMEGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbYHMEGA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 00:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750854AbYHMEFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 00:05:50 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:28422 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbYHMEFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 00:05:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Acwek8/y8JJNIAtr48bho79qRlEIljfSJgsKXNaTfAtX88w4YR1QEQ1ttSHsDiRMRy
         DTuYa3+N96w7aq4/P5zENrde8BuM2Xrq4yzT3KfzImUpP8qef+cck1FcIkXAQPexPCJq
         fco9cDLty8dvhyhDwVgMFdIqMR784J1UJzYAo=
Subject: [PATCH] tipc: Use the appropriate swab helper rather than an
	internal helper
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       per.liden@ericsson.com, jon.maloy@ericsson.com,
       allan.stephens@windriver.com
In-Reply-To: <20080812205422.4273d598.akpm@linux-foundation.org>
References: <1218587234.30194.93.camel@brick>
	 <20080812205422.4273d598.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 12 Aug 2008 21:05:47 -0700
Message-Id: <1218600348.30194.105.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

___generally means I am an internal implementation detail, don't use
me.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Sorry for breaking the build Andrew, my testing has been with all the __constant
versions in-tree removed.

 net/tipc/subscr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/tipc/subscr.c b/net/tipc/subscr.c
index 0326d30..f5da05d 100644
--- a/net/tipc/subscr.c
+++ b/net/tipc/subscr.c
@@ -85,7 +85,7 @@ static struct top_srv topsrv = { 0 };
 
 static u32 htohl(u32 in, int swap)
 {
-	return swap ? (u32)___constant_swab32(in) : in;
+	return swap ? (u32)swab32(in) : in;
 }
 
 /**
-- 
1.6.0.rc2.233.g3cb9d



