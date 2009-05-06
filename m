Return-Path: <linux-kernel-owner+w=401wt.eu-S1757594AbZEFVeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbZEFVeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 17:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755357AbZEFVem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:34:42 -0400
Received: from mail.crca.org.au ([67.207.131.56]:33146 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbZEFVel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:34:41 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [PATCH 9/19] TuxOnIce: Netlink support.
From: Nigel Cunningham <nigel@tuxonice.net>
Reply-To: nigel@tuxonice.net
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       tuxonice-devel@lists.tuxonice.net
In-Reply-To: <20090506210330.GA29496@uranus.ravnborg.org>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
	 <1241620755-22133-10-git-send-email-nigel@tuxonice.net>
	 <20090506210330.GA29496@uranus.ravnborg.org>
Content-Type: text/plain
Date: Thu, 07 May 2009 07:35:38 +1000
Message-Id: <1241645738.19600.97.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam.

On Wed, 2009-05-06 at 23:03 +0200, Sam Ravnborg wrote:
> On Thu, May 07, 2009 at 12:39:05AM +1000, Nigel Cunningham wrote:
> > This patch adds support for communicating with a userspace helper via a
> > netlink socket. It is used by the userspace user interface support and
> > by the storage manager support.
> > 
> > Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
> > ---
> >  kernel/power/Makefile           |    4 +
> >  kernel/power/tuxonice_netlink.c |  339 +++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 343 insertions(+), 0 deletions(-)
> >  create mode 100644 kernel/power/tuxonice_netlink.c
> > 
> > diff --git a/kernel/power/Makefile b/kernel/power/Makefile
> > index 07efc8a..180b89a 100644
> > --- a/kernel/power/Makefile
> > +++ b/kernel/power/Makefile
> > @@ -10,6 +10,10 @@ tuxonice_core-objs := tuxonice_modules.o tuxonice_sysfs.o tuxonice_highlevel.o \
> >  
> >  obj-$(CONFIG_TOI)		+= tuxonice_builtin.o
> >  
> > +ifdef CONFIG_NET
> > +tuxonice_core-objs		+= tuxonice_netlink.o
> > +endif
> 
> If you replace tuxonice_core-objs with tuxonice_core-y in your MAkefile the
> above can be simplified to:
> tuxonice_core-$(CONFIG_NET) += tuxonice_netlink.o
> 
> (On the assumption that CONFIG_NET is a bool)

Thanks for the review.

I have support for building tuxonice as modules that I'm not asking to
be merged (at least not yet - it adds too many symbol exports at the
moment). As a result, I did the simplification but left the
tuxonice_core_objs definition. Is that what you'd do?

Regards,

Nigel

