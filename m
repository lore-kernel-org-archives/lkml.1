Return-Path: <linux-kernel-owner+w=401wt.eu-S934652AbZAOWLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934652AbZAOWLd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:11:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933582AbZAOWCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:02:11 -0500
Received: from kroah.org ([198.145.64.141]:38212 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932114AbZAOWCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:02:05 -0500
Date: Thu, 15 Jan 2009 13:59:28 -0800
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
       alan@lxorguk.ukuu.org.uk, Joerg Roedel <joerg.roedel@amd.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 17/85] x86: default to SWIOTLB=y on x86_64
Message-ID: <20090115215928.GR17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-default-to-swiotlb-y-on-x86_64.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit a1afd01c175324656d0e8f1c82ea94b474953c04 upstream.

Impact: fixes korg bugzilla 11980

A kernel for a 64bit x86 system should always contain the swiotlb code
in case it is booted on a machine without any hardware IOMMU supported
by the kernel and more than 4GB of RAM. This patch changes Kconfig to
always compile swiotlb into the kernel for x86_64.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -567,7 +567,7 @@ config AMD_IOMMU
 
 # need this always selected by IOMMU for the VIA workaround
 config SWIOTLB
-	bool
+	def_bool y if X86_64
 	help
 	  Support for software bounce buffers used on x86-64 systems
 	  which don't have a hardware IOMMU (e.g. the current generation

