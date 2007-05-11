Return-Path: <linux-kernel-owner+w=401wt.eu-S934126AbXEKVPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934126AbXEKVPU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 17:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760637AbXEKVPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 17:15:10 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:48525 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760049AbXEKVPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 17:15:08 -0400
Date: Fri, 11 May 2007 23:16:04 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] kbuild: silence section mismatch warnings
Message-ID: <20070511211604.GB382@uranus.ravnborg.org>
References: <20070511210850.GA382@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070511210850.GA382@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new markers to avoid the warnings from init/main (arm + i386)
and mm/slab (all archs).

With this the noise level is dratiscally reduced.

	Sam

diff --git a/init/main.c b/init/main.c
index 1940fa7..1d8ea31 100644
--- a/init/main.c
+++ b/init/main.c
@@ -423,7 +423,7 @@ static void __init setup_command_line(char *command_line)
  * gcc-3.4 accidentally inlines this function, so use noinline.
  */
 
-static void noinline rest_init(void)
+static void __init_refok noinline rest_init(void)
 	__releases(kernel_lock)
 {
 	int pid;
diff --git a/mm/slab.c b/mm/slab.c
index 944b205..ef60834 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1960,7 +1960,7 @@ static void slab_destroy(struct kmem_cache *cachep, struct slab *slabp)
  * For setting up all the kmem_list3s for cache whose buffer_size is same as
  * size of kmem_list3.
  */
-static void __init set_up_list3s(struct kmem_cache *cachep, int index)
+static void __init_refok set_up_list3s(struct kmem_cache *cachep, int index)
 {
 	int node;
 
