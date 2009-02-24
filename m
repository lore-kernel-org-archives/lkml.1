Return-Path: <linux-kernel-owner+w=401wt.eu-S1755356AbZBXF1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbZBXF1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 00:27:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbZBXF1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 00:27:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:44484 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbZBXF1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 00:27:37 -0500
Message-ID: <49A3853B.5010404@kernel.org>
Date: Tue, 24 Feb 2009 14:27:23 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, jeremy@goop.org, cpw@sgi.com, mingo@elte.hu,
       tony.luck@intel.com
Subject: [PATCH tj-percpu] percpu: add __read_mostly to variables which are
 mostly read only
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <200902192221.52835.rusty@rustcorp.com.au> <499E1D01.2040408@kernel.org> <200902241326.23605.rusty@rustcorp.com.au>
In-Reply-To: <200902241326.23605.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Feb 2009 05:27:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most global variables in percpu allocator are initialized during boot
and read only from that point on.  Add __read_mostly as per Rusty's
suggestion.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
Added to #tj-percpu.

 mm/percpu.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 9ac0198..5954e7a 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -83,18 +83,18 @@ struct pcpu_chunk {
 	struct page		*page[];	/* #cpus * UNIT_PAGES */
 };
 
-static int pcpu_unit_pages;
-static int pcpu_unit_size;
-static int pcpu_chunk_size;
-static int pcpu_nr_slots;
-static size_t pcpu_chunk_struct_size;
+static int pcpu_unit_pages __read_mostly;
+static int pcpu_unit_size __read_mostly;
+static int pcpu_chunk_size __read_mostly;
+static int pcpu_nr_slots __read_mostly;
+static size_t pcpu_chunk_struct_size __read_mostly;
 
 /* the address of the first chunk which starts with the kernel static area */
-void *pcpu_base_addr;
+void *pcpu_base_addr __read_mostly;
 EXPORT_SYMBOL_GPL(pcpu_base_addr);
 
 /* the size of kernel static area */
-static int pcpu_static_size;
+static int pcpu_static_size __read_mostly;
 
 /*
  * One mutex to rule them all.
@@ -112,7 +112,7 @@ static int pcpu_static_size;
  */
 static DEFINE_MUTEX(pcpu_mutex);
 
-static struct list_head *pcpu_slot;		/* chunk list slots */
+static struct list_head *pcpu_slot __read_mostly; /* chunk list slots */
 static struct rb_root pcpu_addr_root = RB_ROOT;	/* chunks by address */
 
 static int __pcpu_size_to_slot(int size)
-- 
1.6.0.2

