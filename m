Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759642AbYLQAFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759642AbYLQAFR (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 19:05:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756899AbYLQAEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 19:04:52 -0500
Received: from kroah.org ([198.145.64.141]:50990 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756111AbYLQAEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 19:04:51 -0500
Date: Tue, 16 Dec 2008 16:03:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
        Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
        Chris Wedgwood <reviews@ml.cw.f00f.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Chuck Ebbert <cebbert@redhat.com>,
        Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
        Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
        Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Joerg Roedel <joerg.roedel@amd.com>
Subject: [patch 01/22] AMD IOMMU: enable device isolation per default
Message-ID: <20081217000353.GB4504@kroah.com>
References: <20081216235704.347182084@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="amd-iommu-enable-device-isolation-per-default.patch"
In-Reply-To: <20081217000306.GA4504@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit 3ce1f93c6d53c3f91c3846cf66b018276c8ac2e7 upstream.

Impact: makes device isolation the default for AMD IOMMU

Some device drivers showed double-free bugs of DMA memory while testing
them with AMD IOMMU. If all devices share the same protection domain
this can lead to data corruption and data loss. Prevent this by putting
each device into its own protection domain per default.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/kernel-parameters.txt |    2 +-
 arch/x86/kernel/amd_iommu_init.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -120,7 +120,7 @@ u16 amd_iommu_last_bdf;			/* largest PCI
 LIST_HEAD(amd_iommu_unity_map);		/* a list of required unity mappings
 					   we find in ACPI */
 unsigned amd_iommu_aperture_order = 26; /* size of aperture in power of 2 */
-int amd_iommu_isolate;			/* if 1, device isolation is enabled */
+int amd_iommu_isolate = 1;		/* if 1, device isolation is enabled */
 
 LIST_HEAD(amd_iommu_list);		/* list of all AMD IOMMUs in the
 					   system */
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -283,7 +283,7 @@ and is between 256 and 4096 characters. 
 			Possible values are:
 			isolate - enable device isolation (each device, as far
 			          as possible, will get its own protection
-			          domain)
+			          domain) [default]
 	amd_iommu_size= [HW,X86-64]
 			Define the size of the aperture for the AMD IOMMU
 			driver. Possible values are:

