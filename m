Return-Path: <linux-kernel-owner+w=401wt.eu-S1755183AbZHGUyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbZHGUyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 16:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbZHGUyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 16:54:12 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50913 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbZHGUyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 16:54:11 -0400
Date: Fri, 7 Aug 2009 22:54:11 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH 6/6] [ARM] Use atomic_spin_lock/atomic_spin_unlock for
	irqdesc lock
Message-ID: <20090807205411.GA2422@pengutronix.de>
References: <20090807203939.GA19374@pengutronix.de> <1249677761-19470-6-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1249677761-19470-6-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> diff --git a/mm/highmem.c b/mm/highmem.c
> index 66e915a..214eefd 100644
> --- a/mm/highmem.c
> +++ b/mm/highmem.c
> @@ -372,8 +372,8 @@ void *kmap_high_get(struct page *page)
>  	lock_kmap_any(flags);
>  	vaddr = (unsigned long)page_address(page);
>  	if (vaddr) {
> -		BUG_ON(pkmap_count[PKMAP_NR(vaddr)] < 1);
> -		pkmap_count[PKMAP_NR(vaddr)]++;
> +		BUG_ON(atomic_read(&pkmap_count[PKMAP_NR(vaddr)]) < 1);
> +		atomic_add(1, pkmap_count[PKMAP_NR(vaddr)]);
>  	}
>  	unlock_kmap_any(flags);
>  	return (void*) vaddr;
ups, this hunk doesn't belong here.  I will follow up with a corrected
patch.

Sorry
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
