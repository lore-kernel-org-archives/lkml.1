Return-Path: <linux-kernel-owner+w=401wt.eu-S1758633AbYBPPQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633AbYBPPQl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 10:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756356AbYBPPQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 10:16:20 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:37884 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903AbYBPPQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 10:16:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=gzc5qp3hO7jk55gNjRmQKCbOOS77nsXDQCLry6nFrqoUh4R/l7NYkGp4ZlqFkSF5ebdqB4QYgDD48QoHFSnKxjkbtrmZ896KBxbJcF6I9GPHtimU1RyIFkuDVhCdZ9lQJCIMJGnnXN3xRDhhqM56thWlDw9OEcDcwmUU3DpkUzQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [BUID_FAILURE] next-20080215 Build failure caused by ide: rework PowerMac media-bay support
Date: Sat, 16 Feb 2008 15:57:32 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linuxppc-dev@ozlabs.org, michael@ellerman.id.au,
       Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <47B5D1C3.40702@linux.vnet.ibm.com>
In-Reply-To: <47B5D1C3.40702@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802161557.32788.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 February 2008, Kamalesh Babulal wrote:
> The linux-next-20080215 kernel build fails on the powerpc with
> following error
>  
>   CC      arch/powerpc/platforms/powermac/setup.o
> In file included from arch/powerpc/platforms/powermac/setup.c:66:
> include/asm/mediabay.h:29: error: syntax error before 'ide_hwif_t'
> include/asm/mediabay.h:29: warning: function declaration isn't a prototype
> make[2]: *** [arch/powerpc/platforms/powermac/setup.o] Error 1
> make[1]: *** [arch/powerpc/platforms/powermac] Error 2
> make: *** [arch/powerpc/platforms] Error 2
> 
> This build failure is caused by the  ide: rework PowerMac media-bay support
> patch.This problem was reported and solution suggested according to
> http://lkml.org/lkml/2008/2/13/195 including the 
> 
> #include <linux/ide.h> after
> 
> #ifdef CONFIG_BLK_DEV_IDE_PMAC
> 
> helps in fixing the build failure.

Thanks, I fixed the original patch.

interdiff:

[...]
v2:
* Fix build by adding <linux/ide.h> include to <asm-powerpc/mediabay.h>.
  (Reported by Michael/Kamalesh/Andrew).

Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Andrew Morton <akpm@linux-foundation.org>
[...]

diff -u b/include/asm-powerpc/mediabay.h b/include/asm-powerpc/mediabay.h
--- b/include/asm-powerpc/mediabay.h
+++ b/include/asm-powerpc/mediabay.h
@@ -23,6 +23,8 @@
 extern int media_bay_count;
 
 #ifdef CONFIG_BLK_DEV_IDE_PMAC
+#include <linux/ide.h>
+
 int check_media_bay_by_base(unsigned long base, int what);
 /* called by IDE PMAC host driver to register IDE controller for media bay */
 int media_bay_set_ide_infos(struct device_node *which_bay, unsigned long base,


