Return-Path: <linux-kernel-owner+w=401wt.eu-S1753610AbXIKOa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbXIKOa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 10:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbXIKOaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 10:30:22 -0400
Received: from accolon.hansenpartnership.com ([64.109.89.108]:55477 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751071AbXIKOaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 10:30:22 -0400
Subject: Re: build #286 failed for 2.6.23-rc6-g0d4cbb5 in
	linux/arch/i386/mach-voyager/setup.c
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: bwalle@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <200709111621.39060.toralf.foerster@gmx.de>
References: <200709111621.39060.toralf.foerster@gmx.de>
Content-Type: text/plain; charset=utf-8
Date: Tue, 11 Sep 2007 09:30:15 -0500
Message-Id: <1189521015.5351.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-11 at 16:21 +0200, Toralf Förster wrote:
> Hello,
> 
> the build with the attached .config failed, make ends with:
> ...
>   CC      arch/i386/mm/highmem.o
>   LD      arch/i386/mm/built-in.o
>   CC      arch/i386/mach-voyager/setup.o
> arch/i386/mach-voyager/setup.c: In function 'time_init_hook':
> arch/i386/mach-voyager/setup.c:52: error: implicit declaration of function 'safe_smp_processor_id'

This should be a warning, not an error

> make[1]: *** [arch/i386/mach-voyager/setup.o] Error 1
> make: *** [arch/i386/mach-voyager] Error 2

> The build was made with an old .config from kernel 2.6.22-rc3
> (where the build also failed) :
> $> make mrproper && cp <oldconfig> .config && make oldconfig && make
> 
> Here's the config:
[...]
> # CONFIG_SMP is not set

This is the problem ... it's a known one on voyager.  This will prevent
the config being selected by the random config generator.

James

diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
index 97b64d7..cca3b90 100644
--- a/arch/i386/Kconfig
+++ b/arch/i386/Kconfig
@@ -146,6 +146,7 @@ config X86_ELAN
 
 config X86_VOYAGER
 	bool "Voyager (NCR)"
+	select SMP if !BROKEN
 	help
 	  Voyager is an MCA-based 32-way capable SMP architecture proprietary
 	  to NCR Corp.  Machine classes 345x/35xx/4100/51xx are Voyager-based.


