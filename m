Return-Path: <linux-kernel-owner+w=401wt.eu-S1753880AbYLHPwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbYLHPwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 10:52:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbYLHPv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 10:51:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:60361 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbYLHPv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 10:51:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: dedekind@infradead.org
Subject: Re: UBI/DVB ioctl conflict?
Date: Mon, 8 Dec 2008 16:50:53 +0100
User-Agent: KMail/1.9.9
Cc: Laurent Pinchart <laurentp@cse-semaphore.com>,
       linux-mtd@lists.infradead.org, Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       v4l-dvb-maintainer@linuxtv.org, LKML <linux-kernel@vger.kernel.org>
References: <20081207095811.13b51cca@zod.rchland.ibm.com> <200812081041.14178.laurentp@cse-semaphore.com> <1228729915.13686.95.camel@sauron>
In-Reply-To: <1228729915.13686.95.camel@sauron>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812081650.54346.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/6DYJr5RhUdHpA0VEi6hhVea9dOY/ELD25ixv
 21CP6m6l+sAkpQvKIaUm+H64FLlIrB+2qvexDH02pb69Qz2rD5
 ZbUzc28aONQ1pkZnhxBZA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 December 2008, Artem Bityutskiy wrote:
> On Mon, 2008-12-08 at 10:41 +0100, Laurent Pinchart wrote:
> > Correct me if I'm wrong, but doesn't this only matters for devices that would 
> > implement both the UBI and DVB API on the same inode ? That would be quite 
> > unlikely.
> 
> Yeah, I guess. But this anyway makes sense to keep ioctls
> non-overlapping.

We try hard (but sometimes fail) to keep every ioctl number unique.
The reason for this is that the device drivers are not the only
pieces of code that look at them. Specifically, three other things
frequently cause problems here:

* strace wants to know about ioctl numbers so that it can show
the arguments in a meaningful way when tracing a program.

* the original 64 bit emulation for ioctl numbers in fs/compat_ioctl.c
assumes that it should translate specific calls in a given way. This
is not important if both device drivers handle all their ioctls through
their own ->compat_ioctl file operation.

* A number of binary emulation layers try to convert between different
formats (endianess, word size, ioctl numbers). The most common ones are
Linux-on-BSD, x86-on-ia64, x86-on-powerpc and Unix-on-Linux emulation
layers in user space.

	Arnd <><
