Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbYFZWJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbYFZWJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 18:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbYFZWJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 18:09:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52179 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbYFZWJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 18:09:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 48/60] microblaze_v4: headers simple files - empty or redirect to asm-generic
Date: Fri, 27 Jun 2008 00:09:11 +0200
User-Agent: KMail/1.9.9
Cc: Adrian Bunk <bunk@kernel.org>, monstr@seznam.cz,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk,
       Michal Simek <monstr@monstr.eu>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz> <200806261838.33787.arnd@arndb.de> <4863D87F.5060103@zytor.com>
In-Reply-To: <4863D87F.5060103@zytor.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806270009.12378.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/Y8IxQBZaVsslbYs2WAZ7w6sHdrNADoyoCkuH
 00FDClgo/MxWUx7bcoUwODGtfWQfnnwC2AXYQ2mdKN+Obx6NOQ
 S3Fa0gaF29IN+AnGaImYA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 June 2008, H. Peter Anvin wrote:
> 
> The sanest way to do that would probably be something along the lines of:
> 
> -> Change include/asm-xxx to arch/xxx/include/asm

Sam Ravnborg is already working on this part.

> -> Create arch/generic
> -> Make sure arch/xxx/include/asm and arch/generic/include/asm are both 
> in the include path, in that order.
> 
> That would also get rid of the symlink.

It requires two more steps:

- change all remaining users of #include <asm-generic/*.h> to include
that file with the new name, e.g. #include <generic/asm/foo.h> if we
have it in the right path.
- change the way 'make headers_install' works so that the files get
installed to the right location in $PREFIX/include/asm/ instead of
$PREFIX/include/asm-generic/ for each header that does not exist
in arch/foo/include/asm.

These changes are probably somewhat controversial, and the first
one is much more invasive than the patches that Sam has, so I'd
not want to do them at the same time.

> On the other hand, the redirection isn't all that bad.

Agreed. I just have the hope that someone comes up with the magical
solution for this problem that makes it a lot nicer than the suggestions
so far or the current way of doing it ;-)

	Arnd <><
