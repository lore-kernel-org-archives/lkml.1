Return-Path: <linux-kernel-owner+w=401wt.eu-S1752937AbZBCIJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbZBCIJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 03:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbZBCIJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 03:09:49 -0500
Received: from winston.telenet-ops.be ([195.130.137.75]:36492 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbZBCIJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 03:09:48 -0500
Date: Tue, 3 Feb 2009 09:09:38 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH 1/2] atyfb: fix CONFIG_ namespace
 violations
In-Reply-To: <20090202150002.05838fed.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0902030907350.15898@anakin>
References: <200901310909.n0V99XIZ021497@imap1.linux-foundation.org>
 <4984AC40.8030708@oracle.com> <20090131121008.eb7f5ddd.akpm@linux-foundation.org>
 <20090202150002.05838fed.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Feb 2009, Randy Dunlap wrote:
> On Sat, 31 Jan 2009 12:10:08 -0800 Andrew Morton wrote:
> > On Sat, 31 Jan 2009 11:53:36 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > 
> > > so staging adds a new config symbol that conflicts with the
> > > (incorrect namespace) usage in mach64.h.
> > > 
> > > mach64 needs to change IMO, even though it is older.
> > 
> > Sigh, yes, that file has gone on a rampage through the namespace
> > rules.  I'll take a look at it sometime.
> > --
> 
> I went ahead with a minimal set of changes, but you can toss them
> and do more if you prefer.
> 
> ---
> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> [1/2] Fix namespace violations by changing non-kconfig CONFIG_ names
> to CNFG_*.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
>  drivers/video/aty/aty128fb.c    |    8 ++++----
>  drivers/video/aty/atyfb_base.c  |   22 +++++++++++-----------
>  drivers/video/aty/radeon_base.c |   10 +++++-----
>  drivers/video/aty/radeon_pm.c   |   18 +++++++++---------
>  include/video/aty128.h          |    4 ++--
>  include/video/mach64.h          |   24 ++++++++++++------------
>  include/video/radeon.h          |   18 +++++++++---------
>  7 files changed, 52 insertions(+), 52 deletions(-)
> 
> --- linux-2.6.29-rc3-git3.orig/drivers/video/aty/atyfb_base.c
> +++ linux-2.6.29-rc3-git3/drivers/video/aty/atyfb_base.c
> @@ -135,7 +135,7 @@
>  #if defined(CONFIG_PM) || defined(CONFIG_PMAC_BACKLIGHT) || \
>  defined (CONFIG_FB_ATY_GENERIC_LCD) || defined(CONFIG_FB_ATY_BACKLIGHT)
>  static const u32 lt_lcd_regs[] = {
> -	CONFIG_PANEL_LG,
> +	CNFG_PANEL_LG,

These were the official names as used in the ATI docs. After these changes, you
can no longer easily grep for them.

Perhaps it's better to prefix everything with ATI_? yes, I know it's more work
(for the writer), but we want to optimize for the reader, right?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
