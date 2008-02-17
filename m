Return-Path: <linux-kernel-owner+w=401wt.eu-S1752446AbYBQRu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446AbYBQRu6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 12:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750962AbYBQRuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 12:50:50 -0500
Received: from an-out-0708.google.com ([209.85.132.245]:52783 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbYBQRus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 12:50:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=wxbLiSiJvZJywMpP6l76lMbFeaWxJ/k3Mx9/4rciIrhnFt2p/A4ywKj13GwwoVq/IuUxcCySRERWwKEKdDytzZTdexKcleacG3+aDw1Mbve/Ik+SyaABKLjfxaZhBw3JXEVXniwiLq2C5id4JCphPTpsLY8MIh31g+hXbEZuflI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH] linux/hdsmart.h: fix goofups
Date: Sun, 17 Feb 2008 19:04:51 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>, linux-kernel@vger.kernel.org
References: <200802171807.57983.bzolnier@gmail.com> <200802171840.32180.bzolnier@gmail.com> <20080217173642.GC1403@cs181133002.pp.htv.fi>
In-Reply-To: <20080217173642.GC1403@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802171904.52188.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 February 2008, Adrian Bunk wrote:
> On Sun, Feb 17, 2008 at 06:40:31PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > On Sunday 17 February 2008, Robert P. J. Day wrote:
> > > On Sun, 17 Feb 2008, Bartlomiej Zolnierkiewicz wrote:
> > > 
> > > > Fix goofups of commit 76166952bbc81dda1c8a8c14e75a2aa06f6c052c
> > > > ("<linux/hdsmart.h> is not used by kernel code").
> > > >
> > > > Reported-by: "Robert P. J. Day" <rpjday@crashcourse.ca>
> > > > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > > > ---
> > > >  include/linux/hdsmart.h |    4 ++--
> > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > >
> > > > Index: b/include/linux/hdsmart.h
> > > > ===================================================================
> > > > --- a/include/linux/hdsmart.h
> > > > +++ b/include/linux/hdsmart.h
> > > > @@ -17,7 +17,7 @@
> > > >  #ifndef _LINUX_HDSMART_H
> > > >  #define _LINUX_HDSMART_H
> > > >
> > > > -#ifndef __KERNEL
> > > > +#ifndef __KERNEL__
> > > >  #define OFFLINE_FULL_SCAN		0
> > > >  #define SHORT_SELF_TEST			1
> > > >  #define EXTEND_SELF_TEST		2
> > > > @@ -121,6 +121,6 @@ typedef struct ata_smart_selftestlog_s {
> > > >  	unsigned char			resevered[2];
> > > >  	unsigned char			chksum;
> > > >  } __attribute__ ((packed)) ata_smart_selftestlog_t;
> > > > -#endif /* __KERNEL__ *
> > > > +#endif /* __KERNEL__ */
> > > >
> > > >  #endif	/* _LINUX_HDSMART_H */
> > > 
> > > if that header file isn't used by any kernel code, why bother having a
> > > check for __KERNEL__ in the first place?  it's being exported to
> > > userspace unchecked:
> > > 
> > >   include/linux/Kbuild:header-y += hdsmart.h
> > > 
> > > so why not just toss that check entirely?  otherwise, you're going to
> > > get a header file exported to userspace that has a superfluous
> > > __KERNEL__ test in it.
> > 
> > We don't want new (accidental etc.) kernel users of this header. 
> >...
> 
> Why can't we simply remove it?

If it is safe w.r.t. userspace then please do it.

[ I don't know and I couldn't get an answer on LKML so... ]

Thanks,
Bart
