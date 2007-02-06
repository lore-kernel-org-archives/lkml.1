Return-Path: <linux-kernel-owner+w=401wt.eu-S965517AbXBFVTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965517AbXBFVTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 16:19:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965521AbXBFVTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 16:19:11 -0500
Received: from smtp1.kolej.mff.cuni.cz ([195.113.24.4]:58538 "EHLO
	smtp1.kolej.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965517AbXBFVTJ (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 16:19:09 -0500
X-Envelope-From: zajio1am@artax.karlin.mff.cuni.cz
Date: Tue, 6 Feb 2007 22:17:46 +0100
From: Ondrej Zajicek <santiago@crfreenet.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: James Simmons <jsimmons@infradead.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH] fbdev driver for S3 Trio/Virge
Message-ID: <20070206211746.GA31501@localhost.localdomain>
References: <20070205195130.GB5206@localhost.localdomain> <45C7B0A8.50707@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45C7B0A8.50707@gmail.com>
X-Operating-System: Debian GNU/Linux 3.1 (Sarge)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, Feb 05, 2007 at 11:33:12PM +0100, Jiri Slaby wrote:                                                             
> Ondrej Zajicek napsal(a):
> >This patch adds driver for S3 Trio / S3 Virge. Driver is tested
> >with most versions of S3 Trio and S3 Virge, on i386.
> >It is tested both as compiled-in and module. It is against
> >linux-2.6.20 .

Thank you for comments. I appreciated them.

> >+#ifdef CONFIG_MTRR
> >+#include <asm/mtrr.h>
> >+#endif
> 
> Why ifdef? It's ifdeffed in the header itself.

But this header is only available on some archs, isn't it?

> >+static int s3fb_open(struct fb_info *info, int user)
> >+{
> >+	struct s3fb_info *par = (struct s3fb_info *) info;
> >+	unsigned int count = atomic_read(&(par->ref_count));
> >+
> >+	if (!count) {
> 
> bad
> 
> >+		memset(&(par->state), 0, sizeof(struct vgastate));
> >+		par->state.flags = VGA_SAVE_MODE | VGA_SAVE_FONTS | 
> >VGA_SAVE_CMAP;
> >+		par->state.num_crtc = 0x70;
> >+		par->state.num_seq = 0x20;
> >+		save_vga(&(par->state));
> >+	}
> >+
> >+	atomic_inc(&(par->ref_count));
> >+
> >+	return 0;
> >+}

This pattern is in several fbdev drivers (neofb, i810fb, rivafb, vga16fb).
I understand the problem but i am not sure what is the best solution.
Maybe acquire/release console semaphore before/after s3fb_open?

> >+static int s3fb_release(struct fb_info *info, int user)
> >+{
> >+	struct s3fb_info *par = (struct s3fb_info *) info;
> 
> Use container_of for this (and below/above).

Isn't container_of overkill for this case?

> >+struct vga_regset {
> >+	__u8 regnum;
> >+	__u8 lowbit;
> >+	__u8 highbit;
> 
> You use no __ variants, why __u8 here?

No reason. I will replace it to u8, which is more appropriate.

-- 
Ondrej 'SanTiago' Zajicek (email: santiago@mail.cz, jabber: santiago@njs.netlab.cz)
OpenPGP encrypted e-mails preferred (KeyID 0x11DEADC3, wwwkeys.pgp.net)
"To err is human -- to blame it on a computer is even more so."
