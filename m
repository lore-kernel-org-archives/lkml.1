Return-Path: <linux-kernel-owner+w=401wt.eu-S1757111AbYJFXYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111AbYJFXYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 19:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756804AbYJFXVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 19:21:54 -0400
Received: from mx1.suse.de ([195.135.220.2]:40812 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756797AbYJFXVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 19:21:53 -0400
Date: Mon, 6 Oct 2008 16:17:15 -0700
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
       alan@lxorguk.ukuu.org.uk, "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 08/28] x86: add io delay quirk for Presario F700
Message-ID: <20081006231715.GI20567@suse.de>
References: <20081006225949.357365087@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-add-io-delay-quirk-for-presario-f700.patch"
In-Reply-To: <20081006231639.GA20567@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Chuck Ebbert <cebbert@redhat.com>

commit e6a5652fd156a286faadbf7a4062b5354d4e346e upstream

Manually adding "io_delay=0xed" fixes system lockups in ioapic
mode on this machine.

System Information
	Manufacturer: Hewlett-Packard
	Product Name: Presario F700 (KA695EA#ABF)

Base Board Information
	Manufacturer: Quanta
	Product Name: 30D3

Reference:
https://bugzilla.redhat.com/show_bug.cgi?id=459546

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/io_delay.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/x86/kernel/io_delay.c
+++ b/arch/x86/kernel/io_delay.c
@@ -92,6 +92,14 @@ static struct dmi_system_id __initdata i
 			DMI_MATCH(DMI_BOARD_NAME, "30BF")
 		}
 	},
+	{
+		.callback	= dmi_io_delay_0xed_port,
+		.ident		= "Presario F700",
+		.matches	= {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Quanta"),
+			DMI_MATCH(DMI_BOARD_NAME, "30D3")
+		}
+	},
 	{ }
 };
 

-- 
