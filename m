Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952AbYEZTHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbYEZTHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 15:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754720AbYEZTH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 15:07:29 -0400
Received: from animx.eu.org ([216.98.75.249]:44223 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754700AbYEZTH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 15:07:29 -0400
Date: Mon, 26 May 2008 15:07:37 -0400
From: Wakko Warner <wakko@animx.eu.org>
To: linux-kernel@vger.kernel.org
Subject: Compile error with make bootpfile (2.6.25.4)
Message-ID: <20080526190737.GA14703@animx.eu.org>
Mail-Followup-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6+20040907i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm cross compiling a kernel for my alpha on x86.  I'm seeing this:
  gcc -Wp,-MD,arch/alpha/boot/tools/.objstrip.d -Iarch/alpha/boot -Wall -Wstrict-prototypes -O2 -fomit-frame-pointer -o arch/alpha/boot/tools/objstrip /usr/src/linux/dist/2.6.25.4/arch/alpha/boot/tools/objstrip.c
/usr/src/linux/dist/2.6.25.4/arch/alpha/boot/tools/objstrip.c: In function 'main':
/usr/src/linux/dist/2.6.25.4/arch/alpha/boot/tools/objstrip.c:189: warning: format '%#016lx' expects type 'long unsigned int', but argument 5 has type 'Elf32_Addr'
/usr/src/linux/dist/2.6.25.4/arch/alpha/boot/tools/objstrip.c:196: error: 'struct exec' has no member named 'fh'
/usr/src/linux/dist/2.6.25.4/arch/alpha/boot/tools/objstrip.c:202: error: 'struct exec' has no member named 'fh'
/usr/src/linux/dist/2.6.25.4/arch/alpha/boot/tools/objstrip.c:202: error: 'struct exec' has no member named 'ah'
/usr/src/linux/dist/2.6.25.4/arch/alpha/boot/tools/objstrip.c:214: error: 'struct exec' has no member named 'ah'
/usr/src/linux/dist/2.6.25.4/arch/alpha/boot/tools/objstrip.c:214: error: 'struct exec' has no member named 'ah'
/usr/src/linux/dist/2.6.25.4/arch/alpha/boot/tools/objstrip.c:215: error: 'struct exec' has no member named 'ah'
/usr/src/linux/dist/2.6.25.4/arch/alpha/boot/tools/objstrip.c:219: error: 'struct exec' has no member named 'ah'
/usr/src/linux/dist/2.6.25.4/arch/alpha/boot/tools/objstrip.c:220: error: 'struct exec' has no member named 'ah'
/usr/src/linux/dist/2.6.25.4/arch/alpha/boot/tools/objstrip.c:263: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'size_t'
make[2]: *** [arch/alpha/boot/tools/objstrip] Error 1
make[1]: *** [bootpfile] Error 2
make: *** [sub-make] Error 2
make: Leaving directory `/usr/src/linux/dist/2.6.25.4'

I called make like this:
make -C /usr/src/linux/dist/2.6.25.4 O=$PWD ARCH=alpha V=1 CROSS_COMPILE=alpha-linux-gnu- bootpfile

My host gcc is:
gcc (GCC) 4.1.3 20070514 (prerelease) (Debian 4.1.2-7)

My target gcc is:
alpha-linux-gnu-gcc (GCC) 4.1.3 20070514 (prerelease) (Debian 4.1.2-7)

I decided to just copy over the sources so that I wouldn't need the -C and
O= on the make line.  I also modified the Make file so that I didn't need to
specify ARCH and CROSS_COMPILE.  I removed support for a.out in objstrip.  I
was finally able to get it to compile, but it still didn't work.  Not sure
if it was due to the fact it's using x86 headers instead of alpha headers or
what.

I tried asking on linux-alpha, but that list seems to be fairly dead.

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
