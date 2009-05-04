Return-Path: <linux-kernel-owner+w=401wt.eu-S1753691AbZEDHHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbZEDHHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 03:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbZEDHH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 03:07:26 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:41432 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbZEDHHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 03:07:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=BUubZiInb8sOMFbdy9EpH9tTZ40pBNP07k1kaP7Ym765hyhLOFZnzIUSIcpeSfeB2L
         oL8fGV6XhAgaZ6ZJBgWwK/jft2N53XY6jy4S4RZiRiy5HIRfTcLrkXrSPO+l7YHwMkRj
         XL4hsITE8WXBMxm3+4GUEWHjTj5++zuNAGqb4=
MIME-Version: 1.0
In-Reply-To: <19d8a91dbf3456f9eb0b0bb2f92b302b88a1c672.1241105648.git.arnd@arndb.de>
References: <cover.1241105648.git.arnd@arndb.de>
	 <19d8a91dbf3456f9eb0b0bb2f92b302b88a1c672.1241105648.git.arnd@arndb.de>
Date: Mon, 4 May 2009 09:07:23 +0200
X-Google-Sender-Auth: 9283bcf923f12aaa
Message-ID: <10f740e80905040007x38dfcdc5i4a7d351e59db71e9@mail.gmail.com>
Subject: Re: [PATCH 05/27] asm-generic: add generic io.h
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n4477fqu015864

On Thu, Nov 6, 2008 at 15:38, Arnd Bergmann <arnd@arndb.de> wrote:> --- /dev/null> +++ b/include/asm-generic/io.h
> +static inline void insb(unsigned long addr, void *buffer, int count)> +{> +       if (count) {> +               u8 *buf = buffer;> +               do {> +                       u8 x = inb(addr);> +                       *buf++ = x;> +               } while (--count);> +       }> +}> +> +static inline void insw(unsigned long addr, void *buffer, int count)> +{> +       if (count) {> +               u16 *buf = buffer;> +               do {> +                       u16 x = inw(addr);> +                       *buf++ = x;> +               } while (--count);> +       }> +}> +> +static inline void insl(unsigned long addr, void *buffer, int count)> +{> +       if (count) {> +               u32 *buf = buffer;> +               do {> +                       u32 x = inl(addr);> +                       *buf++ = x;> +               } while (--count);> +       }> +}> +> +static inline void outsb(unsigned long addr, const void *buffer, int count)> +{> +       if (count) {> +               const u8 *buf = buffer;> +               do {> +                       outb(*buf++, addr);> +               } while (--count);> +       }> +}> +> +static inline void outsw(unsigned long addr, const void *buffer, int count)> +{> +       if (count) {> +               const u16 *buf = buffer;> +               do {> +                       outw(*buf++, addr);> +               } while (--count);> +       }> +}> +> +static inline void outsl(unsigned long addr, const void *buffer, int count)> +{> +       if (count) {> +               const u32 *buf = buffer;> +               do {> +                       outl(*buf++, addr);> +               } while (--count);> +       }> +}
Do we ever call these with count == 0?
> +/*> + * Change "struct page" to physical address.> + */
Which `struct page'?
> +static inline void *__ioremap(unsigned long offset, unsigned long size,> +                             unsigned long flags)> +{> +       return (void *) offset;> +}> +> +static inline void *ioremap(unsigned long offset, unsigned long size)> +{> +       return (void *) offset;> +}
Gr{oetje,eeting}s,
						Geert
--Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
In personal conversations with technical people, I call myself a hacker. Butwhen I'm talking to journalists I just say "programmer" or something like that.							    -- Linus Torvalds���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
