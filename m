Return-Path: <linux-kernel-owner+w=401wt.eu-S933576AbZHGUBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933576AbZHGUBb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 16:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933185AbZHGUBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 16:01:31 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34820 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933520AbZHGUBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 16:01:30 -0400
Date: Fri, 7 Aug 2009 21:00:01 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: Matthieu CASTET <matthieu.castet@parrot.com>, Alain Knaff <alain@knaff.lu>,
       "sam@ravnborg.org" <sam@ravnborg.org>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/6] Add support for LZO-compressed kernels for ARM
Message-ID: <20090807200001.GE31543@n2100.arm.linux.org.uk>
References: <1249311501-23102-3-git-send-email-albin.tonnerre@free-electrons.com> <1249311501-23102-4-git-send-email-albin.tonnerre@free-electrons.com> <20090806224055.GH31579@n2100.arm.linux.org.uk> <20090807092423.GA4455@laptop> <4A7BF5B8.4030907@knaff.lu> <20090807102117.GB4455@laptop> <4A7C14EB.1060701@parrot.com> <20090807130130.GE4455@laptop> <4A7C2BA4.7030408@parrot.com> <20090807135524.GF4455@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090807135524.GF4455@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 03:55:24PM +0200, Albin Tonnerre wrote:
> That's true for the actual kernel image, but not for the bootstrap code we use
> when compiling compressed kernels. arch/arm/boot/compressed/Makefile uses
> libgcc, unless I'm overlooking something here:
> 
>   arm-unknown-linux-uclibcgnueabi-ld -EL    --defsym zreladdr=0x20008000
>   --defsym initrd_phys=0x20410000 --defsym params_phys=0x20000100 -p
>   --no-undefined -X
>   /home/albin/x-tools/arm-unknown-linux-uclibcgnueabi/lib/gcc/arm-unknown-linux-uclibcgnueabi/4.3.2/libgcc.a
>   -T arch/arm/boot/compressed/vmlinux.lds arch/arm/boot/compressed/head.o
>   arch/arm/boot/compressed/piggy.gzip.o arch/arm/boot/compressed/misc.o -o
>   arch/arm/boot/compressed/vmlinux

It's because libgcc appears in the wrong place in the command line, and
due to the way kbuild works, we can't get it into the right place easily.

Linkers are sensitive to the order of archives on the command line - its
pointless having an archive as the first file argument because none of
the contained objects will ever be pulled in.

Sam - any ideas how to solve this?
