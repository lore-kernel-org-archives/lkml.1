Return-Path: <linux-kernel-owner+w=401wt.eu-S1764023AbXGJSZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764023AbXGJSZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbXGJSZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:25:19 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:5782 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481AbXGJSZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:25:17 -0400
Date: Tue, 10 Jul 2007 20:25:16 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Subject: Re: [x86 setup 16/33] String-handling functions for the new x86
 setup code.
In-Reply-To: <11840376162370-git-send-email-hpa@zytor.com>
Message-ID: <Pine.LNX.4.64.0707102022400.11053@fbirervta.pbzchgretzou.qr>
References: <11840359321823-git-send-email-hpa@zytor.com>
 <11840360383913-git-send-email-hpa@zytor.com> <11840361432207-git-send-email-hpa@zytor.com>
 <11840362483663-git-send-email-hpa@zytor.com> <11840363531039-git-send-email-hpa@zytor.com>
 <11840364593068-git-send-email-hpa@zytor.com> <1184036564610-git-send-email-hpa@zytor.com>
 <11840366692770-git-send-email-hpa@zytor.com> <11840367741994-git-send-email-hpa@zytor.com>
 <11840368791603-git-send-email-hpa@zytor.com> <11840369841576-git-send-email-hpa@zytor.com>
 <11840370903975-git-send-email-hpa@zytor.com> <11840371953778-git-send-email-hpa@zytor.com>
 <11840373002601-git-send-email-hpa@zytor.com> <11840374052662-git-send-email-hpa@zytor.com>
 <1184037510289-git-send-email-hpa@zytor.com> <11840376162370-git-send-email-hpa@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 9 2007 19:51, H. Peter Anvin wrote:
>
>strcmp(), memcpy(), memset(), as well as routines to copy to and from
>other segments (as pointed to by fs and gs).

I wonder, strcmp() is the only one not done in assembler.
Is there a particular reason? (Or the other way around, why
is memcpy/memset not C.) The opcode is rep[n]z cmps[bl];

Would perhaps using __builtin_memset
and whatever GCC provides also work in 16-bit mode (would save
implementing it again).

>+/*
>+ * arch/i386/boot/string.c
>+ *
>+ * Very basic string functions
>+ */
>+
>+#include "boot.h"
>+#include <linux/edd.h>

What's edd good for here?

>+int strcmp(const char *str1, const char *str2)
>+{
>+	const unsigned char *s1 = (const unsigned char *)str1;
>+	const unsigned char *s2 = (const unsigned char *)str2;
>+	int delta = 0;
>+
>+	while (*s1 || *s2) {
>+		delta = *s2 - *s1;
>+		if (delta)
>+			return delta;
>+		s1++;
>+		s2++;
>+	}
>+	return 0;
>+}



	Jan
-- 
