Return-Path: <linux-kernel-owner+w=401wt.eu-S1764188AbZBNBdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764188AbZBNBdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:33:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764107AbZBNBQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:16:18 -0500
Received: from kroah.org ([198.145.64.141]:50297 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762598AbZBNBQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:16:12 -0500
Date: Fri, 13 Feb 2009 17:12:49 -0800
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
       alan@lxorguk.ukuu.org.uk, Kumar Gala <galak@kernel.crashing.org>
Subject: [patch 14/48] powerpc/fsl-booke: Fix mapping functions to use
	phys_addr_t
Message-ID: <20090214011249.GO17706@kroah.com>
References: <20090214010805.419403436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="powerpc-fsl-booke-fix-mapping-functions-to-use-phys_addr_t.patch"
In-Reply-To: <20090214011208.GA17706@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kumar Gala <galak@kernel.crashing.org>

commit 6c24b17453c8dc444a746e45b8a404498fc9fcf7 upstream.

Fixed v_mapped_by_tlbcam() and p_mapped_by_tlbcam() to use phys_addr_t
instead of unsigned long.  In 36-bit physical mode we really need these
functions to deal with phys_addr_t when trying to match a physical
address or when returning one.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/mm/fsl_booke_mmu.c |    4 ++--
 arch/powerpc/mm/pgtable_32.c    |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/powerpc/mm/fsl_booke_mmu.c
+++ b/arch/powerpc/mm/fsl_booke_mmu.c
@@ -80,7 +80,7 @@ extern unsigned int tlbcam_index;
 /*
  * Return PA for this VA if it is mapped by a CAM, or 0
  */
-unsigned long v_mapped_by_tlbcam(unsigned long va)
+phys_addr_t v_mapped_by_tlbcam(unsigned long va)
 {
 	int b;
 	for (b = 0; b < tlbcam_index; ++b)
@@ -92,7 +92,7 @@ unsigned long v_mapped_by_tlbcam(unsigne
 /*
  * Return VA for a given PA or 0 if not mapped
  */
-unsigned long p_mapped_by_tlbcam(unsigned long pa)
+unsigned long p_mapped_by_tlbcam(phys_addr_t pa)
 {
 	int b;
 	for (b = 0; b < tlbcam_index; ++b)
--- a/arch/powerpc/mm/pgtable_32.c
+++ b/arch/powerpc/mm/pgtable_32.c
@@ -65,8 +65,8 @@ void setbat(int index, unsigned long vir
 
 #ifdef HAVE_TLBCAM
 extern unsigned int tlbcam_index;
-extern unsigned long v_mapped_by_tlbcam(unsigned long va);
-extern unsigned long p_mapped_by_tlbcam(unsigned long pa);
+extern phys_addr_t v_mapped_by_tlbcam(unsigned long va);
+extern unsigned long p_mapped_by_tlbcam(phys_addr_t pa);
 #else /* !HAVE_TLBCAM */
 #define v_mapped_by_tlbcam(x)	(0UL)
 #define p_mapped_by_tlbcam(x)	(0UL)

