Return-Path: <linux-kernel-owner+w=401wt.eu-S1763587AbZEFWTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763587AbZEFWTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761623AbZEFVzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:55:24 -0400
Received: from kroah.org ([198.145.64.141]:57488 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761572AbZEFVzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:55:10 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:48:03 2009
Message-Id: <20090506214803.260186241@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:46:25 -0700
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
       alan@lxorguk.ukuu.org.uk, Stuart Bennett <stuart@freedesktop.org>,
       Pekka Paalanen <pq@iki.fi>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 57/58] tracing: x86, mmiotrace: fix range test
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=tracing-x86-mmiotrace-fix-range-test.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stuart Bennett <stuart@freedesktop.org>

commit 33015c85995716d03f6293346cf05a1908b0fb9a upstream.

Matching on (addr == (p->addr + p->len)) causes problems when mappings
are adjacent.

[ Impact: fix mmiotrace confusion on adjacent iomaps ]

Signed-off-by: Stuart Bennett <stuart@freedesktop.org>
Acked-by: Pekka Paalanen <pq@iki.fi>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1240946271-7083-2-git-send-email-stuart@freedesktop.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/mm/kmmio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -87,7 +87,7 @@ static struct kmmio_probe *get_kmmio_pro
 {
 	struct kmmio_probe *p;
 	list_for_each_entry_rcu(p, &kmmio_probes, list) {
-		if (addr >= p->addr && addr <= (p->addr + p->len))
+		if (addr >= p->addr && addr < (p->addr + p->len))
 			return p;
 	}
 	return NULL;


