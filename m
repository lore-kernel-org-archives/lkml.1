Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbYEaTmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbYEaTmW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 15:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbYEaTmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 15:42:12 -0400
Received: from lazybastard.de ([212.112.238.170]:56024 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbYEaTmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 15:42:11 -0400
Date: Sat, 31 May 2008 21:41:55 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Chris Malley <mail@chrismalley.co.uk>
Subject: Re: [patch 1/2] MTD: use list_for_each_entry() in add_mtd_device()
Message-ID: <20080531194154.GA7055@logfs.org>
References: <20080531132808.644758754@kaehlcke.net> <20080531132808.984625508@kaehlcke.net> <20080531133511.GA8734@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080531133511.GA8734@traven>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 May 2008 15:35:11 +0200, Matthias Kaehlcke wrote:
> 
> MTD: use list_for_each_entry() instead of list_for_each() in add_mtd_device()
> 
> Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

Chris Malley (added to Cc:) sent a patch converting all of drivers/mtd/
in a similar fashion.  It should be on its way in, if dwmw2 hasn't
missed it.

You might also want to check your mailer.  This patch looks like bouquet
of flowers that got stuck in an elevator door. ;)

> Index: linux-2.6/drivers/mtd/mtdcore.c
> ===================================================================
> --- linux-2.6.orig/drivers/mtd/mtdcore.c        2008-05-31
> 15:31:17.000000000 +0200
> +++ linux-2.6/drivers/mtd/mtdcore.c     2008-05-31 15:32:19.000000000
> +0200
> @@ -53,7 +53,7 @@
> 
>         for (i=0; i < MAX_MTD_DEVICES; i++)
>                 if (!mtd_table[i]) {
> -                       struct list_head *this;
> +                       struct mtd_notifier *not;
> 
>                         mtd_table[i] = mtd;
>                         mtd->index = i;
> @@ -72,8 +72,7 @@
>                         DEBUG(0, "mtd: Giving out device %d to
> 												%s\n",i, mtd->name);
>                         /* No need to get a refcount on the module
> 												containing
>                            the notifier, since we hold the
> 													 mtd_table_mutex */
> -                       list_for_each(this, &mtd_notifiers) {
> -                               struct mtd_notifier *not =
> list_entry(this, struct mtd_notifier, list);
> +                       list_for_each_entry(not, &mtd_notifiers, list)
> {
>                                 not->add(mtd);
>                         }

Jörn

-- 
You ain't got no problem, Jules. I'm on the motherfucker. Go back in
there, chill them niggers out and wait for the Wolf, who should be
coming directly.
-- Marsellus Wallace
