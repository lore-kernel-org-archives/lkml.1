Return-Path: <linux-kernel-owner+w=401wt.eu-S1761372AbYG3KFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761372AbYG3KFT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 06:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761570AbYG3KEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 06:04:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761514AbYG3KEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 06:04:30 -0400
Date: Wed, 30 Jul 2008 03:03:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: ambx1@neo.rr.com, linux-kernel@vger.kernel.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: build issue #538 for v2.6.27-rc1 :undefined reference to
 `pnp_get_resource'
Message-Id: <20080730030344.25cba78a.akpm@linux-foundation.org>
In-Reply-To: <200807291811.49788.toralf.foerster@gmx.de>
References: <200807291811.49788.toralf.foerster@gmx.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008 18:11:46 +0200 Toralf F__rster <toralf.foerster@gmx.de> wrote:

> Hello,
> 
> the build (.config attached) failed, make ends with :
> ...
>   AS      arch/x86/lib/thunk_32.o
>   CC      arch/x86/lib/usercopy_32.o
>   AR      arch/x86/lib/lib.a
>   LD      vmlinux.o
>   MODPOST vmlinux.o
> WARNING: modpost: Found 13 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `pnp_port_start':
> /home/tfoerste/devel/linux-2.6/include/linux/pnp.h:51: undefined reference to `pnp_get_resource'
> make: *** [.tmp_vmlinux1] Error 1
> 

y:/usr/src/25> grep PNP .config 
y:/usr/src/25> grep pnp_port_start $(find . -name '*.o')
Binary file ./drivers/built-in.o matches
Binary file ./drivers/telephony/built-in.o matches
Binary file ./drivers/telephony/ixj.o matches
Binary file ./vmlinux.o matches

I assume that drivers/telephony/ixj.c needs to depend on PNP.

Something like this.  Or maybe it should be ISAPNP.  Bjorn, could you
please check?


From: Andrew Morton <akpm@linux-foundation.org>

drivers/built-in.o: In function `pnp_port_start':
/home/tfoerste/devel/linux-2.6/include/linux/pnp.h:51: undefined reference to `pnp_get_resource'

Reported-by: Toralf F_rster <toralf.foerster@gmx.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/telephony/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/telephony/Kconfig~drivers-telephony-ixjc-depends-on-pnp drivers/telephony/Kconfig
--- a/drivers/telephony/Kconfig~drivers-telephony-ixjc-depends-on-pnp
+++ a/drivers/telephony/Kconfig
@@ -20,6 +20,7 @@ if PHONE
 config PHONE_IXJ
 	tristate "QuickNet Internet LineJack/PhoneJack support"
 	depends on ISA || PCI
+	depends on PNP
 	---help---
 	  Say M if you have a telephony card manufactured by Quicknet
 	  Technologies, Inc.  These include the Internet PhoneJACK and
_

