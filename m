Return-Path: <linux-kernel-owner+w=401wt.eu-S1756107AbYJXEoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbYJXEoN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 00:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbYJXEjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 00:39:25 -0400
Received: from kroah.org ([198.145.64.141]:51768 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751867AbYJXEjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 00:39:17 -0400
Date: Thu, 23 Oct 2008 21:34:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, iommu@lists.linux-foundation.org,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Joerg Roedel <joerg.roedel@amd.com>,
       David Woodhouse <David.Woodhouse@intel.com>
Subject: [patch 13/27] amd_iommu: fix nasty bug that caused
	ILLEGAL_DEVICE_TABLE_ENTRY errors
Message-ID: <20081024043430.GN30828@kroah.com>
References: <20081024042023.054190751@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="amd_iommu-fix-nasty-bug-that-caused-illegal_device_table_entry-errors.patch"
In-Reply-To: <20081024043303.GA30828@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Andreas Herrmann <andreas.herrmann3@amd.com>

commit f609891f428e1c20e270e7c350daf8c93cc459d7 upstream

We are on 64-bit so better use u64 instead of u32 to deal with
addresses:

static void __init iommu_set_device_table(struct amd_iommu *iommu)
{
        u64 entry;
  ...
        entry = virt_to_phys(amd_iommu_dev_table);
  ...

(I am wondering why gcc 4.2.x did not warn about the assignment
between u32 and unsigned long.)

Cc: iommu@lists.linux-foundation.org
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/amd_iommu_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -210,7 +210,7 @@ static void __init iommu_set_exclusion_r
 /* Programs the physical address of the device table into the IOMMU hardware */
 static void __init iommu_set_device_table(struct amd_iommu *iommu)
 {
-	u32 entry;
+	u64 entry;
 
 	BUG_ON(iommu->mmio_base == NULL);
 

-- 
