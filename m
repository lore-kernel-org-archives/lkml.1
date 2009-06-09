Return-Path: <linux-kernel-owner+w=401wt.eu-S1762022AbZFIKas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762022AbZFIKas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932083AbZFIKUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:20:40 -0400
Received: from kroah.org ([198.145.64.141]:55186 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932069AbZFIKUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:20:38 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:41:05 2009
Message-Id: <20090609094105.199044910@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:44 -0700
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
       alan@lxorguk.ukuu.org.uk, Stephen Rothwell <sfr@canb.auug.org.au>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Kumar Gala <galak@kernel.crashing.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 56/87] powerpc: fix for long standing bug noticed by gcc 4.4.0
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=powerpc-fix-for-long-standing-bug-noticed-by-gcc-4.4.0.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stephen Rothwell <sfr@canb.auug.org.au>

commit b62c31ae401c6df25c61b206681a6e904ef97169 upstream.

Previous gcc versions didn't notice this because one of the preceding
#ifs always evaluated to true.

gcc 4.4.0 produced this error:

arch/powerpc/mm/tlb_nohash_low.S:206:6: error: #elif with no expression

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/arch/powerpc/mm/tlb_nohash_low.S
+++ b/arch/powerpc/mm/tlb_nohash_low.S
@@ -191,6 +191,6 @@ ALT_MMU_FTR_SECTION_END_IFCLR(MMU_FTR_USE_TLBILX)
 	isync
 1:	wrtee	r10
 	blr
-#elif
+#else
 #error Unsupported processor type !
 #endif


