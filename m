Return-Path: <linux-kernel-owner+w=401wt.eu-S1752484AbYGaALC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbYGaALC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:11:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760883AbYGaAKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:10:07 -0400
Received: from ns1.suse.de ([195.135.220.2]:38337 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757685AbYGaAKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:10:05 -0400
Date: Wed, 30 Jul 2008 16:58:26 -0700
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
       alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@elte.hu>
Subject: [patch 18/62] x86 reboot quirks: add Dell Precision WorkStation
	T5400
Message-ID: <20080730235826.GR12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-reboot-quirks-add-dell-precision-workstation-t5400.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Ingo Molnar <mingo@elte.hu>

commit fab3b58d3b242b5903f78d60d86803a8aecdf6de upstream

as reported in:

  "reboot=bios is mandatory on Dell T5400 server."
  http://bugzilla.kernel.org/show_bug.cgi?id=11108

add a DMI reboot quirk.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/reboot.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -177,6 +177,14 @@ static struct dmi_system_id __initdata r
 			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge 2400"),
 		},
 	},
+	{	/* Handle problems with rebooting on Dell T5400's */
+		.callback = set_bios_reboot,
+		.ident = "Dell Precision T5400",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Precision WorkStation T5400"),
+		},
+	},
 	{	/* Handle problems with rebooting on HP laptops */
 		.callback = set_bios_reboot,
 		.ident = "HP Compaq Laptop",

-- 
