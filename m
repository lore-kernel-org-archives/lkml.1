Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915AbZG1Xvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbZG1Xvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755727AbZG1XvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:51:16 -0400
Received: from kroah.org ([198.145.64.141]:35998 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754724AbZG1Xug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:50:36 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:42:02 2009
Message-Id: <20090728234202.319908788@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:41:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Paul Mundt <lethal@linux-sh.org>, Mike Frysinger <vapier.adi@gmail.com>,
       James Morris <jmorris@namei.org>
Subject: [patch 69/71] nommu: Provide mmap_min_addr definition.
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=nommu-provide-mmap_min_addr-definition.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Paul Mundt <lethal@linux-sh.org>

commit 35f2c2f6f6ae13ef23c4f68e6d3073753077ca43 upstream.

With the "security: use mmap_min_addr indepedently of security models"
change, mmap_min_addr is used in common areas, which susbsequently blows
up the nommu build. This stubs in the definition in the nommu case as
well.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: James Morris <jmorris@namei.org>

---
 mm/nommu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -69,6 +69,9 @@ int sysctl_max_map_count = DEFAULT_MAX_M
 int sysctl_nr_trim_pages = CONFIG_NOMMU_INITIAL_TRIM_EXCESS;
 int heap_stack_gap = 0;
 
+/* amount of vm to protect from userspace access */
+unsigned long mmap_min_addr = CONFIG_DEFAULT_MMAP_MIN_ADDR;
+
 atomic_long_t mmap_pages_allocated;
 
 EXPORT_SYMBOL(mem_map);


