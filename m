Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965258Ab0CMB3w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:29:52 -0500
Received: from kroah.org ([198.145.64.141]:60676 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934729Ab0CMAT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:19:56 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:08 2010
Message-Id: <20100313001508.139960942@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       "David S. Miller" <davem@davemloft.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 034/123] perf symbols: Check the right return variable
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Zhang, Yanmin <yanmin_zhang@linux.intel.com>

commit 37fe5fcb7a5b5235c8b71bf5469ce4c7246e3fab upstream.

In function dso__split_kallsyms(), curr_map saves the return value
of map__new2. So check it instead of var map after the call returns.

Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1267066851.1726.9.camel@localhost>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 tools/perf/util/symbol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -503,7 +503,7 @@ static int dso__split_kallsyms(struct ds
 				return -1;
 
 			curr_map = map__new2(pos->start, dso, map->type);
-			if (map == NULL) {
+			if (curr_map == NULL) {
 				dso__delete(dso);
 				return -1;
 			}


