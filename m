Return-Path: <linux-kernel-owner+w=401wt.eu-S1757948AbZEVO6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948AbZEVO6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 10:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757073AbZEVO6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 10:58:44 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:45098 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754798AbZEVO6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 10:58:43 -0400
Date: Fri, 22 May 2009 10:17:15 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Pavel Machek <pavel@ucw.cz>
cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Ziljstra <a.p.ziljstra@chello.nl>,
       San Mehat <san@android.com>, Arve Hj?nnev?g <arve@android.com>,
       linux-kernel@vger.kernel.org
Subject: Warn when we run out of swap space (was Re: Misleading OOM
 messages)
In-Reply-To: <alpine.DEB.1.10.0905220942450.23842@qirst.com>
Message-ID: <alpine.DEB.1.10.0905221016340.23657@qirst.com>
References: <1242333519.15391.210.camel@nimitz> <alpine.DEB.2.00.0905141346030.28074@chino.kir.corp.google.com> <1242335120.15391.242.camel@nimitz> <alpine.DEB.1.10.0905141729180.30187@qirst.com> <20090514213403.GB14741@elf.ucw.cz> <1242337299.28440.47.camel@nimitz>
 <20090515130547.GA1976@elf.ucw.cz> <alpine.DEB.1.10.0905151358430.26559@qirst.com> <20090515200213.GA1406@ucw.cz> <alpine.DEB.1.10.0905151713230.26489@qirst.com> <20090519203944.GD1362@ucw.cz> <alpine.DEB.1.10.0905220942450.23842@qirst.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: Warn if we run out of swap space

Running out of swap space means that the evicton of anonymous pages may no longer
be possible which can lead to OOM conditions.

Print a warning when swap space first becomes exhausted.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 mm/swapfile.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/mm/swapfile.c
===================================================================
--- linux-2.6.orig/mm/swapfile.c	2009-05-22 09:07:40.000000000 -0500
+++ linux-2.6/mm/swapfile.c	2009-05-22 09:15:59.000000000 -0500
@@ -412,6 +412,7 @@ swp_entry_t get_swap_page(void)
 	nr_swap_pages++;
 noswap:
 	spin_unlock(&swap_lock);
+	WARN_ONCE(1, "All of swap is in use. Some pages cannot be swapped out.");
 	return (swp_entry_t) {0};
 }

