Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbZLNHYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbZLNHYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 02:24:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754690AbZLNHYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 02:24:06 -0500
Received: from mail.perches.com ([173.55.12.10]:1165 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754637AbZLNHYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 02:24:05 -0500
Subject: Re: linux-next: origin tree build warning
From: Joe Perches <joe@perches.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20091214102415.10bdcf24.sfr@canb.auug.org.au>
References: <20091214102415.10bdcf24.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Dec 2009 23:24:03 -0800
Message-ID: <1260775443.18538.16.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-14 at 10:24 +1100, Stephen Rothwell wrote:
> Today's linux-next build (x86_64 allmodconfig) produced this warning:
> 
> arch/x86/mm/mmio-mod.c: In function 'print_pte':
> Caused by commit 3a0340be06a9356eb61f6804107480acbe62c069 ("x86:
> mmio-mod.c: Use pr_fmt").  Was this even build tested?  The patch doesn't
> even match the commit message.

Dunno how that happened, it was tested here
with #define pr_fmt(fmt) "mmiotrace: " fmt

Here's the diff necessary to make it work.

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index 4c765e9..34a3291 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -20,7 +20,7 @@
  * Derived from the read-mod example from relay-examples by Tom Zanussi.
  */
 
-#define pr_fmt(fmt) "mmiotrace: "
+#define pr_fmt(fmt) "mmiotrace: " fmt
 
 #define DEBUG 1
 


