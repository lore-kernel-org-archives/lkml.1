Return-Path: <linux-kernel-owner+w=401wt.eu-S1759653AbXIYRDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759653AbXIYRDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 13:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbXIYRDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 13:03:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45437 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751903AbXIYRDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 13:03:07 -0400
Date: Tue, 25 Sep 2007 10:02:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Badari Pulavarty <pbadari@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, ak@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.23-rc8 (build failure from -rc1)
Message-Id: <20070925100233.dfe3a37f.akpm@linux-foundation.org>
In-Reply-To: <1190739421.13955.34.camel@dyn9047017100.beaverton.ibm.com>
References: <alpine.LFD.0.999.0709241740170.3579@woody.linux-foundation.org>
	<1190739421.13955.34.camel@dyn9047017100.beaverton.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007 09:57:01 -0700 Badari Pulavarty <pbadari@gmail.com> wrote:

> On Mon, 2007-09-24 at 17:46 -0700, Linus Torvalds wrote:
> > Ok, I think I'm getting close to releasing a real 2.6.23. Things seem to 
> > have calmed down, and I think Thomas Gleixner may have found the 
> > suspend/resume regression that has dogged us for a while, so I'm feeling 
> > happy about things.
> > 
> > Of course, me feeling happy is usually immediately followed by some nasty 
> > person finding new problems, but I'll just ignore that and enjoy the 
> > feeling anyway, however fleeting it may be.
> 
> I don't want to be the "nasty" person, but one of my machines doesn't
> like 2.6.23-rc8. Infact, 2.6.23-rc1 was the first kernel this is broken.
> (I didn't get hands on this machine till now).
> 
> Since my other x86-64 machines are doing fine, I am going to blame it
> on my machine specific config :)
> 
> Thanks,
> Badari
> 
> 
> elm3a242:/usr/src/linux-2.6.23-rc8 # make -j4 bzImage
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/linux/compile.h
>   SYSCALL arch/x86_64/vdso/vdso.so
> /usr/lib64/gcc-lib/x86_64-suse-linux/3.3.3/../../../../x86_64-suse-
> linux/bin/ld: section .text [ffffffffff700500 -> ffffffffff700797]
> overlaps section .dynstr [ffffffffff7004b8 -> ffffffffff700510]
> collect2: ld returned 1 exit status
> make[1]: *** [arch/x86_64/vdso/vdso.so] Error 1
> make: *** [arch/x86_64/vdso] Error 2
> make: *** Waiting for unfinished jobs....
> 

<goes fishing in Andi's tree>

box:/usr/src/25> grep vdso series                          
x86_64-mm-vdso-text-offset.patch
x86_64-mm-vdso-compat-install-unstripped-copies-on-disk.patch
x86_64-mm-vdso-64bit-install-unstripped-copies-on-disk.patch
fix-discrepancy-between-vdso-based-gettimeofday-and-sys_gettimeofday.patch


x86_64-mm-vdso-text-offset.patch looks likely - can you test it please?




Increase VDSO_TEXT_OFFSET for ancient binutils

For some reason old binutils genertate larger headers so
increase the text offset of the vdso to avoid linker errors.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/vdso/voffset.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86_64/vdso/voffset.h
===================================================================
--- linux.orig/arch/x86_64/vdso/voffset.h
+++ linux/arch/x86_64/vdso/voffset.h
@@ -1 +1 @@
-#define VDSO_TEXT_OFFSET 0x500
+#define VDSO_TEXT_OFFSET 0x600

