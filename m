Return-Path: <linux-kernel-owner+w=401wt.eu-S1754396AbZJBBdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbZJBBdP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754999AbZJBBdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:33:12 -0400
Received: from kroah.org ([198.145.64.141]:33116 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755757AbZJBBdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:08 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:13 2009
Message-Id: <20091002012413.501035228@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jack Steiner <steiner@sgi.com>, Ingo Molnar <mingo@elte.hu>
Subject: [049/136] x86: SGI UV: Fix IPI macros
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=x86-sgi-uv-fix-ipi-macros.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jack Steiner <steiner@sgi.com>

commit d2374aecda3f6c9b0d13287027132a37311da300 upstream.

The UV BIOS has changed the way interrupt remapping is being done.
This affects the id used for sending IPIs. The upper id bits no
longer need to be masked off.

Signed-off-by: Jack Steiner <steiner@sgi.com>
LKML-Reference: <20090909154104.GA25083@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/uv/uv_hub.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
@@ -422,7 +422,7 @@ static inline void uv_hub_send_ipi(int p
 	unsigned long val;
 
 	val = (1UL << UVH_IPI_INT_SEND_SHFT) |
-			((apicid & 0x3f) << UVH_IPI_INT_APIC_ID_SHFT) |
+			((apicid) << UVH_IPI_INT_APIC_ID_SHFT) |
 			(vector << UVH_IPI_INT_VECTOR_SHFT);
 	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
 }


