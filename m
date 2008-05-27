Return-Path: <linux-kernel-owner+w=401wt.eu-S1758564AbYE0SZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564AbYE0SZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 14:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759122AbYE0SYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 14:24:44 -0400
Received: from gv-out-0910.google.com ([216.239.58.191]:4855 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759047AbYE0SYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 14:24:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uWbF+BtqeRsrxkc2pVa40QZWqMuUlkDT4XK2tB/qBZ9vhbe8qOmcMWa+EGaXgOjmcQUC+mAMSVBbvaOqllIr3hlkOEB0s4Czn/iLE5DjQb+LvzPbWAgE82rUaiLi4f9fj5JMVKfXj75Up36EG2WCYMiJwyOCRmywS09PbPil5TQ=
Message-ID: <b9df5fa10805271124n5d7e0b51ma73175688d6b4b34@mail.gmail.com>
Date: Wed, 28 May 2008 00:24:41 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Compile error with make bootpfile (2.6.25.4)
In-Reply-To: <20080526190737.GA14703@animx.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080526190737.GA14703@animx.eu.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/27/08, Wakko Warner <wakko@animx.eu.org> wrote:
> I'm cross compiling a kernel for my alpha on x86.  I'm seeing this:
>   gcc -Wp,-MD,arch/alpha/boot/tools/.objstrip.d -Iarch/alpha/boot -Wall -Wstrict-prototypes -O2 -fomit-frame-pointer -o arch/alpha/boot/tools/objstrip /usr/src/linux/dist/2.6.25.4/arch/alpha/boot/tools/objstrip.c
>  /usr/src/linux/dist/2.6.25.4/arch/alpha/boot/tools/objstrip.c: In function 'main':
>  /usr/src/linux/dist/2.6.25.4/arch/alpha/boot/tools/objstrip.c:189: warning: format '%#016lx' expects type 'long unsigned int', but argument 5 has type 'Elf32_Addr'
>  /usr/src/linux/dist/2.6.25.4/arch/alpha/boot/tools/objstrip.c:196: error: 'struct exec' has no member named 'fh'
>  /usr/src/linux/dist/2.6.25.4/arch/alpha/boot/tools/objstrip.c:202: error: 'struct exec' has no member named 'fh'
>  /usr/src/linux/dist/2.6.25.4/arch/alpha/boot/tools/objstrip.c:202: error: 'struct exec' has no member named 'ah'
>  /usr/src/linux/dist/2.6.25.4/arch/alpha/boot/tools/objstrip.c:214: error: 'struct exec' has no member named 'ah'
>  /usr/src/linux/dist/2.6.25.4/arch/alpha/boot/tools/objstrip.c:214: error: 'struct exec' has no member named 'ah'
>  /usr/src/linux/dist/2.6.25.4/arch/alpha/boot/tools/objstrip.c:215: error: 'struct exec' has no member named 'ah'
>  /usr/src/linux/dist/2.6.25.4/arch/alpha/boot/tools/objstrip.c:219: error: 'struct exec' has no member named 'ah'
>  /usr/src/linux/dist/2.6.25.4/arch/alpha/boot/tools/objstrip.c:220: error: 'struct exec' has no member named 'ah'
>  /usr/src/linux/dist/2.6.25.4/arch/alpha/boot/tools/objstrip.c:263: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'size_t'
>  make[2]: *** [arch/alpha/boot/tools/objstrip] Error 1
>  make[1]: *** [bootpfile] Error 2
>  make: *** [sub-make] Error 2
>  make: Leaving directory `/usr/src/linux/dist/2.6.25.4'
>
>  I called make like this:
>  make -C /usr/src/linux/dist/2.6.25.4 O=$PWD ARCH=alpha V=1 CROSS_COMPILE=alpha-linux-gnu- bootpfile
>
>  My host gcc is:
>  gcc (GCC) 4.1.3 20070514 (prerelease) (Debian 4.1.2-7)
>
>  My target gcc is:
>  alpha-linux-gnu-gcc (GCC) 4.1.3 20070514 (prerelease) (Debian 4.1.2-7)
>
>  I decided to just copy over the sources so that I wouldn't need the -C and
>  O= on the make line.  I also modified the Make file so that I didn't need to
>  specify ARCH and CROSS_COMPILE.  I removed support for a.out in objstrip.  I
>  was finally able to get it to compile, but it still didn't work.  Not sure
>  if it was due to the fact it's using x86 headers instead of alpha headers or
>  what.
>
>  I tried asking on linux-alpha, but that list seems to be fairly dead.
>
>  --
>   Lab tests show that use of micro$oft causes cancer in lab animals
>   Got Gas???
>
> --
>  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  Please read the FAQ at  http://www.tux.org/lkml/
>

In u'r .config file , have u enable for both ELF & a.out support.
