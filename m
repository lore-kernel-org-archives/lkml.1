Return-Path: <linux-kernel-owner+w=401wt.eu-S1756571AbYIGWZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbYIGWZe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 18:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755860AbYIGWYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 18:24:17 -0400
Received: from gw.goop.org ([64.81.55.164]:39661 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754391AbYIGWYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 18:24:14 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 4 of 7] x86: use early_memremap() in setup.c
X-Mercurial-Node: 15fd328b5bfcad8b58ebd2dc40718242ab0ba95f
Message-Id: <15fd328b5bfcad8b58eb.1220826076@localhost>
In-Reply-To: <patchbomb.1220826072@localhost>
Date: Sun, 07 Sep 2008 15:21:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Xen Devel <xen-devel@lists.xensource.com>,
       Andi Kleen <andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The remappings in setup.c are all just ordinary memory, so use
early_memremap() rather than early_ioremap().

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/setup.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -302,7 +302,7 @@
 		if (clen > MAX_MAP_CHUNK-slop)
 			clen = MAX_MAP_CHUNK-slop;
 		mapaddr = ramdisk_image & PAGE_MASK;
-		p = early_ioremap(mapaddr, clen+slop);
+		p = early_memremap(mapaddr, clen+slop);
 		memcpy(q, p+slop, clen);
 		early_iounmap(p, clen+slop);
 		q += clen;
@@ -379,7 +379,7 @@
 		return;
 	pa_data = boot_params.hdr.setup_data;
 	while (pa_data) {
-		data = early_ioremap(pa_data, PAGE_SIZE);
+		data = early_memremap(pa_data, PAGE_SIZE);
 		switch (data->type) {
 		case SETUP_E820_EXT:
 			parse_e820_ext(data, pa_data);
@@ -402,7 +402,7 @@
 		return;
 	pa_data = boot_params.hdr.setup_data;
 	while (pa_data) {
-		data = early_ioremap(pa_data, sizeof(*data));
+		data = early_memremap(pa_data, sizeof(*data));
 		e820_update_range(pa_data, sizeof(*data)+data->len,
 			 E820_RAM, E820_RESERVED_KERN);
 		found = 1;
@@ -428,7 +428,7 @@
 		return;
 	pa_data = boot_params.hdr.setup_data;
 	while (pa_data) {
-		data = early_ioremap(pa_data, sizeof(*data));
+		data = early_memremap(pa_data, sizeof(*data));
 		sprintf(buf, "setup data %x", data->type);
 		reserve_early(pa_data, pa_data+sizeof(*data)+data->len, buf);
 		pa_data = data->next;


