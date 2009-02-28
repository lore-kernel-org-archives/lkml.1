Return-Path: <linux-kernel-owner+w=401wt.eu-S1754453AbZB1NsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbZB1NsT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 08:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbZB1NsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 08:48:07 -0500
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:16668 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbZB1NsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 08:48:06 -0500
X-Greylist: delayed 714 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Feb 2009 08:48:05 EST
X-RZG-AUTH: :Pm0FVUW6aauhRGJJc5OfA4AU8DM8ZlijdmJYxKD/ShD7mhg7S7vQ8wo=
X-RZG-CLASS-ID: mo05
Date: Sat, 28 Feb 2009 14:36:02 +0100
From: Alex Riesen <raa.lkml@gmail.com>, Alex Riesen <raa@blimp.localhost>
To: trivial@kernel.org
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] Use a format string for linux_banner
Message-ID: <20090228133602.GA28239@blimp.localdomain>
Reply-To: Alex Riesen <raa.lkml@gmail.com>
References: <81b0412b0902250104q53f38343o303e980c1446ed3e@mail.gmail.com> <49A92783.1010709@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A92783.1010709@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alex Riesen <raa.lkml@gmail.com>
---

Stefan Richter, Sat, Feb 28, 2009 13:01:07 +0100:
> [+ application/octet-stream attachment, base64 encoded]
> 
> Please send patches as inline text or at least as plaintext attachment
> in ascii encoding.  linux/Documentation/email-clients.txt has help.

Couldn't. Had to either choose the corporate firewal and gmail, or the
Exchange-thing. Both will corrupt patches, unless send as attachment.
Decided not to expose the corporate mail address.
Anyway, resending from home now (back then couldn't send from home
either: was changing providers and had no usable link for a week.
Tell about coincidences...)

> > -	printk(linux_banner);
> > +	printk("%s", linux_banner);
> 
> Better than that:
> 
> -	printk(KERN_NOTICE);
> -	printk(linux_banner);
> +	printk(KERN_NOTICE "%s", linux_banner);
> 

Missed the line before. Poor blind me.

 init/main.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/init/main.c b/init/main.c
index 8442094..77fc028 100644
--- a/init/main.c
+++ b/init/main.c
@@ -553,8 +553,7 @@ asmlinkage void __init start_kernel(void)
 	tick_init();
 	boot_cpu_init();
 	page_address_init();
-	printk(KERN_NOTICE);
-	printk(linux_banner);
+	printk(KERN_NOTICE "%s", linux_banner);
 	setup_arch(&command_line);
 	mm_init_owner(&init_mm, &init_task);
 	setup_command_line(command_line);
-- 
1.6.2.rc2.31.gce6e3

