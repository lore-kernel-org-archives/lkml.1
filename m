Return-Path: <linux-kernel-owner+w=401wt.eu-S1757567AbZAUJJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567AbZAUJJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 04:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbZAUJJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 04:09:39 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:60348 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbZAUJJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 04:09:38 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Subject: Re: Confusion in usr/include/linux/videodev.h
Date: Wed, 21 Jan 2009 10:09:13 +0100
User-Agent: KMail/1.9.9
Cc: Trent Piepho <xyzzy@speakeasy.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       linux-media@vger.kernel.org, video4linux-list@redhat.com,
       Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
References: <1232502038.3123.61.camel@localhost.localdomain> <Pine.LNX.4.58.0901210048500.13170@shell2.speakeasy.net> <3f9a31f40901210059g51d46f56t85364d886b757a6e@mail.gmail.com>
In-Reply-To: <3f9a31f40901210059g51d46f56t85364d886b757a6e@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901211009.14856.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX197JVhuhVkhqSJLDLmPEbzlmVRq6avkeN56Gnd
 xJhaC5udinRz2grxHFvORkB0QHyp2sOwafcxcKqv+aIfvLoiv7
 oVPffEY8OkW78o8MdmH6g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 January 2009, Jaswinder Singh Rajput wrote:

> > diff -r 29c5787efcda linux/include/linux/videodev.h
> > --- a/linux/include/linux/videodev.h    Thu Jan 15 09:07:03 2009 -0800
> > +++ b/linux/include/linux/videodev.h    Wed Jan 21 00:51:45 2009 -0800
> > @@ -15,7 +15,8 @@
> >  #include <linux/ioctl.h>
> >  #include <linux/videodev2.h>
> >
> > -#if defined(CONFIG_VIDEO_V4L1_COMPAT) || !defined (__KERNEL__)
> > +#if (defined(__KERNEL__) && defined(CONFIG_VIDEO_V4L1_COMPAT)) \
> > +    || !defined (__KERNEL__)
> >
> >  #define VID_TYPE_CAPTURE       1       /* Can capture */
> >  #define VID_TYPE_TUNER         2       /* Can tune */
> >
> > Now CONFIG_VIDEO_V4L1_COMPAT will only be used in the kernel.
> >
> 
> No, this will still give warnings.

You could #define another conditional, like this:

#ifndef __KERNEL__
# define __V4L1_COMPAT_API /* Always provide definitions to user space */
#else /* __KERNEL__ */
# ifdef CONFIG_VIDEO_V4L1_COMPAT
#  define __V4L1_COMPAT_API
# endif /* CONFIG_VIDEO_V4L1_COMPAT /*
#endif /* __KERNEL__ */

	Arnd <><
