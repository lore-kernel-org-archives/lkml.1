Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbZI0RgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbZI0RgH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 13:36:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbZI0RgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 13:36:06 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:38752 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261AbZI0RgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 13:36:06 -0400
Message-ID: <4ABFA27F.1080100@upmc.fr>
Date: Sun, 27 Sep 2009 19:35:59 +0200
From: Bernard Pidoux <bernard.pidoux@upmc.fr>
Organization: Universite Pierre & Marie Curie - Paris 6
User-Agent: Thunderbird 2.0.0.23 (X11/20090822)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.31.1 BUG #include <asm/bitsperlong.h>
References: <4ABF4E36.4090703@upmc.fr>	<4ABF5328.8020901@upmc.fr>	<4ABF5E21.9080104@upmc.fr> <20090927151942.1c6a010a@infradead.org>
In-Reply-To: <20090927151942.1c6a010a@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the difference that made my system crazy :

--- /usr/src/linux-2.6.30.6/include/asm-generic/int-ll64.h	2009-06-10 05:05:27.000000000 +0200
+++ /usr/src/linux-2.6.31/include/asm-generic/int-ll64.h	2009-09-27 11:27:02.577804468 +0200
@@ -8,6 +8,8 @@
 #ifndef _ASM_GENERIC_INT_LL64_H
 #define _ASM_GENERIC_INT_LL64_H
 
+#include <asm/bitsperlong.h>
+
 #ifndef __ASSEMBLY__
 /*
  * __xx is ok: it doesn't pollute the POSIX namespace. Use these in the

So, where are supposed to be the export routines that did not work ?

Bernard


> The correct fix is to include the missing bitsperlong in
> the asm-x86 directory.
> In other words your kernel headers are broken.
> 
> Looking at latest kernel we do export bitsperlong.h.
> So see if you can find a fix for your broken kernel headers.
> 
> 	Sam


