Return-Path: <linux-kernel-owner+w=401wt.eu-S1757253AbZJBB5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253AbZJBB5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755296AbZJBBcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:32:52 -0400
Received: from kroah.org ([198.145.64.141]:33010 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755064AbZJBBcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:32:50 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:10 2009
Message-Id: <20091002012410.347953270@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [030/136] perf tools: Fix buffer allocation
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=perf-tools-fix-buffer-allocation.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Eric Dumazet <eric.dumazet@gmail.com>

commit a255a9981a8566a1efabec983b7811e937e662d2 upstream.

"perf top" cores dump on my dev machine, if run from a directory
where vmlinux is present:

  *** glibc detected *** malloc(): memory corruption: 0x085670d0 ***

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
LKML-Reference: <4ABB6EB7.7000002@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 tools/perf/util/module.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/util/module.c
+++ b/tools/perf/util/module.c
@@ -422,7 +422,7 @@ static int mod_dso__load_module_paths(st
 	len += strlen(uts.release);
 	len += strlen("/modules.dep");
 
-	path = calloc(1, len);
+	path = calloc(1, len + 1);
 	if (path == NULL)
 		goto out_failure;
 


