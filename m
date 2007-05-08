Return-Path: <linux-kernel-owner+w=401wt.eu-S1032253AbXEHVOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032253AbXEHVOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032230AbXEHVOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:14:12 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:50329
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032205AbXEHVOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:14:10 -0400
Subject: Re: [PATCH] synclink_gt add compat_ioctl
From: Paul Fulghum <paulkf@microgate.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <200705060227.29450.arnd@arndb.de>
References: <1178215277.4369.6.camel@amdx2.microgate.com>
	 <200705051258.01743.arnd@arndb.de> <463C8D42.7020707@microgate.com>
	 <200705060227.29450.arnd@arndb.de>
Content-Type: text/plain
Date: Tue, 08 May 2007 16:14:03 -0500
Message-Id: <1178658843.4152.12.camel@x2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-06 at 02:27 +0200, Arnd Bergmann wrote:

> Now that you mention the duplication, this sounds wrong as well. The easiest
> solution is probably to just put the definition of your data structure
> inside of #ifdef CONFIG_COMPAT in the header file.

The structure definition was already inside of #ifdef CONFIG_COMPAT

The problem is including linux/compat.h inside of synclink.h
causes an error on i386. The headerscheck facility is spitting
out an error even if the #include <linux/compat.h> is inside of
#ifdef CONFIG_COMPAT

make[3]: *** No rule to make target
`/usr/src/devel/usr/include/linux/.check.synclink.h', needed by
`__headerscheck'.  Stop.

linux/kexec.h includes linux/compat.h without a similar error,
though that is inside of a #ifdef CONFIG_KEXEC

Moving linux/compat.h from synclink.h to synclink_gt.c
removes the error.

This is the last error standing in my way and I'm trying
to figure out the rules for when and where you are allowed
to use compat.h, I'm not familiar with the headerscheck
facility so I'm not sure what it is looking for and the
error is not very helpful. There is nothing in Documentation
covering it.

--
Paul Fulghum
Microgate Systems, Ltd

