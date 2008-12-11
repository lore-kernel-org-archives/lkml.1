Return-Path: <linux-kernel-owner+w=401wt.eu-S1757306AbYLKTnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306AbYLKTnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:43:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757904AbYLKTTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:19:22 -0500
Received: from kroah.org ([198.145.64.141]:56677 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757607AbYLKTTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:19:20 -0500
Date: Thu, 11 Dec 2008 11:16:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Yinghai <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 69/83] x86, memory hotplug: remove wrong -1 in calling
	init_memory_mapping()
Message-ID: <20081211191622.GQ5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-memory-hotplug-remove-wrong-1-in-calling-init_memory_mapping.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Shaohua Li <shaohua.li@intel.com>

commit 60817c9b31ef7897d60bca2f384cbc316a3fdd8b upstream.

Impact: fix crash with memory hotplug

Shuahua Li found:

| I just did some experiments on a desktop for memory hotplug and this bug
| triggered a crash in my test.
|
| Yinghai's suggestion also fixed the bug.

We don't need to round it, just remove that extra -1

Signed-off-by: Yinghai <yinghai@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/mm/init_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -721,7 +721,7 @@ int arch_add_memory(int nid, u64 start, 
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 	int ret;
 
-	last_mapped_pfn = init_memory_mapping(start, start + size-1);
+	last_mapped_pfn = init_memory_mapping(start, start + size);
 	if (last_mapped_pfn > max_pfn_mapped)
 		max_pfn_mapped = last_mapped_pfn;
 

