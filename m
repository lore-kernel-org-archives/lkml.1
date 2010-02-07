Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933668Ab0BGKzF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 05:55:05 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:64132 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab0BGKzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 05:55:03 -0500
Date: Sun, 7 Feb 2010 11:54:48 +0100
From: Heinz Diehl <htd@fancy-poultry.org>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       nhorman@tuxdriver.com, davem@davemloft.net
Subject: Re: [Bug #15196] kmem_cache_create: duplicate cache ccid2_h
Message-ID: <20100207105448.GA6623@fancy-poultry.org>
References: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera>
 <d3IDKWHT5gE.A.8sB.Q7hZLB@chimera>
 <7b6bb4a51001311930i7d72f60dj3b15ca3e1a715607@mail.gmail.com>
 <20100201150605.GA6175@fancy-poultry.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100201150605.GA6175@fancy-poultry.org>
X-Accept-Language: no,dk,se,en,de
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.20+20100131 (GNU/Linux)
X-Provags-ID: V01U2FsdGVkX195KVtCu3dB3rjkppLd+XFWu6swEHo770ea9d0
 t9aIbdR2NZss6kZ6+3gjQvqMwHGgI3D755jk1PGndvhp53keEF
 Z0N3Isa9kJ5MPO4Jjcj3g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.02.2010, Heinz Diehl wrote: 

[....]

Quoting myself here...

> The patch was completely malformed, don't know what happened on the way,
> but I applied it by hand. Yes, it fixes the problem for me.

Xiaotiangs patch quoted in the thread listed here (coming via kernel.org's
bugtracker)

 http://patchwork.kernel.org/patch/76023/
 
is missing some lines, and the patch attached at the end of the
thread is incomplete and malformed, as reported earlier. I guess this is
how it should have looked like (please correct me if I'm wrong):


--- /a/ccid.c	2010-02-06 23:17:12.000000000 +0100
+++ /b/ccid.c	2010-02-07 09:50:40.000000000 +0100
@@ -77,13 +77,13 @@
 	return err;
 }
 
-static struct kmem_cache *ccid_kmem_cache_create(int obj_size, char *slab_name_fmt, const char *fmt,...)
+static struct kmem_cache *ccid_kmem_cache_create(int obj_size, char *slab_name_fmt, int length, const char *fmt,...)
 {
 	struct kmem_cache *slab;
 	va_list args;
 
 	va_start(args, fmt);
-	vsnprintf(slab_name_fmt, sizeof(slab_name_fmt), fmt, args);
+	vsnprintf(slab_name_fmt, length, fmt, args);
 	va_end(args);
 
 	slab = kmem_cache_create(slab_name_fmt, sizeof(struct ccid) + obj_size, 0,
@@ -104,6 +104,7 @@
 	ccid_ops->ccid_hc_rx_slab =
 			ccid_kmem_cache_create(ccid_ops->ccid_hc_rx_obj_size,
 					       ccid_ops->ccid_hc_rx_slab_name,
+					       sizeof(ccid_ops->ccid_hc_rx_slab_name),
 					       "ccid%u_hc_rx_sock",
 					       ccid_ops->ccid_id);
 	if (ccid_ops->ccid_hc_rx_slab == NULL)
@@ -112,6 +113,7 @@
 	ccid_ops->ccid_hc_tx_slab =
 			ccid_kmem_cache_create(ccid_ops->ccid_hc_tx_obj_size,
 					       ccid_ops->ccid_hc_tx_slab_name,
+					       sizeof(ccid_ops->ccid_hc_tx_slab_name),
 					       "ccid%u_hc_tx_sock",
 					       ccid_ops->ccid_id);
 	if (ccid_ops->ccid_hc_tx_slab == NULL)

