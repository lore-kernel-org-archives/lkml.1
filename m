Return-Path: <linux-kernel-owner+w=401wt.eu-S1761150AbZEFUmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761150AbZEFUmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 16:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761146AbZEFUjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 16:39:11 -0400
Received: from kroah.org ([198.145.64.141]:33926 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761111AbZEFUjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 16:39:09 -0400
X-Mailbox-Line: From greg@blue.kroah.org Wed May  6 13:31:30 2009
Message-Id: <20090506203129.872556196@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 13:30:20 -0700
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
       alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 10/18] x86/PCI: dont call e820_all_mapped with -1 in the mmconfig case
References: <20090506203010.615363711@blue.kroah.org>
Content-Disposition: inline; filename=x86-pci-don-t-call-e820_all_mapped-with-1-in-the-mmconfig-case.patch
In-Reply-To: <20090506203353.GA14624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

commit 044cd80942e47b9de0915b627902adf05c52377f upstream.

e820_all_mapped need end is (addr + size) instead of (addr + size - 1)

Cc: stable@kernel.org
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/pci/mmconfig-shared.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -255,7 +255,7 @@ static acpi_status __init check_mcfg_res
 		if (!fixmem32)
 			return AE_OK;
 		if ((mcfg_res->start >= fixmem32->address) &&
-		    (mcfg_res->end < (fixmem32->address +
+		    (mcfg_res->end <= (fixmem32->address +
 				      fixmem32->address_length))) {
 			mcfg_res->flags = 1;
 			return AE_CTRL_TERMINATE;
@@ -272,7 +272,7 @@ static acpi_status __init check_mcfg_res
 		return AE_OK;
 
 	if ((mcfg_res->start >= address.minimum) &&
-	    (mcfg_res->end < (address.minimum + address.address_length))) {
+	    (mcfg_res->end <= (address.minimum + address.address_length))) {
 		mcfg_res->flags = 1;
 		return AE_CTRL_TERMINATE;
 	}
@@ -319,7 +319,7 @@ static int __init is_mmconf_reserved(che
 	u64 old_size = size;
 	int valid = 0;
 
-	while (!is_reserved(addr, addr + size - 1, E820_RESERVED)) {
+	while (!is_reserved(addr, addr + size, E820_RESERVED)) {
 		size >>= 1;
 		if (size < (16UL<<20))
 			break;


