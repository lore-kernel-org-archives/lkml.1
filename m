Return-Path: <linux-kernel-owner+w=401wt.eu-S932403AbZABXUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403AbZABXUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 18:20:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbZABXUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 18:20:45 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:58635 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbZABXUo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 18:20:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] headers_install.pl: autoconvert asm/inline/volatile to __xxx__
Date: Sat, 3 Jan 2009 00:20:34 +0100
User-Agent: KMail/1.9.9
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
References: <1230364498-31620-1-git-send-email-vapier@gentoo.org> <200812311815.09031.arnd@arndb.de> <200812311734.06124.vapier@gentoo.org>
In-Reply-To: <200812311734.06124.vapier@gentoo.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901030020.35237.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18nSFZSN5oe7HPkoxmINn/Ffi0Scl1ELQKRRzg
 RhAfDrE75rwtXMGqzIl2QJ2XscAI1sOsodXqkak1vSDpR+IBV0
 MsXmqNh2d4Nfb2rSlcJ2w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 December 2008, Mike Frysinger wrote:
> On Wednesday 31 December 2008 12:15:07 Arnd Bergmann wrote:
> > On Saturday 27 December 2008, Mike Frysinger wrote:
> > > Headers in userspace should be using the __xxx__ form of the asm, inline,
> > > and volatile keywords.  Since people like to revert these things without
> > > realizing what's going on, have the headers install step autoconvert
> > > these keywords.
> > >
> > > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> >
> > The patch looks right, but I would argue that most of the instances of
> > any of these should not be exported in the first place. I'm not
> > sure whether there is a legitimate use for the byteorder inlines,
> > but the others I could find look like they are not meant for use by the
> > kernel.
> 
> maybe, but those threads are going to take quite a while to resolve and things 
> will constantly leak back out.

I guess I forgot to make my main point, I'm not arguing against your patch
at all, but would also like to see another patch to headers_check.pl that
warns about all instances of the __asm__, __inline__ and volatile keywords,
possibly with a list of known good cases.

Since you already have on the patch to warn about the extern declarations
and Sam submitted a respective patch for the CONFIG_ symbols, it would be
good to add these keywords to the same check.

Your headers_install.pl patch is required for correctness with pedantic
compilers, while the one I suggest would only help reducing the leak
of kernel internal code into user space headers.

	Arnd <><
