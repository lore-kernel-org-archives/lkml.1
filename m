Return-Path: <linux-kernel-owner+w=401wt.eu-S964807AbZGQORh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964807AbZGQORh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 10:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934674AbZGQORg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 10:17:36 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:64378 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934662AbZGQORg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 10:17:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=fyY0EdGTLzlEzBtZuSMGs4ZqKCaL6vqO2YbohZVGOANuRgdcQY6CaD9aBVljRLRphk
         U6Y1+41U6Frrn68fE8cn/W/M+8tqJafe9872ONekTP2A2tbfJrJwaJ7TuPsp9ny/v1cT
         4vynWCIa5CBRoxUrlHGS2GlYL6mf+tAtiCGEA=
Message-ID: <4A60886E.5070106@gmail.com>
Date: Fri, 17 Jul 2009 16:19:26 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Bernd Petrovitsch <bernd@firmix.at>
CC: mingo@redhat.com, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ia32: strncpy does not null terminate string
References: <4A60755F.4030604@gmail.com>
In-Reply-To: <4A60755F.4030604@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

strlcpy() will always null terminate the string.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
> The proof is flawed: Global variables are automatically '\0'
> initialized.

Hmm, I see, how about using strlcpy instead?

diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
index 085a8c3..528972f 100644
--- a/arch/x86/ia32/sys_ia32.c
+++ b/arch/x86/ia32/sys_ia32.c
@@ -687,7 +687,7 @@ long sys32_vm86_warning(void)
 		compat_printk(KERN_INFO
 			      "%s: vm86 mode not supported on 64 bit kernel\n",
 			      me->comm);
-		strncpy(lastcomm, me->comm, sizeof(lastcomm));
+		strlcpy(lastcomm, me->comm, sizeof(lastcomm));
 	}
 	return -ENOSYS;
 }
