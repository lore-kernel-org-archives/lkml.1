Return-Path: <linux-kernel-owner+w=401wt.eu-S1757911AbYDXLT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911AbYDXLT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 07:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbYDXLTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 07:19:49 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:4032 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbYDXLTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 07:19:48 -0400
X-Greylist: delayed 624 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Apr 2008 07:19:47 EDT
X-IronPort-AV: E=Sophos;i="4.25,704,1199682000"; 
   d="scan'208";a="13973200"
Date: Thu, 24 Apr 2008 12:09:18 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dtor@mail.ru>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH2] Basic braille screen reader support
Message-ID: <20080424110918.GC4365@implementation.uk.xensource.com>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>,
	Jiri Kosina <jkosina@suse.cz>
References: <20080204031842.GE4439@implementation> <20080205220054.GD4394@implementation> <20080205165853.561d5f3d.akpm@linux-foundation.org> <20080206020423.GG4394@implementation> <20080222002822.GB32480@implementation> <20080223000410.674ce674.akpm@linux-foundation.org> <20080223131028.GC4244@implementation> <20080424003900.GO4825@implementation> <20080424112126.674acf7d@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080424112126.674acf7d@the-village.bc.nu>
User-Agent: Mutt/1.5.12-2006-07-14
X-OriginalArrivalTime: 24 Apr 2008 11:09:19.0040 (UTC) FILETIME=[A4357400:01C8A5FB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox, le Thu 24 Apr 2008 11:21:26 +0100, a écrit :
> On Thu, 24 Apr 2008 01:39:00 +0100
> Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:
> > Export functions typically used by screen reading modules.
> 
> Seems the right small set of changes to get us started with the real
> merge and its useful for the tty cleanup to have these exports visible so
> I know what will affect others.

Ok.

Additionnal exports which will be of much use is selection, see patch
below.

Samuel



Export set_selection and paste_selection for accessibility modules.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

--- linux/drivers/char/selection.c.orig	2008-04-24 12:00:07.000000000 +0100
+++ linux/drivers/char/selection.c	2008-04-24 11:59:56.000000000 +0100
@@ -299,6 +299,7 @@ int set_selection(const struct tiocl_sel
 	sel_buffer_lth = bp - sel_buffer;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(set_selection);
 
 /* Insert the contents of the selection buffer into the
  * queue of the tty associated with the current console.
@@ -336,3 +337,4 @@ int paste_selection(struct tty_struct *t
 	tty_ldisc_deref(ld);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(paste_selection);
