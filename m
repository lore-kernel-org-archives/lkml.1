Return-Path: <linux-kernel-owner+w=401wt.eu-S1760579AbZCXNOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760579AbZCXNOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 09:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759909AbZCXNOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 09:14:22 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51317 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701AbZCXNOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 09:14:21 -0400
Subject: Re: [PATCH 2/2] fs: don't include <linux/gfp.h> to fix
	headers-export-check
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Arnd Bergmann <arnd@arndb.de>
Cc: mingo@elte.hu, eduard.munteanu@linux360.ro, linux-kernel@vger.kernel.org,
       Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <200903241412.09730.arnd@arndb.de>
References: <1237888763.25315.70.camel@penberg-laptop>
	 <200903241412.09730.arnd@arndb.de>
Date: Tue, 24 Mar 2009 15:14:18 +0200
Message-Id: <1237900458.25315.88.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-24 at 14:12 +0100, Arnd Bergmann wrote:
> On Tuesday 24 March 2009, Pekka Enberg wrote:
> >    
> > From: Pekka Enberg <penberg@cs.helsinki.fi>
> > 
> > Impact: fix build
> > 
> > This patch fixes a headers-export-check failure:
> > 
> >   /home/mingo/tip/usr/include/linux/bsg.h:11: found __[us]{8,16,32,64} type without #include <linux/types.h>
> >   /home/mingo/tip/usr/include/linux/fs.h:11: included file 'linux/gfp.h' is not exported
> >   make[3]: *** [/home/mingo/tip/usr/include/linux/.check] Error 1
> >   make[2]: *** [linux] Error 2
> > 
> > Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> > Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> > ---
> >  include/linux/fs.h |   16 ++++++----------
> >  1 files changed, 6 insertions(+), 10 deletions(-)
> > 
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index add95da..11fdc57 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -8,7 +8,6 @@
> >  
> >  #include <linux/limits.h>
> >  #include <linux/ioctl.h>
> > -#include <linux/gfp.h>
> >  
> >  /*
> 
> I think a cleaner fix would be to move the include of gfp.h into the
> second #include block that is part of #ifdef __KERNEL__, as is the
> only user of get_zeroed_page in there.

Alexey suggested putting the functions in security.h instead which is
even better. I'll submit that formally as soon as I have the chance to
test it.

			Pekka

