Return-Path: <linux-kernel-owner+w=401wt.eu-S1752161AbZI0MoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbZI0MoX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 08:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbZI0MoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 08:44:22 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:50589 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbZI0MoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 08:44:22 -0400
Message-ID: <4ABF5E21.9080104@upmc.fr>
Date: Sun, 27 Sep 2009 14:44:17 +0200
From: Bernard Pidoux <bernard.pidoux@upmc.fr>
Organization: Universite Pierre & Marie Curie - Paris 6
User-Agent: Thunderbird 2.0.0.23 (X11/20090822)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.31.1 BUG #include <asm/bitsperlong.h>
References: <4ABF4E36.4090703@upmc.fr> <4ABF5328.8020901@upmc.fr>
In-Reply-To: <4ABF5328.8020901@upmc.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I downloaded again linux-2.6.31.1.tar.bz2 and unpacked it.

ll /usr/src/linux-2.6.31.1/include/
total 128
drwxrwxr-x   3 root root  4096 2009-09-24 17:45 acpi/
lrwxrwxrwx   1 root root     7 2009-09-27 14:34 asm -> asm-x86/
drwxrwxr-x   3 root root  4096 2009-09-24 17:45 asm-generic/
drwxr-xr-x   2 root root  4096 2009-09-27 14:34 asm-x86/

and

ll /usr/src/linux-2.6.31.1/include/asm/
total 8
-rw-r--r-- 1 root root 4890 2009-09-27 14:34 asm-offsets.h

So, I think that the kernel header problem is in the linux package, not in
my system installation.

Bernard Pidoux



On Sun, Sep 27, 2009 at 01:16:41PM +0200, Bernard Pidoux wrote:
> The problem is that when I compile an application that never caused any 
> problem before I get an error due to incorrect reference to 
> <asm/bitsperlong>
>
> This was due to int-ll64.h including <asm/bitsperlong.h> which does not exists.
>
> Is the correct solution to replace symbolic link ?
>
> /usr/src/linux/include/asm->asm-x86
>
> by
>
> /usr/src/linux/include/asm->asm-generic

The correct fix is to include the missing bitsperlong in
the asm-x86 directory.
In other words your kernel headers are broken.

Looking at latest kernel we do export bitsperlong.h.
So see if you can find a fix for your broken kernel headers.

	Sam

