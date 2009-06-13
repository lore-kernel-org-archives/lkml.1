Return-Path: <linux-kernel-owner+w=401wt.eu-S1763882AbZFMXAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763882AbZFMXAO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 19:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbZFMXAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 19:00:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:51021 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbZFMXAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 19:00:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 06/14] Pramfs: Include files
Date: Sun, 14 Jun 2009 00:59:56 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: Marco <marco.stornelli@gmail.com>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
References: <4A33A7EC.6070008@gmail.com> <20090613140459.GC30053@uranus.ravnborg.org>
In-Reply-To: <20090613140459.GC30053@uranus.ravnborg.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906140059.57362.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+2UvSCMc/sDoNpgmb/dwTwqVBDZkENUOzj5+z
 80AwM13i763piEd1eQh5FKn1mlXssB4K1802tkE1Mz+69xjjGB
 UCmsTi1M+7wOBMy52dqifGwvWgY0dIr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 13 June 2009, Sam Ravnborg wrote:
> > +     union {
> > +             struct {
> > +                     /*
> > +                      * ptr to row block of 2D block pointer array,
> > +                      * file block #'s 0 to (blocksize/4)^2 - 1.
> > +                      */
> > +                     off_t row_block;
> 
> It is my understanding that we shall use: __kernel_off_t
> in exported headers.

That is a correct understanding in general, however this case is
different, because it describes an on-disk data structure,
not a kernel to user space interface. Here, __kernel_off_t is just
as wrong as off_t, because it will differ between 32 and 64 bit
architectures, making the fs layout incompatible. I'd suggest
simply defining this as __u64.

Moreover, file system layout should be described in terms of
big-endian or little-endian types (e.g. __be64 or __le64),
together with the right accessor functions.

	Arnd <><
