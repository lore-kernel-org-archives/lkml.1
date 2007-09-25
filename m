Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405AbXIYMYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbXIYMYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 08:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbXIYMYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 08:24:41 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:34666 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbXIYMYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 08:24:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=m5Paj/lr2bNYRIZ+KebUD1TfDf6owqEy5V6VbAwsl+ILY0Nz8ds1Ek3fzNbVCSm/RKeOYKpV6aXssujxxAA6QU/b+IG23F79W4Ee956fL+PR0yaQKCdFZmm/66UnOjt3uugQFtwjUCIdgbjQTeFdM0shTgFFyfE61+mSZ1SESjY=
Date: Tue, 25 Sep 2007 20:19:59 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, bfennema@falcon.csc.calpoly.edu
Subject: [-mm Patch] fs/udf/balloc.c: mark a variable as uninitialized_var()
Message-ID: <20070925121959.GF4945@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20070925014625.3cd5f896.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070925014625.3cd5f896.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch kills a may-be-used-uninitialized warning.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
 fs/udf/balloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23-rc8-mm1/fs/udf/balloc.c
===================================================================
--- linux-2.6.23-rc8-mm1.orig/fs/udf/balloc.c
+++ linux-2.6.23-rc8-mm1/fs/udf/balloc.c
@@ -689,7 +689,7 @@ static int udf_table_new_block(struct su
 	uint32_t spread = 0xFFFFFFFF, nspread = 0xFFFFFFFF;
 	uint32_t newblock = 0, adsize;
 	uint32_t elen, goal_elen = 0;
-	kernel_lb_addr eloc, goal_eloc;
+	kernel_lb_addr eloc, uninitialized_var(goal_eloc);
 	struct extent_position epos, goal_epos;
 	int8_t etype;
 
