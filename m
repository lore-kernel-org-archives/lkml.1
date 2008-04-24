Return-Path: <linux-kernel-owner+w=401wt.eu-S1757635AbYDXKuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635AbYDXKuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 06:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbYDXKug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 06:50:36 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36427 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751585AbYDXKuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 06:50:35 -0400
Date: Thu, 24 Apr 2008 11:21:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dtor@mail.ru>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH2] Basic braille screen reader support
Message-ID: <20080424112126.674acf7d@the-village.bc.nu>
In-Reply-To: <20080424003900.GO4825@implementation>
References: <20080204031842.GE4439@implementation>
	<20080205220054.GD4394@implementation>
	<20080205165853.561d5f3d.akpm@linux-foundation.org>
	<20080206020423.GG4394@implementation>
	<20080222002822.GB32480@implementation>
	<20080223000410.674ce674.akpm@linux-foundation.org>
	<20080223131028.GC4244@implementation>
	<20080424003900.GO4825@implementation>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2008 01:39:00 +0100
Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:

> Hello,
> 
> Could the basic braille screen reader be pushed to 2.6.26?
> 
> Else, could at least the patch below be applied, so that people can
> compile external accessibility modules a lot more easily? (no need to
> patch vanilla kernel, which is a huge win for people who already have a
> hard time just using their computer...)
> 
> Samuel
> 
> Export functions typically used by screen reading modules.
> 
> Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

Seems the right small set of changes to get us started with the real
merge and its useful for the tty cleanup to have these exports visible so
I know what will affect others.

Acked-by: Alan Cox <alan@redhat.com>


> 
> diff -ur linux-2.6.24.1-orig/drivers/char/consolemap.c linux-2.6.24.1-perso/drivers/char/consolemap.c
> --- linux-2.6.24.1-orig/drivers/char/consolemap.c	2008-01-25 09:32:05.000000000 +0100
> +++ linux-2.6.24.1-perso/drivers/char/consolemap.c	2008-02-03 22:27:04.000000000 +0100
> @@ -277,6 +277,7 @@
>  			return p->inverse_translations[m][glyph];
>  	}
>  }
> +EXPORT_SYMBOL_GPL(inverse_translate);
>  
>  static void update_user_maps(void)
>  {
> diff -ur linux-2.6.24.1-orig/drivers/char/keyboard.c linux-2.6.24.1-perso/drivers/char/keyboard.c
> --- linux-2.6.24.1-orig/drivers/char/keyboard.c	2008-01-25 09:32:06.000000000 +0100
> +++ linux-2.6.24.1-perso/drivers/char/keyboard.c	2008-02-04 03:44:37.000000000 +0100
> @@ -110,6 +110,7 @@
>  const int NR_TYPES = ARRAY_SIZE(max_vals);
>  
>  struct kbd_struct kbd_table[MAX_NR_CONSOLES];
> +EXPORT_SYMBOL_GPL(kbd_table);
>  static struct kbd_struct *kbd = kbd_table;
>  
>  struct vt_spawn_console vt_spawn_con = {
> @@ -260,6 +261,7 @@
>  	} else
>  		kd_nosound(0);
>  }
> +EXPORT_SYMBOL_GPL(kd_mksound);
>  
>  /*
>   * Setting the keyboard rate.
> diff -ur linux-2.6.24.1-orig/drivers/char/vt.c linux-2.6.24.1-perso/drivers/char/vt.c
> --- linux-2.6.24.1-orig/drivers/char/vt.c	2008-01-25 09:32:06.000000000 +0100
> +++ linux-2.6.24.1-perso/drivers/char/vt.c	2008-02-03 22:27:04.000000000 +0100
> @@ -3982,6 +3982,7 @@
>  		c |= 0x100;
>  	return c;
>  }
> +EXPORT_SYMBOL_GPL(screen_glyph);
>  
>  /* used by vcs - note the word offset */
>  unsigned short *screen_pos(struct vc_data *vc, int w_offset, int viewed)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
--
	"Alan, I'm getting a bit worried about you."
				-- Linus Torvalds
