Return-Path: <linux-kernel-owner+w=401wt.eu-S1756660AbZBEIrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbZBEIrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 03:47:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbZBEIrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 03:47:21 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:58645 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbZBEIrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 03:47:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=nr19IYSRzPUM/v3XN/f4fx2YDMmp6PAQAAOC/SG2GZhmyzaM/qINeZvjXHyiIax6V+
         M2Po2CklzG1DGXJAyQUjPNJxbyykMadUy2HlwSfTDDnNijt8zYW0JSA6i8joZSHp+UTd
         yUiHiO3sCwzBeqECHn2oKKK8faxqi5GmOjyso=
MIME-Version: 1.0
Date: Thu, 5 Feb 2009 09:47:18 +0100
Message-ID: <56e1b5710902050047h2c58eec7l812a838491a0256a@mail.gmail.com>
Subject: [PATCH] Kbuild: Enable the gcc flag -Wformat-security (was: Re: 
	[PATCH] Kbuild: Disable the -Wformat-security gcc flag)
From: Floris Kraak <randakar@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Robert Hancock <hancockrwd@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trivial Patch Monkey <trivial@kernel.org>,
       Roland Dreier <rdreier@cisco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 5, 2009 at 9:26 AM, Floris Kraak <randakar@gmail.com> wrote:
>
> As I noted applying a patch that does the reverse and enables the
> check instead is perfectly acceptable to me. Long term somebody
> probably needs to go through all of them and fix (most of) them
> anyway.
>

Here goes:

[PATCH] Kbuild: Enable the gcc flag -Wformat-security

Some distributions have enabled the gcc flag -Wformat-security by
default. This causes about 150 new warnings to show up in an
allyesconfig kernel build that are never seen by the majority of the
developers. However there is some value to having this warning. In
some cases there are potential (security) bugs involved where
malicious or simply malformed data from outside the kernel could
trigger stack overflows or other nastyness. Instead of having a
cleanup team running around in perpetuity going over all new format
strings in code it's better to just emit the warning in all cases.

Signed-off-by: Floris Kraak <randakar@gmail.com>
---
diff --git a/Makefile b/Makefile
index 7715b2c..ed3b973 100644
--- a/Makefile
+++ b/Makefile
@@ -346,7 +346,8 @@ KBUILD_CPPFLAGS := -D__KERNEL__

 KBUILD_CFLAGS   := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
 		   -fno-strict-aliasing -fno-common \
-		   -Werror-implicit-function-declaration
+		   -Werror-implicit-function-declaration \
+		   -Wformat-security
 KBUILD_AFLAGS   := -D__ASSEMBLY__

 # Read KERNELRELEASE from include/config/kernel.release (if it exists)
---
"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."
  -- Ben Franklin

"The course of history shows that as a government grows, liberty
decreases."
  -- Thomas Jefferson
