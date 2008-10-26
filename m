Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbYJZKlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbYJZKlS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 06:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbYJZKlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 06:41:10 -0400
Received: from 1wt.eu ([62.212.114.60]:4937 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbYJZKlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 06:41:09 -0400
Date: Sun, 26 Oct 2008 11:41:04 +0100
From: Willy Tarreau <w@1wt.eu>
To: =?iso-8859-1?Q?J=F6rg?= Dohle <j.d.-linux-kernel@arcor.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How can I build a 2.4 kernel on a 2.6 System
Message-ID: <20081026104103.GW24654@1wt.eu>
References: <16891148.1224850600689.JavaMail.ngmail@webmail18.arcor-online.net> <20081024202955.GT24654@1wt.eu> <20CDA8F07DE345B8AA01B3C43EE8A6F7@pc686xpp>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20CDA8F07DE345B8AA01B3C43EE8A6F7@pc686xpp>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2008 at 11:32:17AM +0100, Jörg Dohle wrote:
> Hello Willy
> 
> Thanks for answering, but I have a problem with the compiling.
> When I try to compile the 2.4 kernel with the following commands:
> 
> # make clean && make mrproper
> then I restore the .config file
> # make oldconfig
> # make dep && make bzImage respectively make modules
> 
> 
> I get the following error message:
> 
> make[1]: Leaving directory 
> `/fileserver/99_Frei/kernel-build-tree/linux-2.4.21-57.EL'

OK, first it's an RHEL3 kernel, not a mainline one. The difference can
sometimes be important.

> gcc -D__KERNEL__ 
> -I/fileserver/99_Frei/kernel-build-tree/linux-2.4.21-57.EL/include -Wall 
> -Wstrict-prototypes -Wno-trigraphs -O2 -fno-strict-aliasing -fno-common 
>  -Wno-unused -fomit-frame-pointer -pipe -freorder-blocks  -march=i386   
>  -DKBUILD_BASENAME=main -c -o init/main.o init/main.c
> init/main.c:1: Fehler: Die ausgewählte CPU unterstützt nicht den x86-64 
> Befehlssatz
> 
> English translation (by google)
> init / main.c: 1: Error: The selected CPU does not support x86-64 
> instruction

You might get native error messages by doing "export LANG=C" before
building. I think that the problem you're encountering is simply
because by default you're trying to build for a different architecture.

You should try appending "ARCH=i386" to all your make commands :

# make oldconfig ARCH=i386
# make dep ARCH=i386 && make bzImage ARCH=i386
# make modules ARCH=i386

It should theorically work, but since this is not used very often, it is
possible that you still get minor trouble.

Regards,
Willy

