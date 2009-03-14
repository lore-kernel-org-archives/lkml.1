Return-Path: <linux-kernel-owner+w=401wt.eu-S1756755AbZCNAnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbZCNAnL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753747AbZCNATn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:19:43 -0400
Received: from kroah.org ([198.145.64.141]:34906 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753801AbZCNATb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:19:31 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:49 2009
Message-Id: <20090314000749.643000432@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:06:18 -0700
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
       alan@lxorguk.ukuu.org.uk,
       Leann Ogasawara <leann.ogasawara@canonical.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       "manoj.iyer" <manoj.iyer@canonical.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 70/96] x86: add Dell XPS710 reboot quirk
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=x86-add-dell-xps710-reboot-quirk.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Leann Ogasawara <leann.ogasawara@canonical.com>

commit dd4124a8a06bca89c077a16437edac010f0bb993 upstream.

Dell XPS710 will hang on reboot.  This is resolved by adding a quirk to
set bios reboot.

Signed-off-by: Leann Ogasawara <leann.ogasawara@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Cc: "manoj.iyer" <manoj.iyer@canonical.com>
LKML-Reference: <1236196380.3231.89.camel@emiko>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/reboot.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -193,6 +193,14 @@ static struct dmi_system_id __initdata r
 			DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq"),
 		},
 	},
+	{	/* Handle problems with rebooting on Dell XPS710 */
+		.callback = set_bios_reboot,
+		.ident = "Dell XPS710",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Dell XPS710"),
+		},
+	},
 	{ }
 };
 


