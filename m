Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbZFDOjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbZFDOjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 10:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754348AbZFDOjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 10:39:08 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:51168 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199AbZFDOjG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 10:39:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=CQGQ3/5X0pL7gCLmRrcvXaSYIW4h2ikAdb9XQuVnCZCYegzz5es5HnwlDD0J2PtTkQ
         493Q8zu25s+WRnWxe6c1xrlTnVY5vsTKjbh2WQ9hca6bNaa6dT+iEzaZ19lo3K+rrX+K
         ojjh5I68Y/wUk7kIJxdiHA1jtLfo1hY9gCWh4=
From: Florian Fainelli <florian@openwrt.org>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 1/8] add lib/gcd.c
Date: Thu, 4 Jun 2009 16:39:03 +0200
User-Agent: KMail/1.9.9
Cc: Linux-MIPS <linux-mips@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Takashi Iwai <tiwai@suse.de>, Ralf Baechle <ralf@linux-mips.org>
References: <200906041615.10467.florian@openwrt.org> <4A27DAAD.5000303@ru.mvista.com>
In-Reply-To: <4A27DAAD.5000303@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906041639.04868.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei,

Le Thursday 04 June 2009 16:31:09 Sergei Shtylyov, vous avez écrit :
> Hello.
>
> Florian Fainelli wrote:
> > This patch adds lib/gcd.c which contains a greatest
> > common divider implementation taken from
> > sound/core/pcm_timer.c
> >
> > Signed-off-by: Florian Fainelli <florian@openwrt.org>
>
> [...]
>
> > diff --git a/lib/gcd.c b/lib/gcd.c
> > new file mode 100644
> > index 0000000..fbf81a8
> > --- /dev/null
> > +++ b/lib/gcd.c
> > @@ -0,0 +1,20 @@
> > +#include <linux/gcd.h>
> > +#include <linux/module.h>
> > +
> > +/* Greatest common divisor */
> > +unsigned long gcd(unsigned long a, unsigned long b)
> > +{
> > +	unsigned long r;
> > +
> > +	if (a < b) {
> > +		r = a;
> > +		a = b;
> > +	b = r;
>
>     Fix indentation please.

Fixed in the following version. Also putting David in copy since it
he was not in copy of the first patch and could not know why there
is a following patch on net/netfilter/ipvs/ip_vs_wrr.c to use lib/gcd.c
--
From: Florian Fainelli <florian@openwrt.org>

This patch adds lib/gcd.c which contains a greatest
common divider implementation taken from
sound/core/pcm_timer.c

Changes from v1:
- fixed indentation
- use EXPORT_SYMBOL_GPL instead of EXPORT_SYMBOL as
suggested by Ralf Baechle

Signed-off-by: Florian Fainelli <florian@openwrt.org>
--
diff --git a/include/linux/gcd.h b/include/linux/gcd.h
new file mode 100644
index 0000000..69f5e8a
--- /dev/null
+++ b/include/linux/gcd.h
@@ -0,0 +1,8 @@
+#ifndef _GCD_H
+#define _GCD_H
+
+#include <linux/compiler.h>
+
+unsigned long gcd(unsigned long a, unsigned long b) __attribute_const__;
+
+#endif /* _GCD_H */
diff --git a/lib/Kconfig b/lib/Kconfig
index 8ade0a7..70a9906 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -10,6 +10,9 @@ menu "Library routines"
 config BITREVERSE
 	tristate
 
+config GCD
+	bool
+
 config GENERIC_FIND_FIRST_BIT
 	bool
 
diff --git a/lib/Makefile b/lib/Makefile
index 33a40e4..389bdd2 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -57,6 +57,7 @@ obj-$(CONFIG_CRC_ITU_T)	+= crc-itu-t.o
 obj-$(CONFIG_CRC32)	+= crc32.o
 obj-$(CONFIG_CRC7)	+= crc7.o
 obj-$(CONFIG_LIBCRC32C)	+= libcrc32c.o
+obj-$(CONFIG_GCD)	+= gcd.o
 obj-$(CONFIG_GENERIC_ALLOCATOR) += genalloc.o
 
 obj-$(CONFIG_ZLIB_INFLATE) += zlib_inflate/
diff --git a/lib/gcd.c b/lib/gcd.c
new file mode 100644
index 0000000..6634741
--- /dev/null
+++ b/lib/gcd.c
@@ -0,0 +1,20 @@
+#include <linux/gcd.h>
+#include <linux/module.h>
+
+/* Greatest common divisor */
+unsigned long gcd(unsigned long a, unsigned long b)
+{
+	unsigned long r;
+
+	if (a < b) {
+		r = a;
+		a = b;
+		b = r;
+	}
+	while ((r = a % b) != 0) {
+		a = b;
+		b = r;
+	}
+	return b;
+}
+EXPORT_SYMBOL_GPL(gcd);
