Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980AbXC3VKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbXC3VKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbXC3VJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:09:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58215 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbXC3VJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:09:41 -0400
Date: Fri, 30 Mar 2007 14:04:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Andrew Morton <akpm@osdl.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, JC.LAFOUCRIERE@CEA.FR,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Jeff Dike <jdike@linux.intel.com>
Subject: [patch 06/37] UML - Fix static linking
Message-ID: <20070330210412.GH29450@kroah.com>
References: <20070330205938.984247529@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="uml-fix-static-linking.patch"
In-Reply-To: <20070330210334.GA29450@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-MIME-Error: demime acl condition: uuencoded line length is not a multiple of 4 characters
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jeff Dike <jdike@addtoit.com>

During a static link, ld has started putting a .note section in the
.uml.setup.init section.  This has the result that the UML setups
begin with 32 bytes of garbage and UML crashes immediately on boot.

This patch creates a specific .note section for ld to drop this stuff
into.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/asm-um/common.lds.S |    1 +
 1 file changed, 1 insertion(+)

--- a/include/asm-um/common.lds.S
+++ b/include/asm-um/common.lds.S
@@ -15,6 +15,7 @@
   PROVIDE (_unprotected_end = .);
 
   . = ALIGN(4096);
+  .note : { *(note.*) }
   __start___ex_table = .;
   __ex_table : { *(__ex_table) }
   __stop___ex_table = .;

-- 
