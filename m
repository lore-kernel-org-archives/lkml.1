Return-Path: <linux-kernel-owner+w=401wt.eu-S1758530AbXEMK5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530AbXEMK5H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 06:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757358AbXEMK44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 06:56:56 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4183 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757214AbXEMK4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 06:56:55 -0400
Date: Sun, 13 May 2007 11:56:44 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Prarit Bhargava <prarit@redhat.com>,
       Andi Kleen <andi@basil.nowhere.org>
Subject: Re: Please revert 86c0baf123e474b6eb404798926ecf62b426bf3a
Message-ID: <20070513105643.GA18344@flint.arm.linux.org.uk>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel List <linux-kernel@vger.kernel.org>,
	Prarit Bhargava <prarit@redhat.com>,
	Andi Kleen <andi@basil.nowhere.org>
References: <20070508134928.GA13212@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
In-Reply-To: <20070508134928.GA13212@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 08, 2007 at 02:49:28PM +0100, Russell King wrote:
> The change:
> 
> +#ifdef CONFIG_HOTPLUG_CPU
> +#define __INIT		.section	".text","ax"
> +#define __INITDATA	.section	".data","aw"
> +#else
>  #define __INIT		.section	".init.text","ax"
> -#define __FINIT		.previous
>  #define __INITDATA	.section	".init.data","aw"
> +#endif
> +#define __FINIT		.previous
> 
> breaks ARM, since the ARM startup code moves from the start of the image
> to somewhere in the middle of the kernel image.  (That's trivially fixable.)

Although I've worked around this, I still would like this fixed.
Prarit's produced a patch (mail attached) which should fix it,
can we get it merged please?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

--cWoXeonUoKmBZSoM
Content-Type: message/rfc822
Content-Disposition: inline

Return-path: <linux-kernel-owner+rmk=2Blkml=40arm.linux.org.uk-S1758184AbXEIRZq@vger.kernel.org>
Envelope-to: rmk+lkml@arm.linux.org.uk
Delivery-date: Wed, 09 May 2007 18:25:59 +0100
Received: from caramon.arm.linux.org.uk ([2002:d993:5cf9:1:a00:2bff:fe95:1d7b])
	by flint.arm.linux.org.uk with esmtpa (Exim 4.62)
	(envelope-from <linux-kernel-owner+rmk=2Blkml=40arm.linux.org.uk-S1758184AbXEIRZq@vger.kernel.org>)
	id 1HlpvK-0003lH-IX
	for rmk+lkml@arm.linux.org.uk; Wed, 09 May 2007 18:25:58 +0100
Received: from vger.kernel.org ([209.132.176.167])
	by caramon.arm.linux.org.uk with esmtp (Exim 4.62)
	(envelope-from <linux-kernel-owner+rmk=2Blkml=40arm.linux.org.uk-S1758184AbXEIRZq@vger.kernel.org>)
	id 1HlpvH-0000Yy-K4
	for rmk+lkml@arm.linux.org.uk; Wed, 09 May 2007 18:25:56 +0100
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184AbXEIRZq (ORCPT <rfc822;rmk+lkml@arm.linux.org.uk>);
	Wed, 9 May 2007 13:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756044AbXEIRZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 13:25:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755978AbXEIRZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 13:25:35 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l49HPYhO018011
	for <linux-kernel@vger.kernel.org>; Wed, 9 May 2007 13:25:34 -0400
Received: from mail.boston.redhat.com (mail.boston.redhat.com [172.16.76.12])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l49HPXfJ000978
	for <linux-kernel@vger.kernel.org>; Wed, 9 May 2007 13:25:33 -0400
Received: from prarit.boston.redhat.com (prarit.boston.redhat.com [172.16.80.158])
	by mail.boston.redhat.com (8.12.11.20060308/8.12.11) with ESMTP id l49HPWZ9017225;
	Wed, 9 May 2007 13:25:32 -0400
Date: Wed, 9 May 2007 13:25:32 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	rmk+lkml@arm.linux.org.uk, dzickus@redhat.com
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20070509172532.16700.33405.sendpatchset@prarit.boston.redhat.com>
Subject: [PATCH] Remove cpu hotplug defines for __INIT & __INITDATA
Sender: linux-kernel-owner@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-kernel@vger.kernel.org

Russell and Andrew,

After examining what was checked in and the code base I discovered that most
of 86c0baf123e474b6eb404798926ecf62b426bf3a wasn't necessary anymore....

So here's a patch that reverts the last part of that changeset:




Revert part of 86c0baf123e474b6eb404798926ecf62b426bf3a.

The kernel has moved forward to a state where the original change is not
necessary.  After porting forward, this final version of the patch was
applied and broke non-x86 architectures.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/include/linux/init.h b/include/linux/init.h
index 8bc32bb..e007ae4 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -52,14 +52,9 @@
 #endif
 
 /* For assembly routines */
-#ifdef CONFIG_HOTPLUG_CPU
-#define __INIT		.section	".text","ax"
-#define __INITDATA	.section	".data","aw"
-#else
 #define __INIT		.section	".init.text","ax"
-#define __INITDATA	.section	".init.data","aw"
-#endif
 #define __FINIT		.previous
+#define __INITDATA	.section	".init.data","aw"
 
 #ifndef __ASSEMBLY__
 /*
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

--cWoXeonUoKmBZSoM--
