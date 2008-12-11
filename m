Return-Path: <linux-kernel-owner+w=401wt.eu-S1757981AbYLKT0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981AbYLKT0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:26:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757569AbYLKTS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:28 -0500
Received: from kroah.org ([198.145.64.141]:56005 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756040AbYLKTSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:18 -0500
Date: Thu, 11 Dec 2008 11:14:19 -0800
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
       Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: [patch 23/83] Input: i8042 - add Dell XPS M1530 to nomux list
Message-ID: <20081211191419.GW5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="input-i8042-add-dell-xps-m1530-to-nomux-list.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>

commit 786b11cc0f505e44c29f778fd329dafafafed76c upstream.

Dell XPS M1530 needs i8042.nomux=1 for ALPS touchpad to work as
reported on https://qa.mandriva.com/show_bug.cgi?id=43532

It is said that before A08 bios version this isn't needed (I don't
have the hardware so can't check), and suppose this will not break
with bios versions before A08.

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Tested-by: Andreas Ericsson <ae@op5.se>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/serio/i8042-x86ia64io.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -337,6 +337,13 @@ static struct dmi_system_id __initdata i
 			DMI_MATCH(DMI_PRODUCT_NAME, "2656"),
 		},
 	},
+	{
+		.ident = "Dell XPS M1530",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "XPS M1530"),
+		},
+	},
 	{ }
 };
 

