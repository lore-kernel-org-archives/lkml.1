Return-Path: <linux-kernel-owner+w=401wt.eu-S1759605AbZCTXNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759605AbZCTXNv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbZCTXNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:13:34 -0400
Received: from kroah.org ([198.145.64.141]:52971 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753762AbZCTXNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:13:33 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:27:09 2009
Message-Id: <20090320222709.094312386@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:26:12 -0700
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
       alan@lxorguk.ukuu.org.uk, Tony Luck <tony.luck@intel.com>
Subject: [patch 01/32] [IA64] Build fix for __early_pfn_to_nid() undefined link error
References: <20090320222611.872315885@mini.kroah.org>
Content-Disposition: inline; filename=build-fix-for-__early_pfn_to_nid-undefined-link-error.patch
In-Reply-To: <20090320231037.GA2732@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tony Luck <tony.luck@intel.com>

commit 334f85b647bc46ff4d27ace55aa65f44d6a2f4db upstream.

ia64 only defines __early_pfn_to_nid() for SPARSEMEM && NUMA configurations,
so the recent:

	commit: f2dbcfa738368c8a40d4a5f0b65dc9879577cb21
	mm: clean up for early_pfn_to_nid()

ends up with some link problems for certain configuration files.

Fix arch/ia64/Kconfig to only define HAVE_ARCH_EARLY_PFN_TO_NID in the
cases where we do provide this function.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/ia64/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -444,8 +444,7 @@ config HOLES_IN_ZONE
 	default y if VIRTUAL_MEM_MAP
 
 config HAVE_ARCH_EARLY_PFN_TO_NID
-	def_bool y
-	depends on NEED_MULTIPLE_NODES
+	def_bool NUMA && SPARSEMEM
 
 config HAVE_ARCH_NODEDATA_EXTENSION
 	def_bool y


