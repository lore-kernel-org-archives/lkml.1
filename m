Return-Path: <linux-kernel-owner+w=401wt.eu-S1758174AbZANUIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174AbZANUIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 15:08:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbZANUIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 15:08:37 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:59945 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbZANUIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 15:08:36 -0500
Date: Wed, 14 Jan 2009 21:10:19 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Jaswinder Singh Rajput <jaswinder@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       gorcunov@gmail.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] nubus.h: extern's make no sense in userspace
Message-ID: <20090114201019.GB1556@uranus.ravnborg.org>
References: <1231832906.3212.24.camel@jaswinder.satnam> <Pine.LNX.4.64.0901131001200.19352@vixen.sonytel.be> <1231963461.5756.9.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231963461.5756.9.camel@brick>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 12:04:21PM -0800, Harvey Harrison wrote:
> On Tue, 2009-01-13 at 10:03 +0100, Geert Uytterhoeven wrote:
> > On Tue, 13 Jan 2009, Jaswinder Singh Rajput wrote:
> > > Impact: cleanup, Impact: fix 3 make headers_check warnings:
> > > 
> > > usr/include/linux/nubus.h:298: extern's make no sense in userspace
> > > usr/include/linux/nubus.h:300: extern's make no sense in userspace
> > > usr/include/linux/nubus.h:304: extern's make no sense in userspace
> > > 
> > > Also moved nubus_scan_bus() in __KERNEL__
> > > 
> > > Also removed obsolete get_nubus_list()
> > > 
> > > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > > ---
> > >  include/linux/nubus.h |    3 ++-
> > >  1 files changed, 2 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/include/linux/nubus.h b/include/linux/nubus.h
> > > index bd31554..9f54a23 100644
> > > --- a/include/linux/nubus.h
> > > +++ b/include/linux/nubus.h
> > > @@ -297,6 +297,7 @@ struct nubus_dev {
> > >  	struct nubus_board* board;
> > >  };
> > >  
> > > +#ifdef __KERNEL__
> > >  /* This is all NuBus devices (used to find devices later on) */
> > >  extern struct nubus_dev* nubus_devices;
> > >  /* This is all NuBus cards */
> > > @@ -305,7 +306,7 @@ extern struct nubus_board* nubus_boards;
> > >  /* Generic NuBus interface functions, modelled after the PCI interface */
> > >  void nubus_scan_bus(void);
> > >  extern void nubus_proc_init(void);
> > > -int get_nubus_list(char *buf);
> > > +#endif /* __KERNEL__ */
> > >  int nubus_proc_attach_device(struct nubus_dev *dev);
> >    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > >  int nubus_proc_detach_device(struct nubus_dev *dev);
> >    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > >  /* If we need more precision we can add some more of these */
> > 
> > What about these? They (unfortunately) lack the "extern" keyword, but they're
> > still external declarations, and "make headers_check' doesn't notice them?
> > 
> > BTW, is there a way to tell gcc to warn about externs not marked "extern", so
> > we can fix all of them?
> 
> I had a look at this file, there's the small patch that just wraps the whole
> section of function declarations with ifdef __KERNEL, or the larger patch
> that does the wrapping _and_ adds the missing externs to make it obvious.
> 
> But I'm not sure that there is agreement regarding adding the externs too.
> 
> What do people think?

The general consensus is to add externs for new prototypes.
So if _and only if_ you are anyway touching this file in that area then
I would say - add the externs. But just adding externs are not (yet)
worth a patch alone.

	Sam
