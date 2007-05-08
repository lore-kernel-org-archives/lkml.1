Return-Path: <linux-kernel-owner+w=401wt.eu-S1032479AbXEHWIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032479AbXEHWIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbXEHWIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:08:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:51271 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881AbXEHWIJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:08:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Fulghum <paulkf@microgate.com>
Subject: Re: [PATCH] synclink_gt add compat_ioctl
Date: Wed, 9 May 2007 00:07:53 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1178215277.4369.6.camel@amdx2.microgate.com> <200705060227.29450.arnd@arndb.de> <1178658843.4152.12.camel@x2.microgate.com>
In-Reply-To: <1178658843.4152.12.camel@x2.microgate.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705090007.53613.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18lRJLCETHBoNnRbeiNkuzZyMB23YQ08O8DE7/
 mgwKh6ZTyIraJ9jhSIgFlL5bnL8GUkvssV/B1PGbnoyGgyIqCm
 pDgyFpD1Z+SpG9Y7TFlTA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 May 2007, Paul Fulghum wrote:
> make[3]: *** No rule to make target
> `/usr/src/devel/usr/include/linux/.check.synclink.h', needed by
> `__headerscheck'.  Stop.
> 
> linux/kexec.h includes linux/compat.h without a similar error,
> though that is inside of a #ifdef CONFIG_KEXEC
> 
> Moving linux/compat.h from synclink.h to synclink_gt.c
> removes the error.
> 
> This is the last error standing in my way and I'm trying
> to figure out the rules for when and where you are allowed
> to use compat.h, I'm not familiar with the headerscheck
> facility so I'm not sure what it is looking for and the
> error is not very helpful. There is nothing in Documentation
> covering it.

The warning is about the situation that linux/synclink.h gets
installed by make headers_install, but linux/compat.h does not
get installed, so any user program including linux/synclink.h
will fail to build.

To solve this, you can to change include/linux/Kbuild to list
synclink.h as unifdef-y instead of header-y, and put the parts
that you don't want to be in user space inside of #ifdef __KERNEL__.

Alternatively, you can put these kernel-internal definitions into
a private header file in drivers/char that does not get installed
in the first place. That would be particularly useful if you can
also move other parts of linux/synclink.h into the private header,
when they are not part of the external ABI.

	Arnd <><
