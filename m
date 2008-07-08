Return-Path: <linux-kernel-owner+w=401wt.eu-S1756779AbYGHIaC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbYGHIaC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 04:30:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbYGHI3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 04:29:53 -0400
Received: from saeurebad.de ([85.214.36.134]:50986 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbYGHI3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 04:29:52 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] lguest: fix switcher_page leak on unload
CC: linux-kernel@vger.kernel.org
Date: Tue, 08 Jul 2008 10:29:42 +0200
Message-ID: <87r6a4n5hl.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

map_switcher allocates the array, unmap_switcher has to free it
accordingly.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---

diff --git a/drivers/lguest/core.c b/drivers/lguest/core.c
index 5eea435..90663e0 100644
--- a/drivers/lguest/core.c
+++ b/drivers/lguest/core.c
@@ -135,6 +135,7 @@ static void unmap_switcher(void)
 	/* Now we just need to free the pages we copied the switcher into */
 	for (i = 0; i < TOTAL_SWITCHER_PAGES; i++)
 		__free_pages(switcher_page[i], 0);
+	kfree(switcher_page);
 }
 
 /*H:032
