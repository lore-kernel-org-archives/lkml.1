Return-Path: <linux-kernel-owner+w=401wt.eu-S1753545AbYKATJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbYKATJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 15:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbYKATJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 15:09:49 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:64626 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbYKATJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 15:09:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NdzpV4I4WN0l+AjAW4m2bea1x5HzVc3qthX3KALVx+95cznUzLUTKv4jw3SGSUI32u
         UXSgKOwdnVlxlQHHkLgYcaVEdB4DeBuKO2w+jcA39pf21a1ayCj2QDQ78InWqK1vuWZw
         rfbRtOmCn0mBa1jvn/dyl27LpfWQhhpsmgK2g=
Date: Sat, 1 Nov 2008 22:12:50 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com
Subject: Re: [PATCH] el3_common_init() should be __devinit, not __init
Message-ID: <20081101191250.GA7588@x200.localdomain>
References: <E1KwL59-0000Ug-F1@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KwL59-0000Ug-F1@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 01, 2008 at 06:20:19PM +0000, Al Viro wrote:
> -static int __init el3_common_init(struct net_device *dev)
> +static int __devinit el3_common_init(struct net_device *dev)

Al, here is much better patch:

--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -83,20 +83,20 @@
 #define __exit          __section(.exit.text) __exitused __cold
 
 /* Used for HOTPLUG */
-#define __devinit        __section(.devinit.text) __cold
-#define __devinitdata    __section(.devinit.data)
-#define __devinitconst   __section(.devinit.rodata)
-#define __devexit        __section(.devexit.text) __exitused __cold
-#define __devexitdata    __section(.devexit.data)
-#define __devexitconst   __section(.devexit.rodata)
+#define __devinit        __cold
+#define __devinitdata
+#define __devinitconst
+#define __devexit        __exitused __cold
+#define __devexitdata
+#define __devexitconst
 
 /* Used for HOTPLUG_CPU */
-#define __cpuinit        __section(.cpuinit.text) __cold
-#define __cpuinitdata    __section(.cpuinit.data)
-#define __cpuinitconst   __section(.cpuinit.rodata)
-#define __cpuexit        __section(.cpuexit.text) __exitused __cold
-#define __cpuexitdata    __section(.cpuexit.data)
-#define __cpuexitconst   __section(.cpuexit.rodata)
+#define __cpuinit        __cold
+#define __cpuinitdata
+#define __cpuinitconst
+#define __cpuexit        __cold
+#define __cpuexitdata
+#define __cpuexitconst
 
 /* Used for MEMORY_HOTPLUG */
 #define __meminit        __section(.meminit.text) __cold
@@ -115,13 +115,13 @@
 #define __INITRODATA	.section	".init.rodata","a"
 #define __FINITDATA	.previous
 
-#define __DEVINIT        .section	".devinit.text", "ax"
-#define __DEVINITDATA    .section	".devinit.data", "aw"
-#define __DEVINITRODATA  .section	".devinit.rodata", "a"
+#define __DEVINIT
+#define __DEVINITDATA
+#define __DEVINITRODATA
 
-#define __CPUINIT        .section	".cpuinit.text", "ax"
-#define __CPUINITDATA    .section	".cpuinit.data", "aw"
-#define __CPUINITRODATA  .section	".cpuinit.rodata", "a"
+#define __CPUINIT
+#define __CPUINITDATA
+#define __CPUINITRODATA
 
 #define __MEMINIT        .section	".meminit.text", "ax"
 #define __MEMINITDATA    .section	".meminit.data", "aw"
