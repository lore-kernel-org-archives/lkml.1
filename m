Return-Path: <linux-kernel-owner+w=401wt.eu-S1760016AbXE3WDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760016AbXE3WDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757003AbXE3WDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:03:13 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53968 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756967AbXE3WDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:03:12 -0400
Date: Wed, 30 May 2007 15:03:11 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3 -mm] slub: use lib/hexdump
In-Reply-To: <465DF2A2.2070801@oracle.com>
Message-ID: <Pine.LNX.4.64.0705301501470.7502@schroedinger.engr.sgi.com>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
 <4654AC94.6080601@googlemail.com> <20070523150122.f9946f37.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705231526350.22666@schroedinger.engr.sgi.com>
 <20070523153730.e0e9e91d.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705231635370.23144@schroedinger.engr.sgi.com>
 <20070523182145.7d7f1f7e.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0705232000140.24066@schroedinger.engr.sgi.com>
 <20070524073131.GA17501@elte.hu> <Pine.LNX.4.64.0705241418270.31613@schroedinger.engr.sgi.com>
 <20070524142908.f39f42ea.akpm@linux-foundation.org>
 <20070524145517.1f32cd94.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0705241533510.32401@schroedinger.engr.sgi.com>
 <20070530143451.f4a844bc.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0705301443020.3358@schroedinger.engr.sgi.com>
 <465DF135.80202@oracle.com> <Pine.LNX.4.64.0705301451140.3709@schroedinger.engr.sgi.c!
  om> <465DF2A2.2070801@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'd prefer something like this:

Use hexdump in slub.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: slub/mm/slub.c
===================================================================
--- slub.orig/mm/slub.c	2007-05-30 14:56:14.000000000 -0700
+++ slub/mm/slub.c	2007-05-30 15:01:33.000000000 -0700
@@ -339,34 +339,10 @@ static char *slub_debug_slabs;
  */
 static void print_section(char *text, u8 *addr, unsigned int length)
 {
-	int i, offset;
-	int newline = 1;
-	char ascii[17];
-
-	ascii[16] = 0;
-
-	for (i = 0; i < length; i++) {
-		if (newline) {
-			printk(KERN_ERR "%8s 0x%p: ", text, addr + i);
-			newline = 0;
-		}
-		printk(" %02x", addr[i]);
-		offset = i % 16;
-		ascii[offset] = isgraph(addr[i]) ? addr[i] : '.';
-		if (offset == 15) {
-			printk(" %s\n",ascii);
-			newline = 1;
-		}
-	}
-	if (!newline) {
-		i %= 16;
-		while (i < 16) {
-			printk("   ");
-			ascii[i] = ' ';
-			i++;
-		}
-		printk(" %s\n", ascii);
-	}
+	char buf[10];
+
+	sprintf(buf, "%8s:", text);
+	print_hex_dump(KERN_ERR, buf, DUMP_PREFIX_ADDRESS, 16, 1, addr, length, 1);
 }
 
 static struct track *get_track(struct kmem_cache *s, void *object,

