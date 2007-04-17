Return-Path: <linux-kernel-owner+w=401wt.eu-S1754063AbXDQACE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbXDQACE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 20:02:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbXDQACE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 20:02:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063AbXDQACC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 20:02:02 -0400
Message-ID: <46240E74.5030607@redhat.com>
Date: Mon, 16 Apr 2007 20:01:56 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21-rc7
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Since we're still waiting for resolution for some regressions that people 
> weren't able to work on last week, there's a new -rc kernel out there. 
> Hopefully we'll get them all and I can do 2.6.21-final next weekend or 
> so..
> 

The patch to k8.c didn't make it in:

cache_k8_northbridges() is storing config values to incorrect locations
(in flush_words) and also its overflowing beyond the allocation, causing
slab verification failures.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
---
 arch/x86_64/kernel/k8.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.21-rc6/arch/x86_64/kernel/k8.c
===================================================================
--- linux-2.6.21-rc6.orig/arch/x86_64/kernel/k8.c	2007-04-05 19:36:56.000000000 -0700
+++ linux-2.6.21-rc6/arch/x86_64/kernel/k8.c	2007-04-13 07:51:57.000000000 -0700
@@ -61,8 +61,8 @@ int cache_k8_northbridges(void)
 	dev = NULL;
 	i = 0;
 	while ((dev = next_k8_northbridge(dev)) != NULL) {
-		k8_northbridges[i++] = dev;
-		pci_read_config_dword(dev, 0x9c, &flush_words[i]);
+		k8_northbridges[i] = dev;
+		pci_read_config_dword(dev, 0x9c, &flush_words[i++]);
 	}
 	k8_northbridges[i] = NULL;
 	return 0;




