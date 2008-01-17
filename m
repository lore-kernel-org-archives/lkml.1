Return-Path: <linux-kernel-owner+w=401wt.eu-S1754965AbYAQN6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbYAQN6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 08:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328AbYAQN6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 08:58:10 -0500
Received: from ag-out-0708.google.com ([72.14.246.250]:47310 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbYAQN6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 08:58:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=YbcXQQ/KwgVHRQsQJbZEFb3Jbe/MSEJ1DX4ea8UM1UcvBC8lhj+nlZLq87TtPbQG6eyUl3KVXEjm5ykC9Kk+852UcDII1sbQ/38kD05oLIkAOoiW8kCgX7VfZ6BNLliatcaKxNhPVwJLWM/gTNR2NHIJlUcEu+DQ6k6FEdz7PnM=
Date: Thu, 17 Jan 2008 21:56:41 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: [-mm Patch] uml: fix a building error
Message-ID: <20080117135641.GD2693@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080117023514.9df393cf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes this building error:
...
drivers/char/mem.c: In function ‘read_mem’:
drivers/char/mem.c:136: error: implicit declaration of function ‘unxlate_dev_mem_ptr’
...

Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---

Index: linux/include/asm-um/io.h
===================================================================
--- linux.orig/include/asm-um/io.h
+++ linux/include/asm-um/io.h
@@ -27,6 +27,7 @@ static inline void * phys_to_virt(unsign
  * access
  */
 #define xlate_dev_mem_ptr(p)	__va(p)
+#define unxlate_dev_mem_ptr(p, ptr)
 
 /*
  * Convert a virtual cached pointer to an uncached pointer
