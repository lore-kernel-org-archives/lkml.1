Return-Path: <linux-kernel-owner+w=401wt.eu-S1762158AbXKPLgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762158AbXKPLgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 06:36:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbXKPLgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 06:36:10 -0500
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:36156 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752500AbXKPLgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 06:36:09 -0500
Date: Fri, 16 Nov 2007 13:37:47 +0100
From: Andreas Herrmann <aherrman@arcor.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Kconfig: ARCH=x86 causes wrong utsname.machine
Message-ID: <20071116123747.GA12086@devil>
References: <20071116111446.GA16968@devil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071116111446.GA16968@devil>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The new ARCH=x86 kernel build causes weired machine strings on 32-bit.
For a cross-compiled kernel I have

	 $ uname -m
	 x66_64

For a kernel natively built on a 32 bit machine I have

	$ uname -m  
	x66

Looking at the sources, I think that utsname->machine was initially
set as "x86_64" and "x86", respectively.
But in arch/x86/kernel/cpu/bugs.c in check_bugs() the second character
is set to '6' on my K7.

I think the right solution for that problem is to use "x86_64" as the
machine name for 64-bit and to keep the old "i[3456]86" strings for
32-bit kernels.

Several tools (e.g. the kernel build itself) will be confused
otherwise (*).


Regards,

Andreas


(*) Example:
$ uname -m
x66_64
$ make menuconfig
Makefile:425: /projects/linux-2.6-x86/arch/x66_64/Makefile: No such file or directory
make: *** No rule to make target `/projects/linux-2.6-x86/arch/x66_64/Makefile'.  Stop.

