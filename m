Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbZFNKK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbZFNKK1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 06:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbZFNKKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 06:10:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62396 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbZFNKKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 06:10:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH] asm-generic: uaccess: fix up local access_ok() usage
Date: Sun, 14 Jun 2009 12:10:17 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1244903447-23579-1-git-send-email-vapier@gentoo.org> <200906132253.39879.arnd@arndb.de> <8bd0f97a0906131747odfe851chebfef9a541fa5c58@mail.gmail.com>
In-Reply-To: <8bd0f97a0906131747odfe851chebfef9a541fa5c58@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200906141210.17922.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+bEJ5axsuZEoXiVkUHfrju2t6z6iYxZ7/+6MZ
 85YnpmVHA/7Sdd0iG+CdZkvs7oZN8Z5ceoTbx0O3IChqEMemxT
 lsvDXa4LhnMDz5sGO1n+g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 June 2009, Mike Frysinger wrote:
> well, if you dont mind a bit of cruft, you can undef it ;)
> #include <asm-generic/uaccess.h>
> #undef access_ok

That will only work for the users outside of uaccess.h, so it doesn't
solve this problem.

> the Blackfin port does have hardware memory protection (MPU) and it
> does handle r/w/x bits, but we havent merged this into access_ok yet,
> just the vma lists

Hmm, if the hardware can catch memory protection errors, why would
you want to check them again in access_ok()? Are the checks disabled
in kernel mode? Most implementations of access_ok only check if the
address is a kernel or user pointer, because the kernel can access
both on most architectures, and the MMU only protects you from
passing invalid pointers, not valid kernel pointers.

> > What I really got wrong was the prototype for __access_ok(), as you
> > showed in your follow-up. I only tested this with the microblaze
> > patch that overrides __access_ok() with an architecture specific
> > version that gets this part right.
> 
> yeah, that looks good, but i'd still like the __access_ok -> access_ok

Ok, no problem. I can take that change as well, don't care much either way.

	Arnd <><
