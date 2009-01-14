Return-Path: <linux-kernel-owner+w=401wt.eu-S1757892AbZANUEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbZANUEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 15:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbZANUEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 15:04:25 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:33148 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961AbZANUEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 15:04:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gzBMI3joiQWJFQZPJdDbGDVwO+zg2Jnxxrvobo5tGnwdvGoMtU1lRgQz0XdYNiMgsB
         H2zbKYUr0Ws6hxNbqRpRw9fOwrusMTuAwEDxX1oO7gVag6wwhYe13fNOh2nbANNYypiJ
         uRTd4791Ok/vhQdXqoppua51WSom0QQ4xCrk8=
Subject: Re: [PATCH -tip] nubus.h: extern's make no sense in userspace
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Jaswinder Singh Rajput <jaswinder@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       sam@ravnborg.org, gorcunov@gmail.com,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0901131001200.19352@vixen.sonytel.be>
References: <1231832906.3212.24.camel@jaswinder.satnam>
	 <Pine.LNX.4.64.0901131001200.19352@vixen.sonytel.be>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 12:04:21 -0800
Message-Id: <1231963461.5756.9.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-13 at 10:03 +0100, Geert Uytterhoeven wrote:
> On Tue, 13 Jan 2009, Jaswinder Singh Rajput wrote:
> > Impact: cleanup, Impact: fix 3 make headers_check warnings:
> > 
> > usr/include/linux/nubus.h:298: extern's make no sense in userspace
> > usr/include/linux/nubus.h:300: extern's make no sense in userspace
> > usr/include/linux/nubus.h:304: extern's make no sense in userspace
> > 
> > Also moved nubus_scan_bus() in __KERNEL__
> > 
> > Also removed obsolete get_nubus_list()
> > 
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > ---
> >  include/linux/nubus.h |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/linux/nubus.h b/include/linux/nubus.h
> > index bd31554..9f54a23 100644
> > --- a/include/linux/nubus.h
> > +++ b/include/linux/nubus.h
> > @@ -297,6 +297,7 @@ struct nubus_dev {
> >  	struct nubus_board* board;
> >  };
> >  
> > +#ifdef __KERNEL__
> >  /* This is all NuBus devices (used to find devices later on) */
> >  extern struct nubus_dev* nubus_devices;
> >  /* This is all NuBus cards */
> > @@ -305,7 +306,7 @@ extern struct nubus_board* nubus_boards;
> >  /* Generic NuBus interface functions, modelled after the PCI interface */
> >  void nubus_scan_bus(void);
> >  extern void nubus_proc_init(void);
> > -int get_nubus_list(char *buf);
> > +#endif /* __KERNEL__ */
> >  int nubus_proc_attach_device(struct nubus_dev *dev);
>    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >  int nubus_proc_detach_device(struct nubus_dev *dev);
>    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >  /* If we need more precision we can add some more of these */
> 
> What about these? They (unfortunately) lack the "extern" keyword, but they're
> still external declarations, and "make headers_check' doesn't notice them?
> 
> BTW, is there a way to tell gcc to warn about externs not marked "extern", so
> we can fix all of them?

I had a look at this file, there's the small patch that just wraps the whole
section of function declarations with ifdef __KERNEL, or the larger patch
that does the wrapping _and_ adds the missing externs to make it obvious.

But I'm not sure that there is agreement regarding adding the externs too.

What do people think?

Harvey

