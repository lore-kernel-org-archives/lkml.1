Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936481Ab0CMBeO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:34:14 -0500
Received: from kroah.org ([198.145.64.141]:60589 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934827Ab0CMATm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:19:42 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:06 2010
Message-Id: <20100313001506.581568287@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:11:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 016/123] x86, uv: uv_global_gru_mmr_address() macro fix
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Jack Steiner <steiner@sgi.com>

commit e1e0138d7d10fd447c71cc70f367eac514bd3ce4 upstream.

Fix bug in uv_global_gru_mmr_address macro.  Macro failed
to cast an int value to a long prior to a left shift > 32.

Signed-off-by: Jack Steiner <steiner@sgi.com>
LKML-Reference: <20100107161240.GA2610@sgi.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/uv/uv_hub.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
@@ -329,7 +329,8 @@ static inline unsigned long uv_read_glob
  */
 static inline unsigned long uv_global_gru_mmr_address(int pnode, unsigned long offset)
 {
-	return UV_GLOBAL_GRU_MMR_BASE | offset | (pnode << uv_hub_info->m_val);
+	return UV_GLOBAL_GRU_MMR_BASE | offset |
+		((unsigned long)pnode << uv_hub_info->m_val);
 }
 
 static inline void uv_write_global_mmr8(int pnode, unsigned long offset, unsigned char val)


