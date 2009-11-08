Return-Path: <linux-kernel-owner+w=401wt.eu-S1754249AbZKHPyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbZKHPyI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 10:54:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbZKHPyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 10:54:07 -0500
Received: from borg.medozas.de ([188.40.89.202]:37014 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478AbZKHPyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 10:54:06 -0500
Date: Sun, 8 Nov 2009 16:54:11 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: =?UTF-8?Q?Andr=C3=A9_Goddard_Rosa?= <andre.goddard@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 10/12] string: factorize skip_spaces and export it to
 be generally available
In-Reply-To: <c7d3b02b5e28eaa54a5360d57dfd177c44320187.1257602781.git.andre.goddard@gmail.com>
Message-ID: <alpine.LSU.2.00.0911081651020.26458@obet.zrqbmnf.qr>
References: <cover.1257602781.git.andre.goddard@gmail.com> <c7d3b02b5e28eaa54a5360d57dfd177c44320187.1257602781.git.andre.goddard@gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 2009-11-07 16:16, André Goddard Rosa wrote:

> /**
>+ * skip_spaces - Removes leading whitespace from @s.
>+ * @s: The string to be stripped.
>+ *
>+ * Returns a pointer to the first non-whitespace character in @s.
>+ */
>+const char *skip_spaces(const char *str)
>+{
>+	while (isspace(*str))
>+		++str;
>+	return str;
>+}
>+EXPORT_SYMBOL(skip_spaces);
>+

I would make this
	char *skip_spaces(const char *)

just like most of the stdc functions, so that you do not need
ugly casts like this (v) in callers of skip_spaces.

>-	while (*s && isspace(*s))
>-		s++;
>-
>-	return s;
>+	return (char *)skip_spaces(s);
> }
> EXPORT_SYMBOL(strstrip);
