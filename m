Return-Path: <linux-kernel-owner+w=401wt.eu-S1753556AbYKQWZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbYKQWZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 17:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbYKQWZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 17:25:12 -0500
Received: from ozlabs.org ([203.10.76.45]:52598 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823AbYKQWZL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 17:25:11 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: =?utf-8?q?J=C3=B6rn_Engel?= <joern@logfs.org>
Subject: Re: [PATCH 3/7] Improve alloc_percpu: expose percpu_modalloc and percpu_modfree
Date: Tue, 18 Nov 2008 08:54:52 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Christoph Lameter <cl@linux-foundation.org>
References: <20081117132630.AC29EDDDFF@ozlabs.org> <20081117134713.GA8949@logfs.org>
In-Reply-To: <20081117134713.GA8949@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200811180854.52492.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 November 2008 00:17:13 Jörn Engel wrote:
> On Mon, 17 November 2008 13:28:32 +0000, Rusty Russell wrote:
> > +static inline void *percpu_modalloc(unsigned long size, unsigned long align)
> > +{
> > +	return kzalloc(size);
> > +}
>
> You didn't test the patches much, did you? :)

No, not UP :)  I'd spent over four hours on them, so I figured it was time to
post them and get some concrete discussion.

Compiled and tested now, thanks!
Rusty.

cpualloc: Fixes for CONFIG_SMP=n

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 275b441d957b include/linux/percpu.h
--- a/include/linux/percpu.h	Mon Nov 17 23:42:27 2008 +1030
+++ b/include/linux/percpu.h	Tue Nov 18 08:52:05 2008 +1030
@@ -79,12 +79,16 @@
 #else
 static inline void *__alloc_percpu(unsigned long size, unsigned long align)
 {
-	return kzalloc(size);
+	return kzalloc(size, GFP_KERNEL);
 }
 
 static inline void free_percpu(void *pcpuptr)
 {
 	kfree(pcpuptr);
+}
+
+static inline void percpu_alloc_init(void)
+{
 }
 #endif /* CONFIG_SMP */
 

