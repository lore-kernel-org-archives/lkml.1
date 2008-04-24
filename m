Return-Path: <linux-kernel-owner+w=401wt.eu-S1756578AbYDXAwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbYDXAwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 20:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755847AbYDXAwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 20:52:22 -0400
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:10196 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755042AbYDXAwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 20:52:21 -0400
Date: Thu, 24 Apr 2008 01:39:00 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dtor@mail.ru>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH2] Basic braille screen reader support
Message-ID: <20080424003900.GO4825@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>,
	Jiri Kosina <jkosina@suse.cz>
References: <20080204031842.GE4439@implementation> <20080205220054.GD4394@implementation> <20080205165853.561d5f3d.akpm@linux-foundation.org> <20080206020423.GG4394@implementation> <20080222002822.GB32480@implementation> <20080223000410.674ce674.akpm@linux-foundation.org> <20080223131028.GC4244@implementation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080223131028.GC4244@implementation>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Could the basic braille screen reader be pushed to 2.6.26?

Else, could at least the patch below be applied, so that people can
compile external accessibility modules a lot more easily? (no need to
patch vanilla kernel, which is a huge win for people who already have a
hard time just using their computer...)

Samuel

Export functions typically used by screen reading modules.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

diff -ur linux-2.6.24.1-orig/drivers/char/consolemap.c linux-2.6.24.1-perso/drivers/char/consolemap.c
--- linux-2.6.24.1-orig/drivers/char/consolemap.c	2008-01-25 09:32:05.000000000 +0100
+++ linux-2.6.24.1-perso/drivers/char/consolemap.c	2008-02-03 22:27:04.000000000 +0100
@@ -277,6 +277,7 @@
 			return p->inverse_translations[m][glyph];
 	}
 }
+EXPORT_SYMBOL_GPL(inverse_translate);
 
 static void update_user_maps(void)
 {
diff -ur linux-2.6.24.1-orig/drivers/char/keyboard.c linux-2.6.24.1-perso/drivers/char/keyboard.c
--- linux-2.6.24.1-orig/drivers/char/keyboard.c	2008-01-25 09:32:06.000000000 +0100
+++ linux-2.6.24.1-perso/drivers/char/keyboard.c	2008-02-04 03:44:37.000000000 +0100
@@ -110,6 +110,7 @@
 const int NR_TYPES = ARRAY_SIZE(max_vals);
 
 struct kbd_struct kbd_table[MAX_NR_CONSOLES];
+EXPORT_SYMBOL_GPL(kbd_table);
 static struct kbd_struct *kbd = kbd_table;
 
 struct vt_spawn_console vt_spawn_con = {
@@ -260,6 +261,7 @@
 	} else
 		kd_nosound(0);
 }
+EXPORT_SYMBOL_GPL(kd_mksound);
 
 /*
  * Setting the keyboard rate.
diff -ur linux-2.6.24.1-orig/drivers/char/vt.c linux-2.6.24.1-perso/drivers/char/vt.c
--- linux-2.6.24.1-orig/drivers/char/vt.c	2008-01-25 09:32:06.000000000 +0100
+++ linux-2.6.24.1-perso/drivers/char/vt.c	2008-02-03 22:27:04.000000000 +0100
@@ -3982,6 +3982,7 @@
 		c |= 0x100;
 	return c;
 }
+EXPORT_SYMBOL_GPL(screen_glyph);
 
 /* used by vcs - note the word offset */
 unsigned short *screen_pos(struct vc_data *vc, int w_offset, int viewed)
