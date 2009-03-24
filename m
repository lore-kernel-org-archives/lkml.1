Return-Path: <linux-kernel-owner+w=401wt.eu-S1760216AbZCXNR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760216AbZCXNR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 09:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754461AbZCXNRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 09:17:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58564 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645AbZCXNRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 09:17:17 -0400
Date: Tue, 24 Mar 2009 14:17:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Arnd Bergmann <arnd@arndb.de>, eduard.munteanu@linux360.ro,
       linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 2/2] fs: don't include <linux/gfp.h> to fix
	headers-export-check
Message-ID: <20090324131709.GA21720@elte.hu>
References: <1237888763.25315.70.camel@penberg-laptop> <200903241412.09730.arnd@arndb.de> <1237900458.25315.88.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237900458.25315.88.camel@penberg-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On Tue, 2009-03-24 at 14:12 +0100, Arnd Bergmann wrote:
> > On Tuesday 24 March 2009, Pekka Enberg wrote:
> > >    
> > > From: Pekka Enberg <penberg@cs.helsinki.fi>
> > > 
> > > Impact: fix build
> > > 
> > > This patch fixes a headers-export-check failure:
> > > 
> > >   /home/mingo/tip/usr/include/linux/bsg.h:11: found __[us]{8,16,32,64} type without #include <linux/types.h>
> > >   /home/mingo/tip/usr/include/linux/fs.h:11: included file 'linux/gfp.h' is not exported
> > >   make[3]: *** [/home/mingo/tip/usr/include/linux/.check] Error 1
> > >   make[2]: *** [linux] Error 2
> > > 
> > > Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> > > Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> > > ---
> > >  include/linux/fs.h |   16 ++++++----------
> > >  1 files changed, 6 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > > index add95da..11fdc57 100644
> > > --- a/include/linux/fs.h
> > > +++ b/include/linux/fs.h
> > > @@ -8,7 +8,6 @@
> > >  
> > >  #include <linux/limits.h>
> > >  #include <linux/ioctl.h>
> > > -#include <linux/gfp.h>
> > >  
> > >  /*
> > 
> > I think a cleaner fix would be to move the include of gfp.h into the
> > second #include block that is part of #ifdef __KERNEL__, as is the
> > only user of get_zeroed_page in there.
> 
> Alexey suggested putting the functions in security.h instead which 
> is even better. I'll submit that formally as soon as I have the 
> chance to test it.

yep. Hopefully it wont have ripple effects. The whole house of cards 
called include/linux/*.h seems to be imploding ;-)

	Ingo
