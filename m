Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbZFCRth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbZFCRth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 13:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbZFCRta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 13:49:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46273 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbZFCRt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 13:49:29 -0400
Date: Wed, 3 Jun 2009 14:49:21 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH tip 1/1] perf_counter tools: Fix off-by-one bug in
	symbol__new
Message-ID: <20090603174921.GG7805@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://oops.ghostprotocols.net:81/blog
Impact: bugfix
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The end is really (start + len - 1). Noticed when synthesizing the PLT
symbols, that are small (16 bytes), and hot on the start RIP.
    
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/Documentation/perf_counter/util/symbol.c b/Documentation/perf_counter/util/symbol.c
index d52a1ae..35ee6de 100644
--- a/Documentation/perf_counter/util/symbol.c
+++ b/Documentation/perf_counter/util/symbol.c
@@ -19,7 +19,7 @@ static struct symbol *symbol__new(uint64_t start, uint64_t len,
 			self = ((void *)self) + priv_size;
 		}
 		self->start = start;
-		self->end   = start + len;
+		self->end   = start + len - 1;
 		memcpy(self->name, name, namelen);
 	}
 
