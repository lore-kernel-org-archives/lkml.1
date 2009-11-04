Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759AbZKDJ2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbZKDJ2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 04:28:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbZKDJ2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 04:28:42 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:50554 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbZKDJ2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 04:28:40 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Subject: Re: [PATCH] asm-generic: Fix typo in asm-generic/unistd.h.
Date: Wed, 4 Nov 2009 10:28:11 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       liqin.gnu@gmail.com, Greg KH <greg@kroah.com>
References: <OFC90831A4.A99EC411-ON48257664.00080761-48257664.0009EC42@sunplusct.com>
In-Reply-To: <OFC90831A4.A99EC411-ON48257664.00080761-48257664.0009EC42@sunplusct.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="gb2312"
Content-Transfer-Encoding: 8bit
Message-Id: <200911041028.12098.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/cNp8DfBgtJg0blh7lbi1O+gamMEYCdV7/+si
 Yc8Z2Z5OKJma4EdqvV0bogpT9z6+B6ptf29DlKic4qXuDvIsgW
 9LFslMygCdtHpeynqovzA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 November 2009, liqin.chen@sunplusct.com wrote:
> Arnd Bergmann <arnd@arndb.de> Ð´ÓÚ 2009-11-03 16:52:17:
> 
> > Is there any reason to use glibc-2.5 though? The current release
> > is 2.10.1, and the version you used is over three years old.
> 
> We found many stable toolchain use glibc-2.5. so we select it.
> In fact, what we think first is to could used it in product¡£

It is unfortunately a common misunderstanding that older releases
that are currently used by others are more stable. The reason
you find glibc-2.5 in products today is that it was the current
version at the time when the development cycle for the product
was started.

In general, when you upgrade to a more recent version, the
best idea is to take the latest stable release, and stabilizing
on that for a given embedded product. By always using the latest
version, you can greatly reduce the amount of work needed for
each upgrade, and you get all improvements and bug fixes
automatically without having to backport them.

> Even linux kernel, in company we still use kernel-2.6.27 version.

Yes, that is good and expected, if that version has proven to be
stable for you.

Obviously you will have to do an update at some point and then
you can easily move to the latest kernel version since it is now
upstream.

I also expect that you have device driver code that is not yet
upstream. Getting that in should be a lot easier than the initial
architecture code and Greg KH can help you with his drivers/staging
infrastructure if you are interested.
  
> > Do you have plans to merge your port into eglibc when it's done?
> 
> We have not this plan now.

I would recommend to look into this at some point in the future.
Unlike the main glibc project, eglibc[1] is specifically there for
supporting embedded architectures and already hosts ports for
other platforms that are not in glibc itself, while it closely
follows the main glibc development. Contributing there unfortunately
requires some paperwork for copyright assignment, but it's probably
worth it in the end.

You've done the right thing by merging your kernel code into the
official Linux tree, porting your glibc code to the lastest 
snapshot and submitting it into eglibc is the next big step.

	Arnd <><

--
[1] http://www.eglibc.org/
