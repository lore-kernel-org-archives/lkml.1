Return-Path: <linux-kernel-owner+w=401wt.eu-S1756125AbZBVOVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125AbZBVOVb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 09:21:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbZBVOVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 09:21:22 -0500
Received: from ti-out-0910.google.com ([209.85.142.190]:23714 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbZBVOVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 09:21:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=fP6SZvyYMC2LRUjuDfSgkb1mjUIIc7JnFO1znw17a0TJi2h9VZcF+Jx/MyCvMNdSrH
         rMlxQyUd1BaBCdYB0clNvjvNzAa1WTUQdCPyj8wjlW2OxDiNg2uGrDvqB1uGf2Tsy0D6
         1rA/4R7Fe2TrXSTedjohu3ht7+yxYnI0fBZS8=
Date: Sun, 22 Feb 2009 23:21:14 +0900
From: Hitoshi Mitake <h.mitake@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>, davem@davemloft.net
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       "Luck, Tony" <tony.luck@intel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Ralf Baechle <ralf@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Doug Thompson <norsk5@yahoo.com>, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/1] edac x38: new MC driver module
Message-Id: <20090222232114.803fe032.h.mitake@gmail.com>
In-Reply-To: <20090221130937.GA31562@uranus.ravnborg.org>
References: <20081129180144.GA15533@uranus.ravnborg.org>
	<20081130171604.dc3c8715.h.mitake@gmail.com>
	<20081130083700.GA31644@elte.hu>
	<20081130092407.GA10802@elte.hu>
	<20081201002056.d9f9204c.h.mitake@gmail.com>
	<20081130161504.GA25627@elte.hu>
	<a6b9f31a0812010551h28c0841fxa2a26af4645df64@mail.gmail.com>
	<20081201135922.GA30068@elte.hu>
	<a6b9f31a0812011558o373edbd3r9690efe539d43ca0@mail.gmail.com>
	<20090221191101.62945118.h.mitake@gmail.com>
	<20090221130937.GA31562@uranus.ravnborg.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Feb 2009 14:09:37 +0100
Sam Ravnborg <sam@ravnborg.org> wrote:

> > Hi,
> > 
> > Very sorry for long distance between my previous post and this...
> > 
> > I wrote a patch to add HAVE_READQ and HAVE_WRITEQ to each architecture's Kconfig file
> > which have readq() and writeq().
> > 
> > But there is problem.
> > I wrote helps for HAVE_READQ and HAVE_WRITEQ in Kconfig file
> > accodring to the advice by Russell King ( http://marc.info/?l=linux-kernel&m=122701161824218&w=2 ),
> > but these helps are invisible when I doing menuconfig.
> > (when type '/' and search readq string, HAVE_READQ found, but
> > help string is not printed...)
> > 
> > Do you have some nice technique that make these helps visible easily?
> 
> The options are not visible in menuconfig and therefore the is not
> much point in displaying help for them thre when you search for the symbol.
> But the help contained in the KConfig file is fully justified as it is
> now documented why/when to select these options.
> 
> 	Sam

description of the patch: Adding HAVE_READQ, HAVE_WRITEQ and their help texts
to each architecture's Kconfig file which have readq() and writeq().

Signed-off-by: Hitoshi Mitake <h.mitake@gmail.com>

---
 arch/sparc/Kconfig |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index c3ea215..eb5efa3 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -527,3 +527,23 @@ source "security/Kconfig"
 source "crypto/Kconfig"
 
 source "lib/Kconfig"
+
+config HAVE_READQ
+	def_bool y
+	depends on SPARC64
+	help
+	  This is a sign to represent that this architecture provides
+	  readq() function. readq() is a function to read 8 bytes from
+	  I/O space. Each drivers use readq() must depend on this symbol.
+	  Because lots of little private readq() implementations
+	  all over the tree is sucks.
+
+config HAVE_WRITEQ
+	def_bool y
+	depends on SPARC64
+	help
+	  This is a sign to represent that this architecture provides
+	  writeq() function. writeq() is a function to read 8 bytes from
+	  I/O space. Each drivers use writeq() must depend on this symbol.
+	  Because lots of little private writeq() implementations
+	  all over the tree is sucks.
-- 
1.6.1.2

