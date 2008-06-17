Return-Path: <linux-kernel-owner+w=401wt.eu-S1760720AbYFQWcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760720AbYFQWcp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 18:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759731AbYFQWbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 18:31:43 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:46783 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759582AbYFQWbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 18:31:42 -0400
Date: Wed, 18 Jun 2008 01:30:15 +0300
From: Adrian Bunk <bunk@kernel.org>
To: adaplas@gmail.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] video/console/stico{n,re}.c: make code static
Message-ID: <20080617223015.GF25911@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following needlessly global code static:
- sticon.c: sticonsole_init()
- sticore.c: struct default_sti
- sticore.c: sti_init_graph()
- sticore.c: sti_inq_conf()
- sticore.c: sti_rom_copy()
- sticore.c: sti_select_fbfont()
- sticore.c: sti_select_font()
- sticore.c: sti_get_wmode_rom()
- sticore.c: sti_read_rom()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/video/console/sticon.c  |    2 -
 drivers/video/console/sticore.c |   33 ++++++++++++++------------------
 drivers/video/sticore.h         |    2 -
 3 files changed, 16 insertions(+), 21 deletions(-)

a8719188c2fe2fd9e773d8bd580d75fd7f98b5d8 diff --git a/drivers/video/console/sticon.c b/drivers/video/console/sticon.c
index a11cc2f..4055dbd 100644
--- a/drivers/video/console/sticon.c
+++ b/drivers/video/console/sticon.c
@@ -370,7 +370,7 @@ static const struct consw sti_con = {
 
 
 
-int __init sticonsole_init(void)
+static int __init sticonsole_init(void)
 {
     /* already initialized ? */
     if (sticon_sti)
diff --git a/drivers/video/console/sticore.c b/drivers/video/console/sticore.c
index e9ab657..5bec134 100644
--- a/drivers/video/console/sticore.c
+++ b/drivers/video/console/sticore.c
@@ -29,7 +29,7 @@
 
 #define STI_DRIVERVERSION "Version 0.9a"
 
-struct sti_struct *default_sti __read_mostly;
+static struct sti_struct *default_sti __read_mostly;
 
 /* number of STI ROMS found and their ptrs to each struct */
 static int num_sti_roms __read_mostly;
@@ -68,8 +68,7 @@ static const struct sti_init_flags default_init_flags = {
 	.init_cmap_tx = 1,
 };
 
-int
-sti_init_graph(struct sti_struct *sti) 
+static int sti_init_graph(struct sti_struct *sti) 
 {
 	struct sti_init_inptr_ext inptr_ext = { 0, };
 	struct sti_init_inptr inptr = {
@@ -100,8 +99,7 @@ static const struct sti_conf_flags default_conf_flags = {
 	.wait	= STI_WAIT,
 };
 
-void
-sti_inq_conf(struct sti_struct *sti)
+static void sti_inq_conf(struct sti_struct *sti)
 {
 	struct sti_conf_inptr inptr = { 0, };
 	unsigned long flags;
@@ -237,8 +235,8 @@ static void sti_flush(unsigned long start, unsigned long end)
 	flush_icache_range(start, end);
 }
 
-void __devinit
-sti_rom_copy(unsigned long base, unsigned long count, void *dest)
+static void __devinit sti_rom_copy(unsigned long base, unsigned long count,
+				   void *dest)
 {
 	unsigned long dest_start = (unsigned long) dest;
 
@@ -478,8 +476,8 @@ sti_init_glob_cfg(struct sti_struct *sti,
 }
 
 #ifdef CONFIG_FB
-struct sti_cooked_font * __devinit
-sti_select_fbfont(struct sti_cooked_rom *cooked_rom, const char *fbfont_name)
+static struct sti_cooked_font __devinit
+*sti_select_fbfont(struct sti_cooked_rom *cooked_rom, const char *fbfont_name)
 {
 	const struct font_desc *fbfont;
 	unsigned int size, bpc;
@@ -534,16 +532,16 @@ sti_select_fbfont(struct sti_cooked_rom *cooked_rom, const char *fbfont_name)
 	return cooked_font;
 }
 #else
-struct sti_cooked_font * __devinit
-sti_select_fbfont(struct sti_cooked_rom *cooked_rom, const char *fbfont_name)
+static struct sti_cooked_font __devinit
+*sti_select_fbfont(struct sti_cooked_rom *cooked_rom, const char *fbfont_name)
 {
 	return NULL;
 }
 #endif
 
-struct sti_cooked_font * __devinit
-sti_select_font(struct sti_cooked_rom *rom,
-	    int (*search_font_fnc) (struct sti_cooked_rom *,int,int) )
+static struct sti_cooked_font __devinit
+*sti_select_font(struct sti_cooked_rom *rom,
+		 int (*search_font_fnc) (struct sti_cooked_rom *,int,int) )
 {
 	struct sti_cooked_font *font;
 	int i;
@@ -707,8 +705,7 @@ sti_get_bmode_rom (unsigned long address)
 	return raw;
 }
 
-struct sti_rom * __devinit
-sti_get_wmode_rom (unsigned long address)
+static struct sti_rom __devinit *sti_get_wmode_rom(unsigned long address)
 {
 	struct sti_rom *raw;
 	unsigned long size;
@@ -723,8 +720,8 @@ sti_get_wmode_rom (unsigned long address)
 	return raw;
 }
 
-int __devinit
-sti_read_rom(int wordmode, struct sti_struct *sti, unsigned long address)
+static int __devinit sti_read_rom(int wordmode, struct sti_struct *sti,
+				  unsigned long address)
 {
 	struct sti_cooked_rom *cooked;
 	struct sti_rom *raw = NULL;
diff --git a/drivers/video/sticore.h b/drivers/video/sticore.h
index 1a9a60c..7fe5be4 100644
--- a/drivers/video/sticore.h
+++ b/drivers/video/sticore.h
@@ -352,8 +352,6 @@ struct sti_struct *sti_get_rom(unsigned int index); /* 0: default sti */
 
 /* functions to call the STI ROM directly */
 
-int  sti_init_graph(struct sti_struct *sti);
-void sti_inq_conf(struct sti_struct *sti);
 void sti_putc(struct sti_struct *sti, int c, int y, int x);
 void sti_set(struct sti_struct *sti, int src_y, int src_x,
 	     int height, int width, u8 color);

