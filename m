Return-Path: <linux-kernel-owner+w=401wt.eu-S1757858AbYHRTnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858AbYHRTnZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932643AbYHRTjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:39:31 -0400
Received: from mail.suse.de ([195.135.220.2]:49269 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758989AbYHRTj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:39:28 -0400
Date: Mon, 18 Aug 2008 12:20:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Gabriel C <nix.or.die@googlemail.com>,
       Jeff Dike <jdike@linux.intel.com>
Subject: [patch 35/49] uml: memcpy export needs to follow host declaration
Message-ID: <20080818192034.GJ10350@suse.de>
References: <20080818191012.663450219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="uml-memcpy-export-needs-to-follow-host-declaration.patch"
In-Reply-To: <20080818191834.GA10350@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Dike <jdike@addtoit.com>

commit 8bfd04b974689f700bbd053ad6e66b0a95fb80c9 upstream

x86_64 defines either memcpy or __memcpy depending on the gcc version, and
it looks like UML needs to follow that in its exporting.

Cc: Gabriel C <nix.or.die@googlemail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/um/sys-x86_64/ksyms.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/um/sys-x86_64/ksyms.c
+++ b/arch/um/sys-x86_64/ksyms.c
@@ -13,5 +13,9 @@ EXPORT_SYMBOL(__down_failed_trylock);
 EXPORT_SYMBOL(__up_wakeup);
 
 /*XXX: we need them because they would be exported by x86_64 */
+#if (__GNUC__ == 4 && __GNUC_MINOR__ >= 3) || __GNUC__ > 4
+EXPORT_SYMBOL(memcpy);
+#else
 EXPORT_SYMBOL(__memcpy);
+#endif
 EXPORT_SYMBOL(csum_partial);

-- 
