Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbXEXVKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbXEXVKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 17:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbXEXVKC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 17:10:02 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:40873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751117AbXEXVKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 17:10:00 -0400
Date: Thu, 24 May 2007 14:09:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ben Collins <ben.collins@ubuntu.com>
Cc: linux-kernel@vger.kernel.org, Zachary Amsden <zach@vmware.com>
Subject: Re: [PATCH 4/6] RTC: Ratelimit "lost interrupts" message
Message-Id: <20070524140956.12ff7c99.akpm@linux-foundation.org>
In-Reply-To: <1180040212.12570.279.camel@cunning>
References: <98cd38b5.git.bcollins@ubuntu.com>
	<e5ea703bf068a19cc9a4cc76a9b6b8990380ee75.1179964369.git.bcollins@ubuntu.com>
	<20070524134822.ed020127.akpm@linux-foundation.org>
	<1180040212.12570.279.camel@cunning>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007 16:56:52 -0400
Ben Collins <ben.collins@ubuntu.com> wrote:

> On Thu, 2007-05-24 at 13:48 -0700, Andrew Morton wrote:
> > On Wed, 23 May 2007 18:23:06 -0400
> > Ben Collins <bcollins@ubuntu.com> wrote:
> > 
> > > Signed-off-by: Ben Collins <bcollins@ubuntu.com>
> > > ---
> > >  drivers/char/rtc.c |    3 ++-
> > >  1 files changed, 2 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/char/rtc.c b/drivers/char/rtc.c
> > > index 20380a2..22cf7aa 100644
> > > --- a/drivers/char/rtc.c
> > > +++ b/drivers/char/rtc.c
> > > @@ -1159,7 +1159,8 @@ static void rtc_dropped_irq(unsigned long data)
> > >  
> > >  	spin_unlock_irq(&rtc_lock);
> > >  
> > > -	printk(KERN_WARNING "rtc: lost some interrupts at %ldHz.\n", freq);
> > > +	if (printk_ratelimit())
> > > +		printk(KERN_WARNING "rtc: lost some interrupts at %ldHz.\n", freq);
> > >  
> > 
> > Presumably someone is getting a lot of these messages.
> > 
> > Do we know why?  Is there something which needs fixing here?
> 
> I got it a lot when using any sort of virtualization on my Core2Duo
> (kvm, vmware, qemu). Just a big spew. Honestly, I was getting this with
> 2.6.20, and haven't tested again with latest kernel.

OK, a bit of googling finds things like this:
http://chxo.com/be2/20060821_3333.html, so I assume that it's some sort of
generic problem with the hypervisor's emulation of the RTC.

Zach, do you know what the score is here?

Thanks.
