Return-Path: <linux-kernel-owner+w=401wt.eu-S1756477AbYBQR1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477AbYBQR1K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 12:27:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbYBQR05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 12:26:57 -0500
Received: from wx-out-0506.google.com ([66.249.82.238]:8066 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbYBQR04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 12:26:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=QB5q/n417xLThZPMZu62OBagBsKvqCHe16t2JJEv2Gu6vvFmwCehW9ltbQaPBhXcRvPxLTmtcRxYq310RWyKjCAYfI3bbObMNGLOTqbzlrcWYE2Ns15ra5BpI75X1SKyPhMS1nhQZ38ZLJKCgXMODx+YH1dpB4aL7RhMv/B/epM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: [PATCH] linux/hdsmart.h: fix goofups
Date: Sun, 17 Feb 2008 18:40:31 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
References: <200802171807.57983.bzolnier@gmail.com> <alpine.LFD.1.00.0802171214380.3515@localhost.localdomain>
In-Reply-To: <alpine.LFD.1.00.0802171214380.3515@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802171840.32180.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 February 2008, Robert P. J. Day wrote:
> On Sun, 17 Feb 2008, Bartlomiej Zolnierkiewicz wrote:
> 
> > Fix goofups of commit 76166952bbc81dda1c8a8c14e75a2aa06f6c052c
> > ("<linux/hdsmart.h> is not used by kernel code").
> >
> > Reported-by: "Robert P. J. Day" <rpjday@crashcourse.ca>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> >  include/linux/hdsmart.h |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > Index: b/include/linux/hdsmart.h
> > ===================================================================
> > --- a/include/linux/hdsmart.h
> > +++ b/include/linux/hdsmart.h
> > @@ -17,7 +17,7 @@
> >  #ifndef _LINUX_HDSMART_H
> >  #define _LINUX_HDSMART_H
> >
> > -#ifndef __KERNEL
> > +#ifndef __KERNEL__
> >  #define OFFLINE_FULL_SCAN		0
> >  #define SHORT_SELF_TEST			1
> >  #define EXTEND_SELF_TEST		2
> > @@ -121,6 +121,6 @@ typedef struct ata_smart_selftestlog_s {
> >  	unsigned char			resevered[2];
> >  	unsigned char			chksum;
> >  } __attribute__ ((packed)) ata_smart_selftestlog_t;
> > -#endif /* __KERNEL__ *
> > +#endif /* __KERNEL__ */
> >
> >  #endif	/* _LINUX_HDSMART_H */
> 
> if that header file isn't used by any kernel code, why bother having a
> check for __KERNEL__ in the first place?  it's being exported to
> userspace unchecked:
> 
>   include/linux/Kbuild:header-y += hdsmart.h
> 
> so why not just toss that check entirely?  otherwise, you're going to
> get a header file exported to userspace that has a superfluous
> __KERNEL__ test in it.

We don't want new (accidental etc.) kernel users of this header. 

How's about this version?

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] linux/hdsmart.h: fix goofups (take 2)

Fix goofups of commit 76166952bbc81dda1c8a8c14e75a2aa06f6c052c
("<linux/hdsmart.h> is not used by kernel code").

Also update include/linux/Kbuild to reflect the fact that hdsmart.h
uses __KERNEL__ ifdefs now.

Reported-by: "Robert P. J. Day" <rpjday@crashcourse.ca>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 include/linux/Kbuild    |    2 +-
 include/linux/hdsmart.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: b/include/linux/Kbuild
===================================================================
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -70,7 +70,6 @@ header-y += fuse.h
 header-y += genetlink.h
 header-y += gen_stats.h
 header-y += gigaset_dev.h
-header-y += hdsmart.h
 header-y += hysdn_if.h
 header-y += i2o-dev.h
 header-y += i8k.h
@@ -211,6 +210,7 @@ unifdef-y += hayesesp.h
 unifdef-y += hdlcdrv.h
 unifdef-y += hdlc.h
 unifdef-y += hdreg.h
+unifdef-y += hdsmart.h
 unifdef-y += hiddev.h
 unifdef-y += hpet.h
 unifdef-y += i2c.h
Index: b/include/linux/hdsmart.h
===================================================================
--- a/include/linux/hdsmart.h
+++ b/include/linux/hdsmart.h
@@ -17,7 +17,7 @@
 #ifndef _LINUX_HDSMART_H
 #define _LINUX_HDSMART_H
 
-#ifndef __KERNEL
+#ifndef __KERNEL__
 #define OFFLINE_FULL_SCAN		0
 #define SHORT_SELF_TEST			1
 #define EXTEND_SELF_TEST		2
@@ -121,6 +121,6 @@ typedef struct ata_smart_selftestlog_s {
 	unsigned char			resevered[2];
 	unsigned char			chksum;
 } __attribute__ ((packed)) ata_smart_selftestlog_t;
-#endif /* __KERNEL__ *
+#endif /* __KERNEL__ */
 
 #endif	/* _LINUX_HDSMART_H */
