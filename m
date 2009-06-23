Return-Path: <linux-kernel-owner+w=401wt.eu-S1757104AbZFWMyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104AbZFWMyY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 08:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754515AbZFWMyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 08:54:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:11713 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232AbZFWMyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 08:54:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MUDcq3NfsFaTUiGZJzQdYBrkl8cdtls+7LPY0dSa4+JhIsOe3sLz3NVRhgORgzM59g
         UibE1biEYsd+VEGnSjlCcFc2t4Vty8jUe89yribH2ymkp6z4L/ohd3emclIEvNnP3yMD
         Y0nRyEn1JC+qcoDIPqDjyKnzWvIukhbMXwfNs=
Date: Tue, 23 Jun 2009 20:53:32 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: +
	printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec.patch
	added to -mm tree
Message-ID: <20090623125332.GD12135@darkstar>
References: <200906230556.n5N5uG3a017246@imap1.linux-foundation.org> <20090623072116.GC5747@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623072116.GC5747@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 09:21:16AM +0200, Ingo Molnar wrote:
> 
> > +++ a/kernel/printk.c
> > @@ -198,12 +198,11 @@ __setup("log_buf_len=", log_buf_len_setu
> >  #ifdef CONFIG_BOOT_PRINTK_DELAY
> >  
> >  static unsigned int boot_delay; /* msecs delay after each printk during bootup */
> > -static unsigned long long printk_delay_msec; /* per msec, based on boot_delay */
> > +static unsigned long long loops_per_msec;
> 
> Lost a comment here - on purpose?

Yes, I thought loops_per_msec is clearer than printk_delay_msec for boot_delay, but add a comment is fine. 

Andrew have fixed it, thanks.

> 
> > -	printk_delay_msec = loops_per_msec;
> >  	printk(KERN_DEBUG "boot_delay: %u, preset_lpj: %ld, lpj: %lu, "
> > -		"HZ: %d, printk_delay_msec: %llu\n",
> > -		boot_delay, preset_lpj, lpj, HZ, printk_delay_msec);
> > +		"HZ: %d, loops_per_msec: %llu\n",
> > +		boot_delay, preset_lpj, lpj, HZ, loops_per_msec);
> 
> If you touch debug printks then please use pr_debug().
> 
> 	Ingo

please see the following fix:
--

From: Dave Young <hidave.darkstar@gmail.com>
 
use pr_debug for debug printk.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
kernel/printk.c |    2 +-
1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/kernel/printk.c	2009-06-23 17:48:25.000000000 +0800
+++ linux-2.6/kernel/printk.c	2009-06-23 18:08:18.000000000 +0800
@@ -211,7 +211,7 @@ static int __init boot_delay_setup(char 
 	if (boot_delay > 10 * 1000)
 		boot_delay = 0;
 
-	printk(KERN_DEBUG "boot_delay: %u, preset_lpj: %ld, lpj: %lu, "
+	pr_debug("boot_delay: %u, preset_lpj: %ld, lpj: %lu, "
 		"HZ: %d, loops_per_msec: %llu\n",
 		boot_delay, preset_lpj, lpj, HZ, loops_per_msec);
 	return 1;
