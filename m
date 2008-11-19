Return-Path: <linux-kernel-owner+w=401wt.eu-S1753227AbYKSMYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbYKSMYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 07:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYKSMYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 07:24:08 -0500
Received: from mail.parknet.ad.jp ([210.171.162.6]:51674 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbYKSMYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 07:24:05 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Add might_sleep_if() for slub
Date: Wed, 19 Nov 2008 21:23:59 +0900
Message-ID: <87abbv29b4.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I don't know it is intention, or not. However, current SLUB not seems to
warn about might_sleep_if(gfpflags & __GFP_WAIT);

If it's not intention, please apply.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>


Currently SLUB doesn't warn about __GFP_WAIT. Add it into slab_alloc().

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 mm/slub.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/slub.c~slub-might-sleep mm/slub.c
--- linux-2.6/mm/slub.c~slub-might-sleep	2008-11-19 20:57:28.000000000 +0900
+++ linux-2.6-hirofumi/mm/slub.c	2008-11-19 20:57:28.000000000 +0900
@@ -1591,6 +1591,7 @@ static __always_inline void *slab_alloc(
 	unsigned long flags;
 	unsigned int objsize;
 
+	might_sleep_if(gfpflags & __GFP_WAIT);
 	local_irq_save(flags);
 	c = get_cpu_slab(s, smp_processor_id());
 	objsize = c->objsize;
_
