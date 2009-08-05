Return-Path: <linux-kernel-owner+w=401wt.eu-S933027AbZHEBKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933027AbZHEBKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 21:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932959AbZHEBKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 21:10:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932946AbZHEBKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 21:10:21 -0400
Date: Tue, 4 Aug 2009 18:08:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: Albin Tonnerre <albin.tonnerre@free-electrons.com>, sam@ravnborg.org,
       hpa@zytor.com, linux@arm.linux.org.uk, alain@knaff.lu,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Subject: Re: [PATCH 1/6] lib/decompress_*: only include <linux/slab.h> if
 STATIC is not defined
Message-Id: <20090804180854.d5dbb07f.akpm@linux-foundation.org>
In-Reply-To: <4A78D6BD.3030003@lougher.demon.co.uk>
References: <20090731093107.GA29704@merkur.ravnborg.org>
	<1249311501-23102-1-git-send-email-albin.tonnerre@free-electrons.com>
	<20090804155500.db6c88fa.akpm@linux-foundation.org>
	<4A78D6BD.3030003@lougher.demon.co.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Aug 2009 01:47:57 +0100 Phillip Lougher <phillip@lougher.demon.co.uk> wrote:

> Andrew Morton wrote:
> > On Mon,  3 Aug 2009 16:58:16 +0200
> > Albin Tonnerre <albin.tonnerre@free-electrons.com> wrote:
> > 
> >> These includes were added by 079effb6933f34b9b1b67b08bd4fd7fb672d16ef to
> >> fix the build when using kmemtrace. However this is not necessary when
> >> used to create a compressed kernel, and actually creates issues (brings
> >> a lot of things unavailable in the decompression environment), so don't
> >> include it if STATIC is defined.
> >>
> > 
> > The description "actually creates issues (brings a lot of things
> > unavailable in the decompression environment)" is inadequate.  Please
> > describe te problem this patch fixes more completely so that others
> > (ie: me) can decide whether this patch is needed in 2.6.32, 2.6.31. 
> > 2.6.30, ...
> > 
> > 
> > This patch conflicts heavily with
> > 
> > http://userweb.kernel.org/~akpm/mmotm/broken-out/bzip2-lzma-remove-nasty-uncompressed-size-hack-in-pre-boot-environment.patch
> > 
> > 
> > What should we do about that?
> 
> 
> What do you normally do in this situation?

I normally fix the rejects ;)

But I'd like to confirm that the two patches don't fix the same thing
via different means.  Lacking a full description of Albin's "issues",
that's hard to determine.  They do appear to be unrelated.

>  I'm happy to send a revised
> bzip2-lzma-remove-nasty-uncompressed-size-hack-in-pre-boot-environment.patch
> that would apply cleanly on-top of Alvin's patch, but, this will obviously
> create dependencies on his patch being applied.

Reworked
lib-decompress_-only-include-linux-slabh-if-static-is-not-defined.patch:

 lib/decompress_bunzip2.c |    2 +-
 lib/decompress_inflate.c |    2 +-
 lib/decompress_unlzma.c  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/decompress_bunzip2.c~lib-decompress_-only-include-linux-slabh-if-static-is-not-defined lib/decompress_bunzip2.c
--- a/lib/decompress_bunzip2.c~lib-decompress_-only-include-linux-slabh-if-static-is-not-defined
+++ a/lib/decompress_bunzip2.c
@@ -49,10 +49,10 @@
 #define PREBOOT
 #else
 #include <linux/decompress/bunzip2.h>
+#include <linux/slab.h>
 #endif /* STATIC */
 
 #include <linux/decompress/mm.h>
-#include <linux/slab.h>
 
 #ifndef INT_MAX
 #define INT_MAX 0x7fffffff
diff -puN lib/decompress_inflate.c~lib-decompress_-only-include-linux-slabh-if-static-is-not-defined lib/decompress_inflate.c
--- a/lib/decompress_inflate.c~lib-decompress_-only-include-linux-slabh-if-static-is-not-defined
+++ a/lib/decompress_inflate.c
@@ -19,11 +19,11 @@
 #include "zlib_inflate/inflate.h"
 
 #include "zlib_inflate/infutil.h"
+#include <linux/slab.h>
 
 #endif /* STATIC */
 
 #include <linux/decompress/mm.h>
-#include <linux/slab.h>
 
 #define GZIP_IOBUF_SIZE (16*1024)
 
diff -puN lib/decompress_unlzma.c~lib-decompress_-only-include-linux-slabh-if-static-is-not-defined lib/decompress_unlzma.c
--- a/lib/decompress_unlzma.c~lib-decompress_-only-include-linux-slabh-if-static-is-not-defined
+++ a/lib/decompress_unlzma.c
@@ -33,10 +33,10 @@
 #define PREBOOT
 #else
 #include <linux/decompress/unlzma.h>
+#include <linux/slab.h>
 #endif /* STATIC */
 
 #include <linux/decompress/mm.h>
-#include <linux/slab.h>
 
 #define	MIN(a, b) (((a) < (b)) ? (a) : (b))
 
_

