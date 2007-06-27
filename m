Return-Path: <linux-kernel-owner+w=401wt.eu-S1759511AbXF0M0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511AbXF0M0D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 08:26:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756342AbXF0MZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 08:25:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:36753 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755441AbXF0MZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 08:25:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=j6HgdeHDi8xjIHely/f5q4Kb8Uijll+BgtGEAEgzjE9R7b8Z4RrzgIt9KFMde+OTw4g5C6KTe8iXVWHJWsDcYpp9DiSY+1WUnGcy5/nHzB8gJjNM/dFTTReWMmO3fY5JFYE5qPm9ZpK2q+1fSpm2F4sjkQzEAse4lo4qC1p5ebI=
Message-ID: <46825722.7030702@googlemail.com>
Date: Wed, 27 Jun 2007 14:25:06 +0200
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] linux/cache.h export - workaround for headers_check error
 (Re: mm snapshot broken-out-2007-06-27-03-28.tar.gz uploaded)
References: <200706271030.l5RAUgKE015163@imap1.linux-foundation.org>
In-Reply-To: <200706271030.l5RAUgKE015163@imap1.linux-foundation.org>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

akpm@linux-foundation.org pisze:
> The mm snapshot broken-out-2007-06-27-03-28.tar.gz has been uploaded to
> 
>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-06-27-03-28.tar.gz
> 
> It contains the following patches against 2.6.22-rc6:
> 

I get this error while headers_check due to ntp-move-the-cmos-update-code-into-ntpc-fix.patch

/home/devel/linux-work2/usr/include/linux/time.h requires linux/cache.h, which does not exist in exported headers
make[3]: *** [/home/devel/linux-work2/usr/include/linux/.check.time.h] Error 1
make[2]: *** [linux] Error 2
make[1]: *** [headers_check] Error 2
make: *** [vmlinux] Error 2

Here is a workaround.

Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-work2-clean/include/linux/Kbuild	2007-06-27 13:00:50.000000000 +0200
+++ linux-work2/include/linux/Kbuild	2007-06-27 13:51:24.000000000 +0200
@@ -174,6 +174,7 @@ unifdef-y += atm_tcp.h
 unifdef-y += audit.h
 unifdef-y += auto_fs.h
 unifdef-y += binfmts.h
+unifdef-y += cache.h
 unifdef-y += capability.h
 unifdef-y += capi.h
 unifdef-y += cciss_ioctl.h
--- linux-work2-clean/include/linux/cache.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-work2/include/linux/cache.h	2007-06-27 13:50:53.000000000 +0200
@@ -1,6 +1,8 @@
 #ifndef __LINUX_CACHE_H
 #define __LINUX_CACHE_H
 
+#ifdef __KERNEL__
+
 #include <linux/kernel.h>
 #include <asm/cache.h>
 
@@ -60,4 +62,6 @@
 #endif
 #endif
 
+#endif /* __KERNEL__ */
+
 #endif /* __LINUX_CACHE_H */

