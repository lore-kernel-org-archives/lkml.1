Return-Path: <linux-kernel-owner+w=401wt.eu-S1756334AbYLCT7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334AbYLCT7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 14:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbYLCTul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:50:41 -0500
Received: from kroah.org ([198.145.64.141]:59676 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754682AbYLCTuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:50:32 -0500
Date: Wed, 3 Dec 2008 11:49:10 -0800
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
       alan@lxorguk.ukuu.org.uk, Philipp Kohlbecher <xt28@gmx.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 023/104] x86: more general identifier for Phoenix BIOS
Message-ID: <20081203194910.GX8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-more-general-identifier-for-phoenix-bios.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Philipp Kohlbecher <xt28@gmx.de>

commit 0af40a4b1050c050e62eb1dc30b82d5ab22bf221 upstream.

Impact: widen the reach of the low-memory-protect DMI quirk

Phoenix BIOSes variously identify their vendor as "Phoenix Technologies,
LTD" or "Phoenix Technologies LTD" (without the comma.)

This patch makes the identification string in the bad_bios_dmi_table
more general (following a suggestion by Ingo Molnar), so that both
versions are handled.

Again, the patched file compiles cleanly and the patch has been tested
successfully on my machine.

Signed-off-by: Philipp Kohlbecher <xt28@gmx.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -604,7 +604,7 @@ static struct dmi_system_id __initdata b
 		.callback = dmi_low_memory_corruption,
 		.ident = "Phoenix BIOS",
 		.matches = {
-			DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies, LTD"),
+			DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies"),
 		},
 	},
 #endif

