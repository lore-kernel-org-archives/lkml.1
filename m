Return-Path: <linux-kernel-owner+w=401wt.eu-S1754890AbXDZRDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbXDZRDg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754896AbXDZRBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:01:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39767 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895AbXDZRBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:01:33 -0400
Date: Thu, 26 Apr 2007 09:57:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Wang Zhenyu <zhenyu.z.wang@intel.com>
Subject: [patch 31/33] AGPGART: intel_agp: fix G965 GTT size detect
Message-ID: <20070426165715.GF1898@kroah.com>
References: <20070426165111.393445007@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="agpgart-intel_agp-fix-g965-gtt-size-detect.patch"
In-Reply-To: <20070426165445.GA1898@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Wang Zhenyu <zhenyu.z.wang@intel.com>

[AGPGART] intel_agp: fix G965 GTT size detect

On G965, I810_PGETBL_CTL is a mmio offset, but we wrongly take it
as pci config space offset in detecting GTT size. This one line patch
fixs this.

Signed-off-by: Wang Zhenyu <zhenyu.z.wang@intel.com>
Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/agp/intel-agp.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -405,9 +405,8 @@ static void intel_i830_init_gtt_entries(
 
 	if (IS_I965) {
 		u32 pgetbl_ctl;
+		pgetbl_ctl = readl(intel_i830_private.registers+I810_PGETBL_CTL);
 
-		pci_read_config_dword(agp_bridge->dev, I810_PGETBL_CTL,
-				      &pgetbl_ctl);
 		/* The 965 has a field telling us the size of the GTT,
 		 * which may be larger than what is necessary to map the
 		 * aperture.

-- 
