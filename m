Return-Path: <linux-kernel-owner+w=401wt.eu-S1756944AbYDWT2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944AbYDWT2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 15:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbYDWT2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 15:28:05 -0400
Received: from relay2.sgi.com ([192.48.171.30]:44295 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752920AbYDWT2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 15:28:03 -0400
Date: Wed, 23 Apr 2008 12:28:01 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jiri Slaby <jirislaby@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       paulmck@linux.vnet.ibm.com, David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org,
       herbert@gondor.apana.org.au
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at
 ffffffffffffffff
In-Reply-To: <Pine.LNX.4.64.0804232217290.5444@sbz-30.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.64.0804231225320.15401@schroedinger.engr.sgi.com>
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org>
  <480D1CF1.7010300@gmail.com> <480D208A.9050909@gmail.com> 
 <200804220254.45251.rjw@sisk.pl>  <alpine.LFD.1.10.0804211759030.2779@woody.linux-foundation.org>
  <480DB493.6080004@gmail.com> <20080422095315.GA28014@elte.hu> 
 <c4e36d110804221135v1dbfaf1bn4557052d1ead6060@mail.gmail.com> 
 <alpine.LFD.1.10.0804221144130.2779@woody.linux-foundation.org>
 <c4e36d110804230150n796c2733x5880b8e24ebc9da8@mail.gmail.com>
 <alpine.LFD.1.10.0804230746480.2779@woody.linux-foundation.org>
 <480F857A.3090503@cs.helsinki.fi> <Pine.LNX.4.64.0804231202250.15173@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0804232217290.5444@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Or simpler (catching yet another case):

Subject: slab_err: Pass parameters correctly to slab_bug

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/slub.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2008-04-23 12:24:02.000000000 -0700
+++ linux-2.6/mm/slub.c	2008-04-23 12:27:03.000000000 -0700
@@ -521,7 +521,7 @@ static void print_trailer(struct kmem_ca
 static void object_err(struct kmem_cache *s, struct page *page,
 			u8 *object, char *reason)
 {
-	slab_bug(s, reason);
+	slab_bug(s, "%s", reason);
 	print_trailer(s, page, object);
 }
 
@@ -533,7 +533,7 @@ static void slab_err(struct kmem_cache *
 	va_start(args, fmt);
 	vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
-	slab_bug(s, fmt);
+	slab_bug(s, "%s", buf);
 	print_page_info(page);
 	dump_stack();
 }
